import os
import json
import yaml
import re
from datetime import datetime

root_dir = "/media/mamun/Rapid/Dataset_Backup/Caldera/Caldera_Reports"

# Step success mapping
task_success = {
    1: {1: True, 2: True, 3: True, 4: True},
    2: {1: True, 2: True, 3: False, 4: True, 5: True},
    3: {1: True, 2: False},
    4: {1: True, 2: True, 3: True, 4: True, 5: True, 6: True, 7: True, 8: True},
    5: {1: True, 2: True, 3: True, 4: True, 5: True, 6: True},
    6: {1: True, 2: False},
    7: {1: True, 2: False},
}

output_data = {"input": []}
hosts_data = {}

for subdir in os.listdir(root_dir):
    subdir_path = os.path.join(root_dir, subdir)
    if not os.path.isdir(subdir_path):
        continue

    processes_by_host = {}

    for json_file in os.listdir(subdir_path):
        if not json_file.endswith(".json"):
            continue

        file_path = os.path.join(subdir_path, json_file)
        with open(file_path, 'r') as f:
            data = json.load(f)

        if not isinstance(data, list) or len(data) == 0:
            continue

        first_entry = data[0]
        last_entry = data[-1]

        agent_metadata = first_entry.get('agent_metadata', {})
        ppid = agent_metadata.get('pid', None) # this is correct
        host = agent_metadata.get('host', None)
        if host is None:
            continue
        host_name = host

        start_time = first_entry.get('delegated_timestamp')
        end_time = last_entry.get('finished_timestamp')

        if not start_time or not end_time or ppid is None:
            continue

        match = re.search(r'SC-(\d+)_V-(\d+)_STP-(\d+)_TRIAL-(\d+)', json_file)
        if not match:
            continue

        scenario = int(match.group(1))
        version = int(match.group(2))
        step = int(match.group(3))
        trial = int(match.group(4))

        step_success = task_success.get(scenario, {}).get(step, False)

        process_entry = {
            "PPID": ppid,
            "StartTime": start_time,
            "EndTime": end_time,
            "Scenario": scenario,
            "Version": version,
            "Trial": trial,
            "Step": step,
            "StepSuccess": int(step_success)
        }

        if host_name not in processes_by_host:
            processes_by_host[host_name] = []

        processes_by_host[host_name].append(process_entry)

    for host, processes in processes_by_host.items():
        if host in hosts_data:
            hosts_data[host].extend(processes)
        else:
            hosts_data[host] = processes

# Ensure the correct order of keys in the YAML output
def ordered_process(process):
    return {
        "PPID": process["PPID"],
        "StartTime": process["StartTime"],
        "EndTime": process["EndTime"],
        "Scenario": process["Scenario"],
        "Version": process["Version"],
        "Trial": process["Trial"],
        "Step": process["Step"],
        "StepSuccess": process["StepSuccess"]
    }

for host, procs in hosts_data.items():
    ordered_procs = [ordered_process(p) for p in procs]
    output_data["input"].append({"HostName": host, "Processes": ordered_procs})


with open("output.yaml", "w") as outfile:
    yaml.dump(output_data, outfile, default_flow_style=False, sort_keys=False)
