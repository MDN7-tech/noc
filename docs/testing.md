## Ansible test

I used one Debian 12 VM in VirtualBox. Vagrant ran Ansible when the VM started. I ran Ansible a second time. The full output is in [ansible-second-run.txt](ansible-second-run.txt).

```text
default : ok=18 changed=0 unreachable=0 failed=0 skipped=0 rescued=0 ignored=0
```

## Host test

The test script checks the host too:

- `/dev/kvm` exists, and QEMU starts with KVM for 3 seconds.
- The node exporter answers on port 9100.
- The libvirt exporter answers on port 9177 and shows `libvirt_up 1`.

## Alert test

`promtool` checked the alert file. It found 6 rules.

I sent test numbers to Prometheus: RAID needed 2 disks but had 1, and a test VM had state `6` (crashed). Both alerts fired. Alertmanager showed both as active:

- [Prometheus result](prometheus-firing.json)
- [Alertmanager result](alertmanager-firing.json)

I set the test numbers back to normal. The alerts went away. I then put the old Prometheus and Alertmanager settings back.

## Run the tests again

Run this from the repo folder:

```bash
bash tests/run-all.sh
```

The script saves new output in the same files. For a new test from a clean VM, first run `vagrant destroy -f`.

## Problems and limits

- The first download of the Vagrant box failed with HTTP 404.
- One later Ansible run had `changed=1`. The idle `libvirtd` service had stopped. I changed the role to start its sockets. The next run had `changed=0`.
- The VM has no real customer VM and no RAID array. I used test numbers for the two alerts. This is not a real disk failure test.
- I did not test HA failover or full customer load. This test needs more hosts and real storage.
