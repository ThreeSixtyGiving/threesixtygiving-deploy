# This file defines what pillars should be used for our servers
# For each environment we have a public and a private pillar

base:
  '*':
     - common_pillar
     - private.common_pillar
     - private.prometheus_pillar
  '*live*':
     - live_pillar
     - private.live_pillar
  '*dev*':
     - dev_pillar
     - private.dev_pillar
  '*360*':
     - 360_pillar
  '*360-live':
     - 360_live_pillar
  'cove-360-live-2':
     - 360_live_pillar
  'datastore-360-live':
     - 360_datastore_live_pillar
     - private.360_datastore_live_pillar

  'grantnav-live-*':
     - grantnav_live_pillar
     - private.grantnav_live_pillar

  'dev':
     - new_dev_pillar
     - private.360_datastore_live_pillar
     - private.grantnav_live_pillar
