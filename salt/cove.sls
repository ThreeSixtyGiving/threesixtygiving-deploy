
#############################################################################
# This salt deploys a cove instance from  360's dataquality repo            #
#############################################################################

# For a live deploy, please follow the instructions at https://cove.readthedocs.io/en/latest/deployment/
{% from 'lib.sls' import createuser, apache, uwsgi, removeapache, removeuwsgi %}

# Ubuntu 20 only!
# See git history of this file for how to install on older servers

{% set user = 'cove' %}
{{ createuser(user) }}

{% set giturl = 'https://github.com/threesixtygiving/dataquality.git' %}



{% if pillar.cove.gitbranch %}
  {% set checkout_dir="/home/"+user+"/dataquality/" %}
{% else %}
  {% set checkout_dir="/home/"+user+"/dataquality/" %}
{% endif %}



# libapache2-mod-wsgi-py3
# gettext

include:
  - core
  - apache
  - uwsgi
{% if 'https' in pillar.cove %}  - letsencrypt{% endif %}

cove-deps:
    apache_module.enabled:
      - name: proxy proxy_uwsgi
      - watch_in:
        - service: apache2
    pkg.installed:
      - pkgs:
        - libapache2-mod-proxy-uwsgi
        - python3-pip
        - python3-virtualenv
        - python3-dev
        - gcc
        - libxslt1-dev
        - uwsgi-plugin-python3
        - gettext
      - watch_in:
        - service: apache2
        - service: uwsgi

remoteip:
    apache_module.enabled:
      - watch_in:
        - service: apache2

{% macro cove(name, giturl, branch, djangodir, user, uwsgi_port, servername=None, app='cove_project', assets_base_url='') %}


{% set extracontext %}

checkout_dir: {{ checkout_dir }}
djangodir: {{ djangodir }}
{% if grains['osrelease'] == '16.04' %}
uwsgi_port: null
{% else %}
uwsgi_port: {{ uwsgi_port }}
{% endif %}
branch: {{ branch }}
app: {{ app }}
bare_name: {{ name }}
assets_base_url: {{ assets_base_url }}
{% endset %}

{% if 'https' in pillar.cove %}
{{ apache(user+'.conf',
    name=name+'.conf',
    extracontext=extracontext,
    servername=servername if servername else branch+'.'+grains.fqdn,
    serveraliases=[ branch+'.'+grains.fqdn ] if servername else [],
    https=pillar.cove.https) }}
{% else %}
{{ apache(user+'.conf',
    name=name+'.conf',
    servername=servername if servername else 'default',
    extracontext=extracontext) }}
{% endif %}

{{ uwsgi(user+'.ini',
    name=name+'.ini',
    extracontext=extracontext,
    port=uwsgi_port) }}

{{ giturl }}{{ djangodir }}:
  git.latest:
    - name: {{ giturl }}
    - rev: {{ branch }}
    - target: {{ checkout_dir }}
    - user: {{ user }}
    - force_fetch: True
    - force_reset: True
    - require:
      - pkg: git
    - watch_in:
      - service: uwsgi

# We have seen different permissions on different servers and we have seen bugs arise due to problems with the permissions.
# Make sure the user and permissions are set correctly for the media folder and all it's contents!
# (This in itself won't make sure permissions are correct on new files, but it will sort any existing problems)
{{ djangodir }}/media:
  file.directory:
    - name: {{ djangodir }}/media
    - user: {{ user }}
    - dir_mode: 755
    - file_mode: 644
    - recurse:
      - user
      - mode

{{checkout_dir}}.ve/:
  virtualenv.managed:
    - python: /usr/bin/python3
    - user: {{ user }}
    - system_site_packages: False
    - require:
      - pkg: cove-deps
      - git: {{ giturl }}{{ djangodir }}
      - file: set_lc_all # required to avoid unicode errors for the "schema" library
    - watch_in:
      - service: apache2

# This should ideally be in virtualenv.managed but we get an error if we do that
{{ checkout_dir }}install-python-packages:
  cmd.run:
    - name: . {{ checkout_dir }}.ve/bin/activate; pip install -r {{checkout_dir}}/requirements_cove.txt
    - user: {{ user }}
    - cwd: {{ checkout_dir }}
    - require:
      - virtualenv: {{ checkout_dir }}.ve/

# Fix permissions in virtual env
{{ checkout_dir }}fix-ve-permissions:
  cmd.run:
    - name: chown -R {{ user }}:{{ user }} {{ checkout_dir }}.ve
    - user: root
    - cwd: {{ checkout_dir }}
    - require:
      - virtualenv: {{ checkout_dir }}.ve/

