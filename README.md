# sample-bash-vcp
Dracal // SDK code sample for Bash on VCP

## Simple usage

Run script
```
./main.sh <port> <interval>
```

e.g. if your device is running on `/dev/ttyACM0` _(refer to [VCP getting started](https://www.dracal.com/en/tutorials/getting-started-with-vcp-mode/))_ and you want to poll data every 1000ms:
```
./main.sh /dev/ttyACM0 1000
```
