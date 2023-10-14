#!/usr/bin/env python3
import subprocess
import json

# Run `yc compute instance list` to get a list of VM instances
cmd = "yc compute instance list --format=json"
output = subprocess.check_output(cmd, shell=True)
instances = json.loads(output)

inventory = {
    "_meta": {
        "hostvars": {}
    },
    "all": {
        "hosts": [],
        "vars": {
            "ansible_connection": "ssh",
            "ansible_user": "ubuntu"
        }
    }
}

for instance in instances:
    instance_name = instance["name"]
    external_ip = instance["network_interfaces"][0]["primary_v4_address"]["one_to_one_nat"]["address"]

    inventory["_meta"]["hostvars"][instance_name] = {
        "ansible_host": external_ip
    }

    inventory["all"]["hosts"].append(instance_name)

#for Ansible to use
print(json.dumps(inventory, indent=4))

#for saving output in json file
with open("dynamic_inv_output.json", "w") as json_file:
    json.dump(inventory, json_file, indent=4)
