
datastore:
  user: 'datastore'
  servername: 'store.dev.default.threesixtygiving.uk0.bigv.io'
  branch: 'dev'
  database_name: '360givingdatastore'
  git_url: 'https://github.com/threesixtygiving/datastore.git'
  static_dir: '/var/www/static/datastore/'
  grantnav_packages_dir: '/var/www/grantnav_packages/'
  reports_dir: '/var/www/reports/'

datatester:
  branch: 'master'

prometheus:
  client_fqdn: 'grantnav.dev.default.threesixtygiving.uk0.bigv.io'

grantnav:
  user: 'grantnav'
  git_url: 'https://github.com/ThreeSixtyGiving/grantnav.git'
  branch: 'master'
  static_dir: '/var/www/static/grantnav'
  serveraliases:
    - grantnav.dev.default.threesixtygiving.uk0.bigv.io

  allowedhosts: '.live.threesixtygiving.uk0.bigv.io,.threesixtygiving.org, default.threesixtygiving.uk0.bigv.io'
  matomo:
    url: '//matomo.opendataservices.coop/threesixtygiving/'
    site_id: '-1'

  datastore_url: 'https://store.dev.default.threesixtygiving.uk0.bigv.io/api/grantnav/updates'

registry360:
  allowedhosts: data.threesixtygiving,.live.threesixtygiving.uk0.bigv.io, .dev.default.threesixtygiving.uk0.bigv.io
  servername: data.dev.default.threesixtygiving.uk0.bigv.io


cove:
  larger_uwsgi_limits: True
  uwsgi_as_limit: 7000
  uwsgi_harakiri: 300
  uwsgi_port: 3020
  # apache_uwsgi_timeout is defined here for the benefit of apache httpd on live2,
  # it needs to be "a bit bigger than" the value of uwsgi_harakiri *on cove-live-ocds-2*
  # (which is defined in ocds_live_pillar.sls, *not* above)
  apache_uwsgi_timeout: 1830
  app: cove_project
  https: 'yes'
  servername: 'cove.dev.default.threesixtygiving.uk0.bigv.io'
  allowedhosts: 'cove.dev.default.threesixtygiving.uk0.bigv.io'
  gitbranch: 'dev'
