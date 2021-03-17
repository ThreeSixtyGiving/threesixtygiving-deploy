default_branch: master
cove:
  gitbranch: live
  servername: dataquality.threesixtygiving.org
  https: 'force'
  # uwsgi_port other than 3031 is needed for Ubuntu 20, not sure why
  #uwsgi_port: 3095
  piwik:
    url: '//mon.opendataservices.coop/piwik/'
    site_id: '19' 
    dimension_map: 'file_type=1,page_type=2,form_name=3,language=4,exit_language=5'
extra_cove_branches: []
