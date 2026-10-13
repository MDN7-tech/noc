# AbrNOC KVM host task

This repo has an Ansible role for a Debian 12 KVM host. It also has alert rules, an HA plan, an incident plan, and a log review.

## Before you run it

Use a Debian 12 x86_64 host. Turn on VT-x/AMD-V in the BIOS. The RAID rule is for Linux MD RAID. VM disks and VM networks need your site's settings.

The firewall allows SSH only from the management IP range. Set a real SSH key and the right IP ranges first. Keep console access for the first run.

The role installs a ready [libvirt exporter package](https://github.com/inovex/prometheus-libvirt-exporter/releases/tag/v2.5.0). Its SHA-256 is fixed in the role. The role does not install Ceph or create customer VMs.

## Set up a host

1. Edit `ansible/inventory.ini` and `ansible/group_vars/kvm_hosts.yml`.
2. Install Ansible collections: `ansible-galaxy collection install -r ansible/requirements.yml`.
3. Check changes: `ansible-playbook -i ansible/inventory.ini ansible/site.yml --check --diff`.
4. Run the same playbook without `--check --diff`.
5. Add `monitoring/prometheus.yml` and `monitoring/alerts.yml` to Prometheus. Set real alert receivers in Alertmanager.

## Repeat the test

You need Vagrant, VirtualBox, Ansible, and internet access. Run:

```bash
ansible-galaxy collection install -r ansible/requirements.yml
bash tests/run-all.sh
```

The script starts a Debian 12 VM if needed. It runs Ansible again and checks for `changed=0`. It then checks `/dev/kvm` and both exporters. After that it makes two test alerts. It saves the results in `docs/`. It puts the old Prometheus settings back when the test ends.

For a new test from a clean VM, first run `vagrant destroy -f`. This deletes only this test VM. Vagrant Cloud must be reachable to get a new box.

## Answers and results

- [Question 3: incident](docs/incident-response.md)
- [Question 4: HA plan](docs/architecture.md) and [diagram](docs/architecture-diagram.md)
- [Question 5: logs](docs/log-analysis.md)
- [Question 6: test results](docs/testing.md)
- [Assumptions and trade-offs](docs/assumptions-tradeoffs.md)
- [Alert priority](monitoring/README.md)
