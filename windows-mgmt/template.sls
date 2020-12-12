windows-mgmt-dependencies:
  pkg.installed:
    - pkgs:
      - qubes-core-admin-client
      - genisoimage
      - datefudge
{% if grains['os'] == 'Fedora' %}
      - geteltorito
{% elif grains['os'] == 'Debian' %}
      - curl
{% endif %}