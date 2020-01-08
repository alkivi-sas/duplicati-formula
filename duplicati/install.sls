{% set wanted_version = salt['pkg.list_available']('duplicati')[0] %}
{% set actual_version = salt['pkg.version']('Duplicati 2') %}

{% if not actual_version or actual_version != wanted_version %}
duplicati-service-install:
  cmd.run:
    - name: Duplicati.WindowsService.exe install
    - cwd: 'C:\Program Files\Duplicati 2'
    - onchanges:
      - pkg: duplicati

duplicati:
  pkg.installed
{% endif %}

{% if actual_version and actual_version != wanted_version %}
duplicati-service-uninstall:
  cmd.run:
    - name: Duplicati.WindowsService.exe uninstall
    - cwd: 'C:\Program Files\Duplicati 2'
    - prereq:
      - cmd: duplicati-install
{% endif %}
