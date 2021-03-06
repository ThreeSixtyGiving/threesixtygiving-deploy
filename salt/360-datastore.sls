
{% from 'lib.sls' import createuser, apache, uwsgi  %}

include:
  - apache
  - uwsgi
  - postgres10
  - letsencrypt

360-datastore-packages:
  pkg.installed:
    - pkgs:
      - virtualenv
      - python3-dev
      - build-essential
      - postgresql-10
      - postgresql-server-dev-10
      - postgresql-client
      - libapache2-mod-proxy-uwsgi
      - uwsgi-plugin-python3
    - watch_in:
      - service: apache2
      - service: uwsgi

  apache_module.enabled:
    - name: proxy proxy_uwsgi
    - watch_in:
      - service: apache2
      - service: uwsgi

{{ createuser(pillar.datastore.user) }}

##### Git checkout

/home/{{ pillar.datastore.user }}/datastore:
  git.latest:
    - name: {{ pillar.datastore.git_url }}
    - rev: {{ pillar.datastore.branch }}
    - target: /home/{{ pillar.datastore.user }}/datastore
    - user: {{ pillar.datastore.user }}
    - force_fetch: True
    - force_reset: True
    - require:
      - pkg: git

/home/{{ pillar.datastore.user }}/datatester:
  git.latest:
    - name: https://github.com/ThreeSixtyGiving/datatester.git
    - rev: {{ pillar.datatester.branch }}
    - target: /home/{{ pillar.datastore.user }}/datatester
    - user: {{ pillar.datastore.user }}
    - force_fetch: True
    - force_reset: True
    - require:
      - pkg: git


##### Install python deps in virtualenvs

/home/{{ pillar.datastore.user }}/datastore/.ve:
  virtualenv.managed:
    - python: /usr/bin/python3
    - user: {{ pillar.datastore.user }}
    - system_site_packages: False
    - requirements: /home/{{ pillar.datastore.user }}/datastore/requirements.txt
    - require:
      - git: /home/{{ pillar.datastore.user }}/datastore

/home/{{ pillar.datastore.user }}/datatester/.ve:
  virtualenv.managed:
    - python: /usr/bin/python3
    - user: {{ pillar.datastore.user }}
    - system_site_packages: False
    - requirements: /home/{{ pillar.datastore.user }}/datatester/requirements.txt
    - require:
      - git: /home/{{ pillar.datastore.user }}/datatester

##### Web user / pass

/etc/apache2/360.htpasswd:
  file.managed:
    - source: salt://private/datastore/360.htpasswd
    - makedirs: True


##### Datastore configs setup

/home/{{ pillar.datastore.user }}/datastore/datastore/settings/settings_360g.py:
  file.managed:
    - source: salt://private/datastore/settings_360g.py
    - template: jinja
    - context:
       datastore: {{ pillar.datastore }}
       datastore_private: {{ pillar.datastore_private }}
    - require:
      - git: /home/{{ pillar.datastore.user }}/datastore


/home/{{ pillar.datastore.user }}/data_run_config.sh:
  file.managed:
    - source: salt://private/datastore/data_run_config.sh
    - template: jinja
    - context:
       datastore: {{ pillar.datastore }}
       datastore_private: {{ pillar.datastore_private }}
    - require:
      - git: /home/{{ pillar.datastore.user }}/datastore

##### Database

# Note on some VMs if the locale isn't setup correctly this will fail silently
postgresql:
  service:
    - running
    - enable: True
    - reload: True

database_setup:

  postgres_user.present:
    - name: {{ pillar.datastore.user }}
    - password: {{ pillar.datastore_private.postgresql_password }}
    - require:
      - service: postgresql

  postgres_database.present:
    - name: {{ pillar.datastore.database_name }}
    - owner: {{ pillar.datastore.user }}
    - require:
      - service: postgresql
      - postgres_user: {{ pillar.datastore.user }}


##### Colab

colab_notebooks:
  postgres_user.present:
    - password: {{ pillar.datastore_private.colab_pg_password }}
    - groups: readaccess
    - require:
      - service: postgresql

colab_notebooks1:
  postgres_user.present:
    - password: {{ pillar.datastore_private.colab_pg_password1 }}
    - groups: readaccess
    - require:
      - service: postgresql

colab_notebooks2:
  postgres_user.present:
    - password: {{ pillar.datastore_private.colab_pg_password2 }}
    - groups: readaccess
    - require:
      - service: postgresql

colab_notebooks3:
  postgres_user.present:
    - password: {{ pillar.datastore_private.colab_pg_password3 }}
    - groups: readaccess
    - require:
      - service: postgresql

colab_notebooks4:
  postgres_user.present:
    - password: {{ pillar.datastore_private.colab_pg_password4 }}
    - groups: readaccess
    - require:
      - service: postgresql

colab_notebooks5:
  postgres_user.present:
    - password: {{ pillar.datastore_private.colab_pg_password5 }}
    - groups: readaccess
    - require:
      - service: postgresql

colab_notebooks6:
  postgres_user.present:
    - password: {{ pillar.datastore_private.colab_pg_password6 }}
    - groups: readaccess
    - require:
      - service: postgresql

colab_notebooks7:
  postgres_user.present:
    - password: {{ pillar.datastore_private.colab_pg_password7 }}
    - groups: readaccess
    - require:
      - service: postgresql

colab_notebooks8:
  postgres_user.present:
    - password: {{ pillar.datastore_private.colab_pg_password8 }}
    - groups: readaccess
    - require:
      - service: postgresql

