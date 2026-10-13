#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.."
vagrant up --provider=virtualbox
vagrant provision | tee docs/ansible-second-run.txt
grep -Eq 'changed=0[[:space:]]+unreachable=0[[:space:]]+failed=0' docs/ansible-second-run.txt

vagrant upload tests /home/vagrant/abrnoc-test
vagrant upload monitoring/alerts.yml /home/vagrant/abrnoc-test/alerts.yml
vagrant ssh -c 'bash /home/vagrant/abrnoc-test/check-host.sh'
vagrant ssh -c 'bash /home/vagrant/abrnoc-test/run-alerts-in-vm.sh'
vagrant ssh -c 'cat /home/vagrant/abrnoc-test/alertmanager.json' > docs/alertmanager-firing.json
vagrant ssh -c 'cat /home/vagrant/abrnoc-test/prometheus.json' > docs/prometheus-firing.json

echo "The Ansible run had changed=0. Both alerts fired."
