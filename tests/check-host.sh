#!/bin/bash
set -euo pipefail

test -c /dev/kvm

curl -fsS http://127.0.0.1:9100/metrics -o /tmp/abrnoc-node.metrics
grep -q '^node_uname_info' /tmp/abrnoc-node.metrics

curl -fsS http://127.0.0.1:9177/metrics -o /tmp/abrnoc-libvirt.metrics
grep -q '^libvirt_up 1' /tmp/abrnoc-libvirt.metrics
rm -f /tmp/abrnoc-node.metrics /tmp/abrnoc-libvirt.metrics

rc=0
sudo timeout 3 qemu-system-x86_64 -enable-kvm -machine none -display none -monitor none -serial none || rc=$?
if [ "$rc" -ne 124 ]; then
  echo "KVM test failed with exit code $rc." >&2
  exit 1
fi

echo "OK: /dev/kvm works and both exporters answer."
