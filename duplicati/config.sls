{%- from "duplicati/map.jinja" import duplicati with context -%}
{% set config = duplicati.config %}

include:
  - duplicati

import-backup-job:
  cmd.run:
    - name: Duplicati.CommandLine.exe backup "openstack://{{ salt['grains.get']('id') }}?auth-username={{ config.get('auth-username') }}&auth-password={{ config.get('auth-password') }}&openstack-authuri={{ config.get('openstack-authuri') }}&openstack-tenant-name={{ config.get('openstack-tenant-name') }}&openstack-region={{ config.get('openstack-region') }}" "{{ config.get('sources') }}" --backup-name="{{ salt['grains.get']('id') }}" --dbpath="{{ config.get('dbpath') }}" --encryption-module="{{ config.get('encryption-module') }}" --keep-time="{{ config.get('keep-time') }}" --passphrase="{{ config.get('passphrase') }}" --dblock-size="{{ config.get('dblock-size') }}" --snapshot-policy="{{ config.get('snapshot-policy') }}" --disable-module="{{ config.get('disable-module') }}"
    - cwd: c:\duplicati\
    - require:
      - duplicati-package
