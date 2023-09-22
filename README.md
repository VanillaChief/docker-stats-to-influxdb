## docker-stats-to-influxdb

Get docker statistics (using command **docker stats**) and out to Influx Database for monitoring consumed resources containers via Grafana. Added convert GB/GiB (from rounding) and kB/KiB to MByte.

### Install

**Creat unit file:** /etc/systemd/system/[docker-stats-to-influxdb.service](https://raw.githubusercontent.com/Lifailon/docker-stats-to-influxdb/rsa/docker-stats-to-influxdb.service) \
**Script path:** /root/[docker-stats-to-influxdb.sh](https://raw.githubusercontent.com/Lifailon/docker-stats-to-influxdb/rsa/docker-stats-to-influxdb.sh)

```bash
root@netbox-01:~# systemctl daemon-reload
root@netbox-01:~# systemctl enable docker-stats-to-influxdb.service
root@netbox-01:~# systemctl start docker-stats-to-influxdb
root@netbox-01:~# systemctl status docker-stats-to-influxdb
● docker-stats-to-influxdb.service - Select docker statistics and output to Influx Database
     Loaded: loaded (/etc/systemd/system/docker-stats-to-influxdb.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2023-09-22 02:14:41 MSK; 10h ago
   Main PID: 1900797 (bash)
      Tasks: 2 (limit: 2220)
     Memory: 9.9M
     CGroup: /system.slice/docker-stats-to-influxdb.service
             ├─1300169 sleep 5
             └─1900797 /bin/bash /root/docker-stats-to-influxdb.sh

Sep 22 12:26:29 netbox-01 bash[1298594]: 0.09        0.20        3.85/1895.00        0.04/0.02        3.86/0.07        netbox-docker-r>
Sep 22 12:26:29 netbox-01 bash[1298594]: 0.29        4.26        82.46/1895.00        301.65/213.58        1291.61/860.26        SUM
Sep 22 12:26:37 netbox-01 bash[1299412]: 0.00        0.63        12.25/1895.00        285.00/44.90        79.40/860.00        portaine>
Sep 22 12:26:37 netbox-01 bash[1299412]: 0.14        0.50        9.68/1895.00        15.60/168.00        39.00/0.00        portainer_a>
Sep 22 12:26:37 netbox-01 bash[1299412]: 0.00        0.68        13.10/1895.00        0.01/0.00        22.70/0.00        stage_back.1.>
Sep 22 12:26:37 netbox-01 bash[1299412]: 0.00        0.82        15.99/1895.00        0.86/0.12        1060.00/0.00        netbox-dock>
Sep 22 12:26:37 netbox-01 bash[1299412]: 0.10        0.17        3.21/1895.00        0.02/0.00        3.65/0.00        netbox-docker-r>
Sep 22 12:26:37 netbox-01 bash[1299412]: 0.00        1.26        24.38/1895.00        0.12/0.54        83.00/0.19        netbox-docker>
Sep 22 12:26:37 netbox-01 bash[1299412]: 0.17        0.20        3.85/1895.00        0.04/0.02        3.86/0.07        netbox-docker-r>
Sep 22 12:26:37 netbox-01 bash[1299412]: 0.41        4.26        82.46/1895.00        301.65/213.58        1291.61/860.26        SUM
```

### Debug output

Example original output and after convert

```bash
00.86%  0.72%   14.04MiB/1.895GiB       263MB/42.3MB    79.4MB/778MB    portainer_portainer.1.uhle20tgd5b77v5g26rh5yote
00.08%  0.52%   10.04MiB/1.895GiB       14.1MB/152MB    37.4MB/0B       portainer_agent.rb0eurxmxegg1at1ukcbki6de.527acdfxs6unp7qs6fpp2ohhh
00.00%  0.67%   13.06MiB/1.895GiB       13.5kB/0B       22.7MB/0B       stage_back.1.uqxrqldyv5lwg0rvk2mlma4im
00.00%  1.83%   35.43MiB/1.895GiB       854kB/124kB     1.06GB/0B       netbox-docker-netbox-housekeeping-1
00.10%  0.17%   3.328MiB/1.895GiB       16.1kB/0B       3.65MB/0B       netbox-docker-redis-1
00.00%  1.32%   25.7MiB/1.895GiB        123kB/541kB     81.3MB/188kB    netbox-docker-postgres-1
00.07%  0.21%   4.055MiB/1.895GiB       43.1kB/16.8kB   3.86MB/73.7kB   netbox-docker-redis-cache-1

0.86    0.72    14.04/1895.00           263.00/42.30    79.40/778.00    portainer_portainer.1.uhle20tgd5b77v5g26rh5yote
0.08    0.52    10.04/1895.00           14.10/152.00    37.40/0.00      portainer_agent.rb0eurxmxegg1at1ukcbki6de.527acdfxs6unp7qs6fpp2ohhh
0.00    0.67    13.06/1895.00           0.01/0.00       22.70/0.00      stage_back.1.uqxrqldyv5lwg0rvk2mlma4im
0.00    1.83    35.43/1895.00           0.85/0.12       1060.00/0.00    netbox-docker-netbox-housekeeping-1
0.10    0.17    3.33/1895.00            0.02/0.00       3.65/0.00       netbox-docker-redis-1
0.00    1.32    25.70/1895.00           0.12/0.54       81.30/0.19      netbox-docker-postgres-1
0.07    0.21    4.05/1895.00            0.04/0.02       3.86/0.07       netbox-docker-redis-cache-1
1.11    5.44    105.65/1895.00          278.14/194.98   1288.31/778.26  SUM
```

### Influx data

![Image alt](https://github.com/Lifailon/docker-stats-to-influxdb/blob/rsa/screen/influxdb-data.jpg)

Tag key **container**:

![Image alt](https://github.com/Lifailon/docker-stats-to-influxdb/blob/rsa/screen/tag-key-container.jpg)

Tag key **host**:

![Image alt](https://github.com/Lifailon/docker-stats-to-influxdb/blob/rsa/screen/tag-key-host.jpg)

Filtering by **summary load (sum)** in the last five minutes:

`SELECT * FROM "stats" WHERE container = 'sum' and time > now() - 5m`

![Image alt](https://github.com/Lifailon/docker-stats-to-influxdb/blob/rsa/screen/select-sum.jpg)

### Grafana dashboard

Example dashboard for sum all containers

![Image alt](https://github.com/Lifailon/docker-stats-to-influxdb/blob/rsa/screen/grafana-dashboard-sum.jpg)
