{% set fepitre_key_fpr = '9FA64B92F95E706BF28E2CA6484010B5CDC576E2' %}

/tmp/9FA64B92F95E706BF28E2CA6484010B5CDC576E2.asc:
  file.managed:
    - source: salt://windows-mgmt/keys/9FA64B92F95E706BF28E2CA6484010B5CDC576E2.asc
    - user: user

import-fepitre-key:
  cmd.run:
    - name: gpg --import /tmp/9FA64B92F95E706BF28E2CA6484010B5CDC576E2.asc
    - runas: user
    - onchange:
      - file: /tmp/9FA64B92F95E706BF28E2CA6484010B5CDC576E2.asc

trust-fepitre-key:
  cmd.run:
    - name: echo {{fepitre_key_fpr}}:6 | gpg --import-ownertrust && gpg --check-trustdb
    - runas: user
    - require:
      - cmd: import-fepitre-key

qvm-create-windows-qube-get:
  git.latest:
    - name: https://github.com/fepitre/qvm-create-windows-qube
    - target: /home/user/qvm-create-windows-qube
    - branch: adminapi
    - rev: adminapi
    - user: user

qvm-create-windows-qube-check:
  cmd.run:
    - name: git verify-commit --raw HEAD 2>&1 >/dev/null | grep '^\[GNUPG:\] TRUST_ULTIMATE'
    - cwd: /home/user/qvm-create-windows-qube
    - runas: user
    - require:
      - git: qvm-create-windows-qube-get
      - cmd: trust-fepitre-key
