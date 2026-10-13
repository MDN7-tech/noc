## First 15 minutes

| Time | What I do |
|---|---|
| 0-2 min | Start an incident. Find the affected VMs. Stop auto-restart jobs. Two copies of one VM must not write to one disk. |
| 2-5 min | Check graphs and alerts: disk, RAID, RAM, CPU, and network. Save the last logs. Check other hosts too. |
| 5-10 min | Open the BMC console. Check the switch port. Read disk and kernel errors. Do not keep trying SSH on a stuck host. |
| 10-15 min | Choose a safe recovery plan. Check free space on other hosts. Tell the team and customers what we know and when the next update will come. |

## Find the cause

- **Network:** Is BMC online? Is the switch link up? Are there many packet errors? If the console works but the host network does not, check the NIC and switch.
- **Storage:** Check NVMe errors, RAID state, and disk delay. In this log, NVMe errors came first.
- **Kernel:** Check for a panic, stuck tasks, and OOM kills. These may come from bad storage. They do not prove a kernel bug.
- **Hardware:** Check BMC events, disk health, PCIe errors, heat, and power.

## Reboot

Reboot only if the host cannot work safely. First save logs, check good disk copies, and stop new VM placement. If VMs will start on other hosts, fence this host first. Fencing means making sure it cannot write to their disks. A quick reboot can hide the cause or make disk errors worse.

## Bring back 300 VMs

1. Fence the old host and confirm it cannot write.
2. Check Ceph health and quorum. Quorum means enough Ceph nodes agree that storage is safe.
3. Start the most important VMs first on hosts with free CPU, RAM, and disk speed.
4. Start small groups of 10-20 VMs. Check disk speed and errors after each group.
5. Check that each VM boots and its app works. Restore bad disks from backup. Do not move VMs back until the old host is fixed.

## Updates and prevention

Tell the team and affected customers when the problem is confirmed. Say what works, what is down, and when the next update will come. Do not guess at the cause. Send a final update after service checks pass.

Later, add early disk alerts, keep free storage space, test fencing and backups, and review the failed NVMe part. Write a short report with the cause and fixes.
