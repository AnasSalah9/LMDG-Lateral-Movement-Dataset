import yaml
import json
from datetime import datetime, timedelta
import os
import re
import threading
import time
import psutil  # To access system processes
from Evtx.Evtx import Evtx
from xml.etree import ElementTree as ET
from tqdm import tqdm
import logging
import pprint
import logging
import pandas as pd


# from evtx import Evtx







# Define the path to the YAML file
yaml_file_path = r"/media/mamun/Rapid/Dataset_Backup/LabelingEnginePython/input.yaml"

# Read the YAML file
with open(yaml_file_path, 'r') as file:
    yaml_content = yaml.safe_load(file)

# Prepare the input variable
input_data = {}

# Process the YAML content to create the desired structure
for host_entry in yaml_content['input']:
    processes = []

    for process in host_entry['Processes']:
        # Remove the 'Z' and adjust StartTime and EndTime by 3 seconds
        start_time_str = process['StartTime'].rstrip('Z')
        end_time_str = process['EndTime'].rstrip('Z')
        
        # Parse the datetime without the 'Z'
        adjusted_start_time = datetime.strptime(start_time_str, '%Y-%m-%dT%H:%M:%S') - timedelta(seconds=3)
        adjusted_end_time = datetime.strptime(end_time_str, '%Y-%m-%dT%H:%M:%S') + timedelta(seconds=3)

        # Append the process to the processes list
        processes.append({
            'PPID': process['PPID'],
            'StartTime': adjusted_start_time,
            'EndTime': adjusted_end_time,
            'Scenario': process['Scenario'],
            'Version': process['Version'],
            'Trial': process['Trial'],
            'Step': process['Step'],
            'StepSuccess': process['StepSuccess']
        })

    # Append the host entry and its processes to the input_data
    input_data[host_entry['HostName']] = processes
    



# pprint.pprint(input_data)






# Setup logging
# logging.basicConfig(level=logging.ERROR, format='%(asctime)s - %(levelname)s - %(message)s')

# Store process creation events for every host
# hosts_process_creation_events = {}

# Define the namespace used in the XML
NAMESPACE = {"ns": "http://schemas.microsoft.com/win/2004/08/events/event"}


