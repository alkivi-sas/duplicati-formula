{% from "duplicati/map.jinja" import duplicati with context -%}

{% set wanted_version = 'Version : 2.0.4.23' %}

duplicati-package:
  file.managed:
    - name: {{ duplicati.tmpdir }}\duplicati.msi
    - source: https://updates.duplicati.com/beta/duplicati-2.0.4.23_beta_2019-07-14-x64.msi
    - source_hash: sha256=3436c565dd9b58df96e867bd1198300c569aff75d4d9425090851c5cbb75e568
    - makedirs: True

duplicati-install:
  cmd.run:
    - name: msiexec /i {{ duplicati.tmpdir }}\duplicati.msi /qn ALLUSERS=1 /norestart
    - cwd: {{ duplicati.tmpdir }}
    - shell: powershell
    - require: 
      - file: duplicati-package
    - unless:          #
      - "$version = Get-Package 'Duplicati 2' | Format-List -Property Version | Out-String; if ( $version.Trim() -eq 'Version : 2.0.4.23') { exit 0 } else { exit 1 }" 

duplicati-service-uninstall:
  cmd.run:
    - name: Duplicati.WindowsService.exe uninstall
    - cwd: 'C:\Program Files\Duplicati 2'
    - prereq:
      - cmd: duplicati-install
    - unless:
      - Powershell -NonInteractive -NoProfile "$version = Get-Package 'Duplicati 2' | Format-List -Property Version | Out-String; if ( $version.Trim() -eq '') { exit 0 } else { exit 1 }" 

duplicati-service-install:
  cmd.run:
    - name: Duplicati.WindowsService.exe install
    - cwd: 'C:\Program Files\Duplicati 2'
    - onchanges:
      - cmd: duplicati-install
