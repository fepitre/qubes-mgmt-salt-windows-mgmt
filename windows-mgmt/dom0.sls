windows-mgmt:
  qvm.vm:
    - present:
      - label: black
    - prefs:
      - template: {{ salt['pillar.get']('windows-mgmt:template', 'fedora-32') }}
      - netvm: {{ salt['pillar.get']('windows-mgmt:netvm', 'sys-whonix') }}

private-volume-size:
  cmd.run:
    - name: 'qvm-volume extend windows-mgmt:private {{ salt['pillar.get']('windows-mgmt:private_volume_size', '40GiB') }}'

windows-mgmt-admin-local-rwx:
  file.append:
    - name: /etc/qubes/policy.d/include/admin-local-rwx
    - text: |
        windows-mgmt @tag:created-by-windows-mgmt allow target=dom0
        windows-mgmt windows-mgmt allow target=dom0

windows-mgmt-admin-global-ro:
  file.append:
    - name: /etc/qubes/policy.d/include/admin-global-ro
    - text: |
        windows-mgmt @adminvm allow target=dom0
        windows-mgmt @tag:created-by-windows-mgmt allow target=dom0
        windows-mgmt windows-mgmt allow target=dom0

windows-mgmt-rpc:
  file.append:
    - name: /etc/qubes/policy.d/30-windows-mgmt.policy
    - text: |
        admin.vm.Create.StandaloneVM * windows-mgmt dom0 allow
        admin.vm.Create.TemplateVM * windows-mgmt dom0 allow
        admin.vm.Create.AppVM * windows-mgmt dom0 allow
        admin.vm.Remove * windows-mgmt @tag:created-by-windows-mgmt allow target=dom0

        qubes.Filecopy * windows-mgmt @tag:created-by-windows-mgmt allow

#qubes-windows-tools:
#  pkg.installed:
#    - pkgs:
#      - qubes-windows-tools
#