# this function performs lableing at given host
def labeling(host_name):


    logging.basicConfig(
        filename=f"labeling_errors_{host_name}.log",
        filemode="a",
        level=logging.ERROR,
        format="%(asctime)s - %(levelname)s - %(message)s"
    )





    evtx_file_path = f"/media/mamun/Rapid/Dataset_Backup/{host_name}/Logs/Security.evtx"
    process_creation_events = []
    cnt = 0
    
    ######################################################################################################
    ######################################################################################################

    print("Step 1) Building process_creation_events list in host: ", host_name)
    t1 = time.time()

    try:
        with Evtx(evtx_file_path) as log:
            for record in tqdm(log.records(), desc=f"Processing events for {host_name}", unit="event"):
                
                # if cnt == 50000:
                #     break
                # cnt+=1

                try:
                    
                    event_xml = record.xml()  # Get the event record as XML
                    # print(event_xml)
                    event = ET.fromstring(event_xml)
                except ET.ParseError as e:
                    logging.error(f"XML parsing error for {host_name}: {e}")
                    continue
                
                # Extract Event ID
                event_id_element = event.find(".//ns:EventID", NAMESPACE)
                event_id = event_id_element.text if event_id_element is not None else None
                
                
                if event_id == "4688":
                    try:
                        system = event.find("ns:System", NAMESPACE)
                        event_data = {
                            "TimeCreated": system.find("ns:TimeCreated", NAMESPACE).get("SystemTime") if system is not None else None,
                            "NewProcessId": event.find(".//ns:Data[@Name='NewProcessId']", NAMESPACE).text if event.find(".//ns:Data[@Name='NewProcessId']", NAMESPACE) is not None else None,
                            "ParentProcessId": event.find(".//ns:Data[@Name='ProcessId']", NAMESPACE).text if event.find(".//ns:Data[@Name='ProcessId']", NAMESPACE) is not None else None,
                            "NewProcessName": event.find(".//ns:Data[@Name='NewProcessName']", NAMESPACE).text if event.find(".//ns:Data[@Name='NewProcessName']", NAMESPACE) is not None else None,
                            "CommandLine": event.find(".//ns:Data[@Name='CommandLine']", NAMESPACE).text if event.find(".//ns:Data[@Name='CommandLine']", NAMESPACE) is not None else None,
                        }
                        process_creation_events.append(event_data)
                    except Exception as e:
                        logging.error(f"Error extracting event data for {host_name}: {e}")
                        continue
    except FileNotFoundError:
        logging.error(f"File not found: {evtx_file_path}")
    except PermissionError:
        logging.error(f"Permission denied when accessing: {evtx_file_path}")
    except Exception as e:
        logging.error(f"Unexpected error processing {host_name}: {e}")
    

    t2 = time.time()
    
    elapsed = t2 - t1
    hours, rem = divmod(elapsed, 3600)
    minutes, seconds = divmod(rem, 60)

    print(f"Size of process_creation_events in host {host_name}: {len(process_creation_events)}.")
    print(f"Execution time of Step 1 in host {host_name}: {int(hours)}h {int(minutes)}m {seconds:.2f}s")
    








    # # Define the output path
    # output_json_path = f"{host_name}_process_creation_events.json"

    # # Save the list to a JSON file
    # with open(output_json_path, 'w') as f:
    #     json.dump(process_creation_events, f, indent=4)


    # # Load the list from the JSON file
    # with open(f"{host_name}_process_creation_events.json", 'r') as f:
    #     process_creation_events = json.load(f)


    # print(f"Size of process_creation_events in host {host_name}: {len(process_creation_events)}.")







    ######################################################################################################
    ######################################################################################################

    print("Step 2) Building allTrees list (a tree for every malicious PPID) in host: ", host_name)
    
    
    t1 = time.time()




    def get_process_tree(
        parent_pid: int,
        start_time: datetime,
        end_time: datetime,
        events: list,
        indent_level: int = 0,
        pid_list: set = set(),
        max_depth: int = 100
        ) -> set:


        # Prevent cycles
        if parent_pid in pid_list:
            return pid_list

        if indent_level >= max_depth:
            return pid_list

        # Add the parent PID
        pid_list.add(parent_pid)

        if indent_level == 0:
            print("  " * indent_level + f"|- Parent Process (PID: {parent_pid})")

        # Filter events that match parent_pid and fall within the time window
        filtered_events = [
            event for event in events
            if int(event["ParentProcessId"], 16) == parent_pid
            and start_time <= datetime.fromisoformat(event["TimeCreated"].replace('Z', '')).replace(tzinfo=None)
            and datetime.fromisoformat(event["TimeCreated"].replace('Z', '')).replace(tzinfo=None) <= end_time
        ]

        for event in filtered_events:
            try:
                process_id = int(event["NewProcessId"], 16)
                process_name = event.get("NewProcessName", "Unknown")
                process_time = datetime.fromisoformat(event["TimeCreated"].replace('Z', '')).replace(tzinfo=None)

                # if process_id not in pid_list:
                #     pid_list.add(process_id)

                print("  " * (indent_level + 1) + f"|- {process_name} (PID: {process_id}, Time: {process_time})")

                # Recursive call
                get_process_tree(
                    process_id,
                    start_time,
                    end_time,
                    events,
                    indent_level + 1,
                    pid_list,
                    max_depth
                )

            except Exception as e:
                print(f"Error processing PID: {event.get('NewProcessId', 'N/A')} - {e}")

        return pid_list





    # List to store all trees in current host
    all_trees = []

    # Loop through each process entry
    for process in input_data[host_name]:
        parent_pid = process['PPID']
        start_time = process['StartTime']
        end_time = process['EndTime']
        scenario = process['Scenario']
        version = process['Version']
        trial = process['Trial']
        step = process['Step']
        step_success = process['StepSuccess']

        # Get process tree
        pids = get_process_tree(parent_pid, start_time - timedelta(minutes=3), end_time + timedelta(minutes=3), process_creation_events)
        unique_pids = sorted(set(pids))

        # Store the result
        tree = {
            'PIDs': unique_pids,
            'StartTime': start_time,
            'EndTime': end_time,
            'Scenario': scenario,
            'Version': version,
            'Trial': trial,
            'Step': step,
            'StepSuccess': step_success
        }

        all_trees.append(tree)




    t2 = time.time()
    
    elapsed = t2 - t1
    hours, rem = divmod(elapsed, 3600)
    minutes, seconds = divmod(rem, 60)
    print(f"Execution time of Step 2 in host {host_name}: {int(hours)}h {int(minutes)}m {seconds:.2f}s")


    ######################################################################################################
    ######################################################################################################
    
    print(f"Step 3) Labeling Windows Event Logs in host {host_name}")
    
    t1 = time.time()

    malicious_logs_dir = r"/media/mamun/Rapid/Dataset_Backup/LabelingEnginePython/Labeled_Malicious_Logs"

    

    # Ensure the directory is clean
    if os.path.exists(malicious_logs_dir):
        for f in os.listdir(malicious_logs_dir):
            file_path = os.path.join(malicious_logs_dir, f)
            if os.path.isfile(file_path):
                os.remove(file_path)
    else:
        os.makedirs(malicious_logs_dir)

    # Helper to sanitize filenames
    def sanitize_file_name(name):
        return re.sub(r'[\\/*?:"<>|]', "_", name)



    # Get list of all EVTX log files for this host
    log_dir = f"/media/mamun/Rapid/Dataset_Backup/{host_name}/Logs/"
   
    
    log_files = [f for f in os.listdir(log_dir) if f.endswith(".evtx")]


    print("Processing Windows logs .....")

    for log_file in log_files:
        
        log_path = os.path.join(log_dir, log_file)
        sanitized_log_name = sanitize_file_name(log_file.replace(".evtx", ""))
        
        error_count = 0
        max_errors = 10


        try:
            with Evtx(log_path) as log:
                for record in tqdm(log.records(), desc=f"Processing log {sanitized_log_name}", unit="event"):
                    # if error_count == 50000:
                    #     break
                    # error_count += 1
                     
                    try:
                        event_xml = record.xml()
                        event = ET.fromstring(event_xml)
                        event_id = event.find(".//ns:EventID", NAMESPACE).text

                        record_id_elem = event.find(".//ns:EventRecordID", NAMESPACE)
                        record_id = int(record_id_elem.text) if record_id_elem is not None else None

                        # Only check events with ProcessId if available
                        pid_elem = event.find(".//ns:Data[@Name='ProcessId']", NAMESPACE)
                        if pid_elem is None:
                            continue

                        event_pid = int(pid_elem.text, 16)

                        time_created_str = event.find(".//ns:TimeCreated", NAMESPACE).get("SystemTime")
                        time_created = datetime.fromisoformat(time_created_str.replace("Z", "")).replace(tzinfo=None)



                        # print("-----------------------------------------------------------------------")
                        # print(record_id)
                        # print(event_id)
                        # print(time_created.isoformat())
                        # print("-----------------------------------------------------------------------")


                        for tree in all_trees:
                            pids = tree['PIDs'] #set(tree['PIDs'])
                            start_time = tree['StartTime']
                            end_time = tree['EndTime']
                            scenario = tree['Scenario']
                            version = tree['Version']
                            trial = tree['Trial']
                            step = tree['Step']
                            step_success = tree['StepSuccess']



                            if start_time <= time_created <= end_time and event_pid in pids:
                                print("Condition Staisfied")

                                filename = f"Host-{host_name}_Log-{sanitized_log_name}_Sc-{scenario}_Ver-{version}_Tri-{trial}_Stp-{step}_StpSucc-{step_success}.csv"
                                filepath = os.path.join(malicious_logs_dir, filename)
                                
                                
                                print("record_id:", record_id)
                                print("event_id:", event_id)
                                print("event_pid:", event_pid)
                                print("time_created:", time_created.isoformat())
                                print("-----------------------------------------------------------------------")
                                
                                try:
                                    os.makedirs(os.path.dirname(filepath), exist_ok=True)
                                    df = pd.DataFrame([{
                                        "RecordId": record_id,
                                        "EventID": event_id,
                                        "TimeCreated": time_created.isoformat()
                                    }])
                                    df.to_csv(filepath, index=False, mode='a', header=not os.path.exists(filepath))
                                except Exception as e:
                                    logging.error(f"Failed to write to CSV {filepath}: {e}")

                                
                    except Exception as e:
                        error_count += 1
                        logging.error(f"Failed to parse record in {log_file}: {e}")
                        # if error_count <= max_errors:
                        #     logging.error(f"Failed to parse record in {log_file}: {e}")
                        # elif error_count == max_errors + 1:
                        #     logging.error(f"Further errors in {log_file} suppressed.")
                        continue      
        except FileNotFoundError:
            logging.error(f"File not found: {evtx_file_path}")
        except PermissionError:
            logging.error(f"Permission denied when accessing: {evtx_file_path}")
        except Exception as e:
            logging.error(f"Unexpected error processing {host_name}: {e}")






    print(f"Matched events are saved in: {malicious_logs_dir}")



    t2 = time.time()
    
    elapsed = t2 - t1
    hours, rem = divmod(elapsed, 3600)
    minutes, seconds = divmod(rem, 60)
    print(f"Execution time of Step 3 in host {host_name}: {int(hours)}h {int(minutes)}m {seconds:.2f}s")




# ####################################################################################################
# ####################################################################################################




if __name__ == "__main__":

    
    
    labeling("LMT-HR-DC01")














