ssh -NT -L localhost:50002:localhost:50002 {ssh_host} &
./electrum_client --server localhost:50002:s --oneserver
pkill -P $$
