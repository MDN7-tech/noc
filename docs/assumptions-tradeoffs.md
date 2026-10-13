# Assumptions and Trade-offs

I assumed Debian 12, KVM support, MD RAID on the system disks, and three racks with separate power. I also assumed there is free CPU and RAM on other hosts when one host fails.

The firewall uses nftables with one full ruleset. A reload can also remove libvirt NAT rules. Reload libvirtd after every firewall reload.

I chose Ceph for shared VM disks. It keeps three copies in different racks. This helps VMs start on another host. The cost is more storage: about 3 TB of raw disk for 1 TB of VM data, plus free space for repair. Backups are still needed.

I did not build the Ceph cluster, customer networks, database failover, or secret storage. These need the real network plan, server sizes, and site data. With more time, I would test a host and rack failure, restore a backup, and set alert levels from real traffic.

I tested Ansible twice on a Vagrant VM. The second run had `changed=0`. The host test passed, and two alerts fired with test data in Alertmanager. This does not test a real disk failure or 300 real VMs.
