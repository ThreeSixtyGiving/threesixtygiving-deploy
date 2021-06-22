# top.sls defines which states should be installed onto which servers
# and is used by the state.highstate command (see README)

base:
  # Install our core sls onto all servers
  '*':
    - core

  # LIVE

  'cove*live*':
    - cove
    - prometheus-client-apache

  'grantnav-live-*':
    - grantnav
    - prometheus-client-apache

  'data-360-live':
    - registry360
    - prometheus-client-apache

  'datastore-360-live':
    - 360-datastore
    - prometheus-client-apache

  # DEVELOPMENT

  'cove*dev*':
    - cove
    - prometheus-client-apache

#  'dev':
#    - cove
#    - grantnav
#    - registry360
#    - 360-datastore
#    - prometheus-client-apache