colab_notebooks9:
  postgres_user.present:
    - password: {{ pillar.datastore_private.colab_pg_password9 }}
    - groups: readaccess
    - require:
      - service: postgresql

colab_notebooks10:
  postgres_user.present:
    - password: {{ pillar.datastore_private.colab_pg_password10 }}
    - groups: readaccess
    - require:
      - service: postgresql


colab_notebooks11:
    postgres_user.present:
      - password: {{ pillar.datastore_private.colab_pg_password11 }}
      - groups: readaccess
      - require:
        - service: postgresql

colab_notebooks12:
    postgres_user.present:
      - password: {{ pillar.datastore_private.colab_pg_password12 }}
      - groups: readaccess
      - require:
        - service: postgresql

colab_notebooks13:
    postgres_user.present:
      - password: {{ pillar.datastore_private.colab_pg_password13 }}
      - groups: readaccess
      - require:
        - service: postgresql

colab_notebooks14:
    postgres_user.present:
      - password: {{ pillar.datastore_private.colab_pg_password14 }}
      - groups: readaccess
      - require:
        - service: postgresql

colab_notebooks15:
    postgres_user.present:
      - password: {{ pillar.datastore_private.colab_pg_password15 }}
      - groups: readaccess
      - require:
        - service: postgresql

colab_notebooks16:
    postgres_user.present:
      - password: {{ pillar.datastore_private.colab_pg_password16 }}
      - groups: readaccess
      - require:
        - service: postgresql

colab_notebooks17:
    postgres_user.present:
      - password: {{ pillar.datastore_private.colab_pg_password17 }}
      - groups: readaccess
      - require:
        - service: postgresql

colab_notebooks18:
    postgres_user.present:
      - password: {{ pillar.datastore_private.colab_pg_password18 }}
      - groups: readaccess
      - require:
        - service: postgresql

colab_notebooks19:
    postgres_user.present:
      - password: {{ pillar.datastore_private.colab_pg_password19 }}
      - groups: readaccess
      - require:
        - service: postgresql

colab_notebooks20:
    postgres_user.present:
      - password: {{ pillar.datastore_private.colab_pg_password20 }}
      - groups: readaccess
      - require:
        - service: postgresql


update_postgres_config_colab_user_access:
  file.managed:
    - name: /etc/postgresql/10/main/pg_hba.conf
    - source: salt://postgres/pg10_hba_360_datastore.conf

update_postgres_listen_all:
  file.managed:
    - name: /etc/postgresql/10/main/conf.d/listen_all.conf
    - source: salt://postgres/postgres_conf_d_listen_all.conf

##### Datastore directories

{% for dir in [pillar.datastore.reports_dir,
               pillar.datastore.grantnav_packages_dir,
               pillar.datastore.static_dir]
%}

{{ dir }}:
  file.directory:
    - user: datastore
    - group: www-data
    - mode: 755
    - makedirs: True

{% endfor %}


##### Django setup
# Maybe use django salt module in the future

{% set djangodir='/home/'+ pillar.datastore.user +'/datastore/datastore/'  %}

migrate-database:
  cmd.run:
    - name: source ../.ve/bin/activate; DJANGO_SETTINGS_MODULE={{ pillar.datastore_private.settings_module }} python manage.py migrate --noinput
    - runas: {{ pillar.datastore.user }}
    - cwd: {{ djangodir }}
    - require:
      - service: postgresql
      - virtualenv: /home/{{ pillar.datastore.user }}/datastore/.ve
    - onchanges:
      - git: {{ pillar.datastore.git_url }}

collectstatic:
  cmd.run:
    - name: source ../.ve/bin/activate; DJANGO_SETTINGS_MODULE={{ pillar.datastore_private.settings_module }}  python manage.py collectstatic -v 3  --noinput > /tmp/collectstatic.log
    - runas: {{ pillar.datastore.user }}
    - cwd: {{ djangodir }}
    - require:
      - virtualenv: /home/{{ pillar.datastore.user }}/datastore/.ve
      - file: {{ pillar.datastore.static_dir }}
    - onchanges:
      - git: {{ pillar.datastore.git_url }}




##### Datatester Reports runner/config

/home/{{ pillar.datastore.user }}/data_runner.sh:
  file.managed:
    - source: salt://private/datastore/data_runner.sh
    - template: jinja
    - context:
       datastore_private: {{ pillar.datastore_private }}
       datastore_user: {{ pillar.datastore.user }}
    - mode: 750
    - user: {{ pillar.datastore.user }}
    - require:
      - git: /home/{{ pillar.datastore.user }}/datatester


datagetter_and_reports:
    cron.present:
      - name: /home/{{ pillar.datastore.user }}/data_runner.sh
      - user: {{ pillar.datastore.user }}
      - minute: 0
      - hour: 1

additional_data_sources:
    cron.present:
      - name: cd /home/{{ pillar.datastore.user }}/datastore/ && source ./.ve/bin/activate && cd ./datastore/ &&  export DJANGO_SETTINGS_MODULE=settings.settings_360g &&  ./manage.py delete_org_data --no-prompt  && ./additional_data/sources/load_all_org_data.sh >> /home/datastore/logs/ftc_source_update_$(date +%d-%m-%Y-%s).log 2>&1
      - user: {{ pillar.datastore.user }}
      - minute: 0
      - hour: 23
      - daymonth: 1

##### Apache

{{

apache(
  '360-datastore.conf',
  name='360-datastore.conf',
  servername=pillar.datastore.servername,
  https='yes'
)

}}
{{

uwsgi('360-datastore.ini', name='360-datastore.ini')

}}

