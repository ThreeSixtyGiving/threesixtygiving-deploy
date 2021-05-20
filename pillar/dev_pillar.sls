# Values used only on the dev servers
default_branch: 'master'
dev_robots_txt: True
domain_prefix: 'dev.'
banner_message: 'This is a development site with experimental features. Do not rely on it.'
cove:
  gitbranch: live
  matomo:
    url: '//matomo.opendataservices.coop/threesixtygiving/'
    site_id: '1' 
    dimension_map: 'file_type=2,page_type=3,form_name=4,language=5,exit_language=6'
  larger_uwsgi_limits: True
  uwsgi_as_limit: 1800
  uwsgi_harakiri: 300
  apache_uwsgi_timeout: 360
  app: cove_iati
  iati: True
registry360:
  allowedhosts: .default.opendataservices.uk0.bigv.io
automatic_reboot: 'true'
extra_cove_branches: [] # remove the [] (empty list) if you re-add some values below

# Do NOT just delete branches from extra_cove_branches above! Instead add them to old_cove_branches!
# They will be removed from the dev servers.
old_cove_branches: [] # remove the [] (empty list) if you re-add some values below

extra_registry360_branches: [] # remove the [] (empty list) if you re-add some values below

