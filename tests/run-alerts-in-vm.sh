#!/bin/bash
set -euo pipefail

cd /home/vagrant/abrnoc-test
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq prometheus prometheus-alertmanager

backup=$(mktemp -d)
sudo cp /etc/prometheus/prometheus.yml "$backup/prometheus.yml"
sudo cp /etc/prometheus/alertmanager.yml "$backup/alertmanager.yml"

cleanup() {
  sudo cp "$backup/prometheus.yml" /etc/prometheus/prometheus.yml
  sudo cp "$backup/alertmanager.yml" /etc/prometheus/alertmanager.yml
  sudo systemctl restart prometheus prometheus-alertmanager
  sudo systemctl stop abrnoc-alert-test || true
  sudo rm -f /etc/prometheus/abrnoc-alerts.yml
  sudo rm -r "$backup"
}
trap cleanup EXIT

sudo install -m 0644 alerts.yml /etc/prometheus/abrnoc-alerts.yml
sudo install -m 0644 prometheus.yml /etc/prometheus/prometheus.yml
sudo install -m 0644 alertmanager.yml /etc/prometheus/alertmanager.yml
promtool check rules /etc/prometheus/abrnoc-alerts.yml
promtool check config /etc/prometheus/prometheus.yml

sudo systemctl stop abrnoc-alert-test 2>/dev/null || true
sudo systemctl reset-failed abrnoc-alert-test 2>/dev/null || true
sudo systemd-run --unit=abrnoc-alert-test --collect /usr/bin/python3 /home/vagrant/abrnoc-test/metrics.py
sudo systemctl restart prometheus prometheus-alertmanager

for _ in $(seq 1 40); do
  if curl -fsS http://127.0.0.1:9093/api/v2/alerts -o alertmanager.json 2>/dev/null && \
     python3 check-alerts.py alertmanager.json; then
    curl -fsS http://127.0.0.1:9090/api/v1/alerts -o prometheus.json
    exit 0
  fi
  sleep 5
done

echo "The two alerts did not fire." >&2
exit 1
