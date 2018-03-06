{% from "duplicati/map.jinja" import duplicati with context -%}

duplicati-package:
  file.managed:
    - name: {{ duplicati.tmpdir }}\duplicati.msi
    - source: https://updates.duplicati.com/beta/duplicati-2.0.2.1_beta_2017-08-01-x64.msi
    - source_hash: sha256=b4cef1c6d4c9fe8e0ce6a84b8d4ab726d56862bad5d70a5480c5101f9f3ab6cc
    - makedirs: True

duplicati-install:
  cmd.run:
    - name: ./duplicati.msi /qn ALLUSERS=1 /norestart
    - cwd: {{ duplicati.tmpdir }}
    - shell: powershell
    - require: 
      - file: duplicati-package

service-install:
  cmd.run:
    - name: Duplicati.WindowsService.exe install
    - cwd: 'C:\Program Files\Duplicati 2'
    - require:
      - cmd: duplicati-install
