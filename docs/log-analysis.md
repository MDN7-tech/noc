## Main problem

The first serious error is from `nvme1` at 03:13:58. Disk I/O times out. The kernel tries to reset the device, but it fails. At 03:14:59 the device is gone and its size becomes zero. The likely problem is the NVMe drive, its controller, or its PCIe path. The log does not tell us which part broke.

## What happened next

1. Writes to the NVMe fail. RAID1 removes it and runs with one disk.
2. Thin-pool data writes fail. The pool becomes read-only. I do not know the full disk layout, so I cannot prove the exact link between the NVMe and this pool.
3. Some ext4 file systems become read-only.
4. QEMU gets disk errors. One VM crashes and other VMs pause.
5. Disk tasks get stuck. Memory fills up, and the OOM killer stops a QEMU process.
6. Network drops rise. At 03:18:02 the NIC resets. Then the host is reported offline.

The disk errors came first. The network fault may be an effect of the sick host. It may also be another fault. I need more data to know.

## Cause, effects, and noise

- **Likely cause:** `nvme1` stops working.
- **Effects:** RAID loses a disk, disks become read-only, VMs stop, tasks get stuck, and the host becomes hard to reach.
- **Noise:** A normal Ansible SSH login and a cron job do not show a fault. The metrics exporter fails because its files are read-only. The node exporter warning comes from the missing NVMe.

Next, check NVMe health, BMC events, PCIe errors, RAID state, and switch logs. These checks can show which part needs repair.
