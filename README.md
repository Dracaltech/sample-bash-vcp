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

## Sample output
<img src="https://github.com/Dracaltech/sample-bash-vcp/assets/1357711/a97d661d-786c-4bad-883f-5527d5196fc7" width=400 />

```
Ξ dracal/sample-bash-vcp git:(main) ▶ ./main.sh /dev/ttyACM0 1000
Awaiting info line...
Printing 2 fractional digits
I,Product ID,Serial Number,Message,MS5611 Pressure,Pa,SHT31 Temperature,C,SHT31 Relative Humidity,%,

2024-02-19 12:37:01, VCP-PTH450-CAL E24638
MS5611 Pressure         102993 Pa
SHT31 Temperature       29.82 C
SHT31 Relative Humidity 55.78 %

2024-02-19 12:37:02, VCP-PTH450-CAL E24638
MS5611 Pressure         102993 Pa
SHT31 Temperature       29.85 C
SHT31 Relative Humidity 55.75 %

2024-02-19 12:37:03, VCP-PTH450-CAL E24638
MS5611 Pressure         102994 Pa
SHT31 Temperature       29.85 C
SHT31 Relative Humidity 55.73 %

2024-02-19 12:37:04, VCP-PTH450-CAL E24638
MS5611 Pressure         102993 Pa
SHT31 Temperature       29.84 C
SHT31 Relative Humidity 55.74 %
^C
↑130 dracal/sample-bash-vcp git:(main) ▶
```
