import json
import sys

with open(sys.argv[1]) as file:
    alerts = json.load(file)

active = [item["labels"]["alertname"] for item in alerts
          if item["status"]["state"] == "active"]
needed = {"KVMRaidDegraded", "KVMVMDown"}
if not needed.issubset(active):
    sys.exit(1)

print("Both alerts are active in Alertmanager.")
