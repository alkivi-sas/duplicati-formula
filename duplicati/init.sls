{% from "duplicati/map.jinja" import duplicati with context -%}
{%- set hostname = grains['localhost'] -%}

include:
  - netframework
  - visualcpp.2010x64
  - visualcpp.2010x86

duplicati-package:
  file.managed:
    - name: {{ duplicati.tmpdir }}\packages\duplicati\duplicati.msi
    - source: https://updates.duplicati.com/experimental/duplicati-2.0.1.73_experimental_2017-07-15-x64.msi
    - source_hash: sha1=1e19bbf6d03c9527ac9a98877db477d393672807
    - makedirs: True

duplicati-install:
  cmd.run:
    - name: ./duplicati.msi /qn ALLUSERS=1 /norestart
    - cwd: {{ duplicati.tmpdir }}\packages\duplicati\
    - shell: powershell
    - require: 
      - file: duplicati-package

duplicati-copy-script:
  file.managed: 
    - name: {{ duplicati.tmpdir }}\packages\duplicati\duplicati_start.ps1
    - source: salt://duplicati/files/duplicati_start.ps1
    - makedirs: True
    - require: 
      - cmd: duplicati-install

duplicati-start:
  cmd.run:
    - name: powershell -NoProfile -ExecutionPolicy Bypass -Command {{ duplicati.tmpdir }}\packages\duplicati\duplicati_start.ps1
    - require: 
      - file: duplicati-copy-script

#duplicati-set-service:
#  cmd.run:
#    - name: New-Service -Name "DuplicatiService" -BinaryPathName "C:\Program Files\Duplicati 2\Duplicati.Service.exe" -Credential "Alkivi" -DependsOn "tcpip" -Description "Duplicati Server Service" -DisplayName "Duplicati" -StartupType "Automatic"
#    - shell: powershell
#    - require: 
#      - duplicati-install
#
#duplicati-start-service:
#  cmd.run:
#    - name: Start-Service -Name DuplicatiService
#    - shell: powershell
#    - require: 
#      - duplicati-set-service
#
#duplicati-service:
#  service.running:
#    - name: DuplicatiService
#
