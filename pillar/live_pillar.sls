# Values used only on the live servers
default_branch: 'live'
cove:
  larger_uwsgi_limits: True
  uwsgi_as_limit: 7000
  uwsgi_harakiri: 300
  # apache_uwsgi_timeout is defined here for the benefit of apache httpd on live2,
  # it needs to be "a bit bigger than" the value of uwsgi_harakiri *on cove-live-ocds-2*
  # (which is defined in ocds_live_pillar.sls, *not* above)
  apache_uwsgi_timeout: 1830
  app: cove_ocds
  https: 'yes'
  servername: 'cove.live.cove.opencontracting.uk0.bigv.io'
registry360:
  allowedhosts: data.threesixtygiving,.live.threesixtygiving.uk0.bigv.io
  servername: 'data.threesixtygiving.org'
  https: 'force'

