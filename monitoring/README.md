# When to act on alerts

| Alert | When | Why |
|---|---|---|
| `KVMHighDiskLatency` | Page now | Slow disks can stop many VMs. |
| `KVMRaidDegraded` | Page now | A disk copy is lost. |
| `KVMHostMemoryPressure` | Page now | The host may kill a VM. |
| `KVMVMDown` | Page now | A VM is not running. Mute this alert for planned stops. |
| `KVMNetworkPacketLoss` | Page now | Many dropped packets can break the network. |
| `KVMHighLoad` | Work in business hours | High load alone does not mean an outage. |

The labels `page` and `ticket` choose routes in `alertmanager-example.yml`. Add your real page and ticket tools before production use. The RAID rule uses `node_md_disks*` from node_exporter. If a host has a hardware RAID card, change that rule to the metrics from the card. The network rule uses dropped packets as a sign of packet loss. Check it with a network probe too.
