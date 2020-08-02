import subprocess
import json
import datetime

def rpc_call_string(command, args):
    process = subprocess.run(['bitcoin-cli', command] + args, #todo: broken
                            stdout=subprocess.PIPE,
                            universal_newlines=True)
    return process.stdout[:-1]

def rpc_call_json(command, args):
    process = subprocess.run(['bitcoin-cli', command] + args, #todo: broken
                            stdout=subprocess.PIPE,
                            universal_newlines=True)
    json_data = json.loads(process.stdout)
    return json_data


def search_for_block_height_of_date(datestr):
    target_time = datetime.datetime.strptime(datestr, "%d/%m/%Y")
    bestblockhash = rpc_call_string("getbestblockhash", [])
    best_head = rpc_call_json("getblockheader", [bestblockhash])
    if target_time > datetime.datetime.fromtimestamp(best_head["time"]):
        print("date in the future")
        return -1
    genesis_block = rpc_call_json("getblockheader", [rpc_call_string("getblockhash", ["0"])])
    if target_time < datetime.datetime.fromtimestamp(genesis_block["time"]):
        print("date is before the creation of bitcoin")
        return 0
    first_height = 0
    last_height = best_head["height"]
    while True:
        m = (first_height + last_height) // 2
        m_header = rpc_call_json("getblockheader", [rpc_call_string("getblockhash", [str(m)])])
        m_header_time = datetime.datetime.fromtimestamp(m_header["time"])
        m_time_diff = (m_header_time - target_time).total_seconds()
        if abs(m_time_diff) < 60*60*2: #2 hours
            return m_header["height"]
        elif m_time_diff < 0:
            first_height = m
        elif m_time_diff > 0:
            last_height = m
        else:
            return -1

user_input = input("Enter earliest wallet creation date (DD/MM/YYYY) "
            "or block height to rescan from: ")

print(search_for_block_height_of_date(user_input))
