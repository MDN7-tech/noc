# Question 4: HA plan

Diagram: [architecture-diagram.md](architecture-diagram.md).

## Plan and goals

Use Ceph RBD for VM disks. Put at least five KVM hosts in three racks. The racks have different power and network paths. Put one Ceph MON in each rack. Use BMC to turn off a failed host before its VMs start elsewhere.

- **RPO:** Aim to lose 0 saved writes after one host or rack fails. RPO is how much data we may lose. This needs two good Ceph copies and quorum.
- **RTO:** Start recovery in 5 minutes. Aim to bring important VMs back in 15-30 minutes. RTO is how long service is down. A big outage may take longer.
- A full region loss needs backup restore. Its RPO and RTO are different.

## Copies and split brain

Keep three disk copies in three racks. Set Ceph `size=3` and `min_size=2`. If one rack fails, two copies remain. Three MONs need two working MONs to agree. This is quorum. Do not force writes without quorum.

Before a VM starts on a new host, fence the old host. If both hosts run the same VM, they may both write to one disk. This is split brain and can damage data.

Keep spare CPU, RAM, network, and disk space. One host or rack may fail, so the other hosts must have room for its VMs.

## Backups and space

Three copies help when a disk or host fails. They are not backups. A bad delete can reach all copies. Keep separate backups and test a restore.

For 1 TB of VM data, three copies use about 3 TB of raw disk. Keep 20-25% of raw disk free for repair and growth. So only about one quarter of raw disk is for VM data.

## Maintenance and limits

Before work, check Ceph health and free space. Move VMs away from one host. Update or reboot that host. Wait for Ceph to become healthy before work on another host. Test host loss, fencing, VM restart, and backup restore.

Ceph needs fast networks and skilled staff. This task does not set exact server sizes, install Ceph, or build database failover. I need real site data for that work.
