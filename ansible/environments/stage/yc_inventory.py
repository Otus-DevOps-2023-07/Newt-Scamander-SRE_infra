#!/usr/bin/env python3
import subprocess
import json

# get a list of VM instances
cmd = "yc compute instance list --format=json"
output = subprocess.check_output(cmd, shell=True)
instances = json.loads(output)

dynamic_inventory = {
    "_meta": {
        "hostvars": {}
    },
    "all": {
        "hosts": [],
        "vars": {
            "ansible_connection": "ssh",
            "ansible_user": "ubuntu",
            "env": "stage"

        }
    },
    "app": {
        "hosts": [],
    },
    "db": {
        "hosts": [],
    }
}

static_inventory = {
    "all": {
        "hosts": {},
        "children": {
            "app": {
                "hosts": {},
            },
            "db": {
                "hosts": {},
            }
        }
    }
}

for instance in instances:
    instance_name = instance["name"]
    external_ip = instance["network_interfaces"][0]["primary_v4_address"]["one_to_one_nat"]["address"]
    internal_ip = instance["network_interfaces"][0]["primary_v4_address"]["address"]

    dynamic_inventory["_meta"]["hostvars"][instance_name] = {
        "ansible_host": external_ip,
        "internal_ip": internal_ip
    }

    dynamic_inventory["all"]["hosts"].append(instance_name)

    if "app" in instance_name:
        dynamic_inventory["app"]["hosts"].append(instance_name)
    elif "db" in instance_name:
        dynamic_inventory["db"]["hosts"].append(instance_name)

    # Add host to the static inventory
    static_inventory["all"]["hosts"][instance_name] = {
        "ansible_host": external_ip,
        "internal_ip": internal_ip
        # Add any additional static variables here
    }

    # Organize hosts into children groups
    if "app" in instance_name:
        static_inventory["all"]["children"]["app"]["hosts"][instance_name] = {
            "ansible_host": external_ip,
            "internal_ip": internal_ip
            # Add any additional static variables for the "app" group here
        }
    elif "db" in instance_name:
        static_inventory["all"]["children"]["db"]["hosts"][instance_name] = {
            "ansible_host": external_ip,
            "internal_ip": internal_ip
            # Add any additional static variables for the "db" group here
        }

# Print the dynamic inventory for Ansible to use
print(json.dumps(dynamic_inventory, indent=4))

# Save the dynamic inventory to a JSON file
with open("./dynamic_inv_output.json", "w") as dynamic_json_file:
    json.dump(dynamic_inventory, dynamic_json_file, indent=4)

# Save the static inventory to a JSON file
with open("./static_inventory.json", "w") as static_json_file:
    json.dump(static_inventory, static_json_file, indent=4)
