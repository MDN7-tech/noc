# Architecture Diagram

```text
                    Control plane
                         |
            +------------+------------+
            |            |            |
          Rack A       Rack B       Rack C
        KVM + OSDs   KVM + OSDs   KVM + OSDs
          MON 1        MON 2        MON 3
            \            |            /
             \           |           /
                Ceph RBD VM disks
                3 copies (1 per rack)
                         |
                 Separate backups
```

Use at least five KVM hosts across the three racks. Ceph keeps one disk copy in each rack. If one rack fails, two copies stay online. Backups are outside Ceph.
