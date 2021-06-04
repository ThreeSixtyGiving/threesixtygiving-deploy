# Salt formula for setting up elasticsearch
elasticsearch-base:
  cmd.run:
    - name: wget -O - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -

  pkgrepo.managed:
    - humanname: Elasticsearch
    - name: deb https://artifacts.elastic.co/packages/7.x/apt stable main
    - file: /etc/apt/sources.list.d/elasticsearch.list

  pkg.installed:
    - pkgs:
      - elasticsearch

  service.running:
    - name: elasticsearch
    - enable: True
    - watch:
      - file: /etc/elasticsearch/*

  # Note: Any apps using this should set up their own version of /etc/elasticsearch/elasticsearch.yml
  # Ensure elasticsearch only listens on localhost, doesn't multicast
