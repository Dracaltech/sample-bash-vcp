#!/bin/bash

# read exec parameters
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "Syntax: $0 <port> [poll_interval_ms]"
  echo "Example (Linux/MacOS): $0 /dev/ttyACM0 1000"
  exit 1
fi
port=$1
interval=${2:-1000}  # default interval is 1000 if not provided

# open serial port for read/write (using file descriptor 3)
exec 3<>"$port"
stty -F "$port" -icrnl -onlcr

# set poll interval (allow 100 ms for request to complete)
echo -e "POLL $interval" > "$port"
sleep 0.3
# two digits past the decimal
echo -e "FRAC 2" > "$port"
sleep 0.3
# get the info line
echo -e "INFO" > "$port"
sleep 0.3

# handle incoming data
process_data() {
  while IFS= read -r -u 3 line; do
    t=$(date +"%Y-%m-%d %H:%M:%S")
    if [ -z "$line" ]; then
      break
    fi

    # example info line:
    # I,Product ID,Serial Number,Message,MS5611 Pressure,Pa,SHT31 Temperature,C,SHT31 Relative Humidity,%,*bbdd

    # decode bytes into a list of strings
    data=$(echo "$line" | cut -d'*' -f1)
    data=($data)
    olfIFS="$IFS"; IFS=',' read -r -a data <<< "${data[@]}"; IFS="$oldIFS"
    if [ "${data[0]}" == "I" ]; then
      if [ "${data[1]}" == "Product ID" ]; then
        info_line=("${data[@]}")
        padlen=$(printf "%s\n" "${info_line[@]:4}" | awk '{ print length }' | sort -n | tail -n1)
        printf "%s," "${info_line[@]}"
        echo ""
      else
        echo "${data[@]:3}"
      fi
      continue;
    fi

    if [ -z "$info_line" ]; then echo 'Awaiting info line...'; continue; fi

    # example readout line:
    # D,VCP-PTH450-CAL,E24638,,102466,Pa,24.87,C,66.81,%,*d16d

    # extract device ID
    device="${data[1]} ${data[2]}"

    # extract readout values
    for i in $(seq 4 2 $(echo $data | wc -w)); do
      if [[ ! $(echo $data | awk "{print \$$i}") =~ ^[0-9]+$ ]]; then
        data[$i]=$(echo $data | awk "{print \$$i}" | tr -d ',')
      else
        data[$i]=$(echo $data | awk "{print \$$i}")
      fi
    done

    # print it out
    echo -e "\n$t, $device"
    for ((i=4; i<${#data[@]}; i+=2)); do
      printf "%-${padlen}s %s %s\n" "${info_line[i]}" "${data[i]}" "${data[i+1]}"
    done

  done
}
# run process_data in the background
process_data &


# Wait for background process to finish
wait
exec 3<&-
