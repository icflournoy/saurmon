#!/bin/bash

# Setup remote environment
cd ~
mkdir -p healthy
cd healthy/

HOSTNAME=$(hostname -f)
echo -e "Hostname:\t" $HOSTNAME
echo -e "Uptime:\t\t" `uptime`
DISKS=`/sbin/fdisk -l | grep -P "^Disk /dev/sd" | cut -d " " -f 2 | cut -c -8`

echo -e "-------------------------------------------------------------------------------------------------------------------------------------------------"
echo -e "Disk Size Model SpinTime Reallocated Temp OfflineUncorrect ReportedUncorrect SeekError ReadError SpinRetry" > .temp

/sbin/fdisk -l > $HOSTNAME-fdisk

for disk in $DISKS;
do
	NICE=$(echo "$disk" | cut -d "/" -f 3)
    SMART=$(/usr/sbin/smartctl -a $disk | tee $HOSTNAME-smartctl-$NICE)
#    SIZE=$(df -h $disk | tail -n 1 | awk '{print $2}')
	SIZE=$(/sbin/fdisk -l | grep "^Disk $disk" | awk '{print $3}')
	MODEL=$(echo -e "$SMART" | grep "Device Model" | cut -c 19- | tr ' ' '_')
    SPIN_TIME=$(echo -e "$SMART" | grep "Power_On_Hours" | awk '{print $10}')
    REALLOCATED=$(echo -e "$SMART" | grep "Reallocated_Sector_Ct" | awk '{print $10}')
    TEMP=$(echo -e "$SMART" | grep "Temperature_Celsius" | awk '{print $10}')
    OFFLINE_SECTOR=$(echo -e "$SMART" | grep "Offline_Uncorrectable" | awk '{print $10}')
    REPORTED_SECTOR=$(echo -e "$SMART" | grep "Reported_Uncorrect" | awk '{print $10}')
    SEEK_ERROR=$(echo -e "$SMART" | grep "Seek_Error_Rate" | awk '{print $10}')
    READ_ERROR=$(echo -e "$SMART" | grep "Raw_Read_Error_Rate" | awk '{print $10}')
    SPIN_RETRY=$(echo -e "$SMART" | grep "Spin_Retry_Count" | awk '{print $10}')

    echo -e "$NICE $SIZE $MODEL $SPIN_TIME $REALLOCATED $TEMP $OFFLINE_SECTOR $REPORTED_SECTOR $SEEK_ERROR $READ_ERROR $SPIN_RETRY" >> .temp
done
column -t  .temp | tee $HOSTNAME-disk_report
rm -rf .temp