migrate-{{name}}:
  cmd.run:
    - name: . {{ checkout_dir }}.ve/bin/activate; DJANGO_SETTINGS_MODULE={{ app }}.settings python {{ djangodir }}/manage.py migrate --noinput
    - runas: {{ user }}
    - cwd: {{ djangodir }}
    - require:
      - virtualenv: {{ checkout_dir }}.ve/
    - onchanges:
      - git: {{ giturl }}{{ djangodir }}
      - cmd: {{ checkout_dir }}install-python-packages

compilemessages-{{name}}:
  cmd.run:
    - name: . {{ checkout_dir }}.ve/bin/activate; DJANGO_SETTINGS_MODULE={{ app }}.settings  python {{ djangodir }}/manage.py compilemessages
    - runas: {{ user }}
    - cwd: {{ djangodir }}
    - require:
      - virtualenv: {{ checkout_dir }}.ve/
      - cmd: {{ checkout_dir }}fix-ve-permissions
    - onchanges:
      - git: {{ giturl }}{{ djangodir }}
      - cmd: {{ checkout_dir }}install-python-packages

collectstatic-{{name}}:
  cmd.run:
    - name: . {{ checkout_dir }}.ve/bin/activate; DJANGO_SETTINGS_MODULE={{ app }}.settings  python {{ djangodir }}/manage.py collectstatic --noinput
    - runas: {{ user }}
    - cwd: {{ djangodir }}
    - require:
      - virtualenv: {{ checkout_dir }}.ve/
    - onchanges:
      - git: {{ giturl }}{{ djangodir }}
      - cmd: {{ checkout_dir }}install-python-packages

{{ djangodir }}static/:
  file.directory:
    - user: {{ user }}
    - file_mode: 644
    - dir_mode: 755
    - recurse:
      - mode
    - require:
      - cmd: collectstatic-{{name}}

{{ djangodir }}:
  file.directory:
    - dir_mode: 755
    - require:
      - cmd: collectstatic-{{name}}

cd {{ djangodir }}; . {{ checkout_dir }}.ve/bin/activate; DJANGO_SETTINGS_MODULE={{ app }}.settings SECRET_KEY="{{pillar.cove.secret_key}}" python manage.py expire_files:
  cron.present:
    - identifier: COVE_EXPIRE_FILES{% if name != 'cove' %}_{{ name }}{% endif %}
    - user: cove
    - minute: random
    - hour: 0
{% endmacro %}

{% macro removecove(name, djangodir, app) %}

{{ removeapache(name+'.conf') }}

{{ removeuwsgi(name+'.ini') }}

{{ djangodir }}:
    file.absent

cd {{ djangodir }}; . {{ checkout_dir }}.ve/bin/activate; DJANGO_SETTINGS_MODULE={{ app }}.settings SECRET_KEY="{{pillar.cove.secret_key}}" python manage.py expire_files:
  cron.absent:
    - identifier: COVE_EXPIRE_FILES{% if name != 'cove' %}_{{ name }}{% endif %}
    - user: cove

{% endmacro %}

MAILTO:
  cron.env_present:
    - value: code@opendataservices.coop
    - user: cove

## Run the macro

{{ cove(
    name='cove',
    giturl=pillar.cove.giturl if 'giturl' in pillar.cove else giturl,
    branch=pillar.cove.gitbranch if 'gitbranch' in pillar.cove else pillar.default_branch,
    djangodir=checkout_dir+'/cove/',
    uwsgi_port=pillar.cove.uwsgi_port if 'uwsgi_port' in pillar.cove else 3031,
    servername=pillar.cove.servername if 'servername' in pillar.cove else None,
    app=pillar.cove.app if 'app' in pillar.cove else 'cove',
    assets_base_url=pillar.cove.assets_base_url if 'assets_base_url' in pillar.cove else '',
    user=user) }}



# We were having problems with the Raven library for Sentry on Ubuntu 18
# https://github.com/getsentry/raven-python/issues/1311
# Reload the server manually after a short bit seemed to be the only fix.
# And we restart the server because when adding new sites, a reload crashes
# In testing, the code above seems not to always restart uwsgi anyway so we are happy putting this in.
# (Well, we are not happy about this situation at all, but we think this won't cause any problems at least.)
reload_uwsgi_service:
  cmd.run:
    - name: sleep 10; /etc/init.d/uwsgi restart
    - order: last
