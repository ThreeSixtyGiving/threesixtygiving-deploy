default_branch: master
cove:
  gitbranch: main
  servername: dataquality.threesixtygiving.org
  https: 'force'
  # uwsgi_port other than 3031 is needed for Ubuntu 20, not sure why
  uwsgi_port: 3095
  matomo:
    url: '//matomo.opendataservices.coop/threesixtygiving/'
    site_id: '19'
    dimension_map: 'file_type=1,page_type=2,form_name=3,language=4,exit_language=5'
  larger_uwsgi_limits: True
extra_cove_branches: []
