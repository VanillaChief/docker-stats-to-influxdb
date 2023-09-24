## docker-stats-to-influxdb

Script for monitoring Docker containers (using **docker stats** and **docker ps**) with data sent to Influx database and visualized in Grafana. Added convert GB/GiB (from rounding) and kB/KiB to MB (**all output to MByte**).

### 🚀 Install

For creat service (unit systemd) and download script from github repository can be used [deploy](https://github.com/Lifailon/docker-stats-to-influxdb/blob/rsa/deploy.sh) script.

Run at the command prompt (**root privileges required**):

`curl https://raw.githubusercontent.com/Lifailon/docker-stats-to-influxdb/rsa/deploy.sh | bash`

Check the status of the service:

```bash
root@netbox-01:~# systemctl status docker-stats-to-influxdb
● docker-stats-to-influxdb.service - Select docker statistics and output to Influx Database
     Loaded: loaded (/etc/systemd/system/docker-stats-to-influxdb.service; enabled; vendor preset: enabled)
     Active: active (running) since Sun 2023-09-24 01:21:32 MSK; 22s ago
   Main PID: 1607314 (bash)
      Tasks: 2 (limit: 2220)
     Memory: 32.8M
     CGroup: /system.slice/docker-stats-to-influxdb.service
             ├─1607314 /bin/bash /root/docker-stats-to-influxdb.sh
             └─1610358 sleep 5

Sep 24 01:21:44 netbox-01 bash[1608384]: 0.10        0.20        3.80/1895.00        0.05/0.02        5.43/0.09        5  >
Sep 24 01:21:44 netbox-01 bash[1608384]: 0.82        4.66        90.38/1895.00       15.39/12.17      1571.18/51.18    33 >
Sep 24 01:21:52 netbox-01 bash[1609432]: 0.01        0.76        14.66/1895.00       0.00/0.00        20.00/0.00       6  >
Sep 24 01:21:52 netbox-01 bash[1609432]: 0.13        0.65        12.66/1895.00       0.84/9.94        34.40/0.00       4  >
Sep 24 01:21:52 netbox-01 bash[1609432]: 0.00        0.82        15.97/1895.00       13.30/1.50       35.70/50.90      4  >
Sep 24 01:21:52 netbox-01 bash[1609432]: 0.01        0.96        18.67/1895.00       1.04/0.15        1370.00/0.00     3  >
Sep 24 01:21:52 netbox-01 bash[1609432]: 0.09        0.15        2.89/1895.00        0.02/0.00        3.65/0.00        5  >
Sep 24 01:21:52 netbox-01 bash[1609432]: 0.00        1.12        21.73/1895.00       0.14/0.56        102.00/0.19      6  >
Sep 24 01:21:53 netbox-01 bash[1609432]: 0.09        0.20        3.80/1895.00        0.05/0.02        5.43/0.09        5  >
Sep 24 01:21:53 netbox-01 bash[1609432]: 0.33        4.66        90.38/1895.00       15.39/12.17      1571.18/51.18    33 >
```

For connect to the Influx database, specify the your values of the variables:

```bash
5 ip="192.168.3.104" # IP address influx server
6 port="8086"        # Port influx server
7 db="docker"        # Databases name
8 table="stats"      # Measurement
```

Or do a [fork](https://github.com/login?return_to=%2FLifailon%2Fdocker-stats-to-influxdb) of the repository, change the variables to connect to the database and run the deploy or use the configuration system to remote start.

### 📑 Debug output

Example original output and after convert

```bash
00.00%  0.76%   14.66MiB/1.895GiB       1.89kB/0B       20MB/0B         6       stage_back.1.x3o95788jnrr9puxy5x0h0arm
00.11%  0.65%   12.7MiB/1.895GiB        836kB/9.86MB    34.4MB/0B       4       portainer_agent.rb0eurxmxegg1at1ukcbki6de.scs3y0p57fyjbczx0w6itxya1
00.00%  0.82%   15.91MiB/1.895GiB       13.2MB/1.49MB   35.7MB/50.5MB   4       portainer_portainer.1.ep75bz1qhn2x9tx6js0u1ap39
00.00%  0.96%   18.67MiB/1.895GiB       1.04MB/152kB    1.37GB/0B       3       netbox-docker-netbox-housekeeping-1
00.09%  0.15%   2.895MiB/1.895GiB       20.2kB/0B       3.65MB/0B       5       netbox-docker-redis-1
00.00%  1.12%   21.73MiB/1.895GiB       138kB/555kB     102MB/188kB     6       netbox-docker-postgres-1
00.09%  0.20%   3.801MiB/1.895GiB       50.5kB/19kB     5.43MB/90.1kB   5       netbox-docker-redis-cache-1

0.00    0.76    14.66/1895.00           0.00/0.00       20.00/0.00      6       562.00  stage_back.1.x3o95788jnrr9puxy5x0h0arm
0.11    0.65    12.70/1895.00           0.84/9.86       34.40/0.00      4       154.00  portainer_agent.rb0eurxmxegg1at1ukcbki6de.scs3y0p57fyjbczx0w6itxya1
0.00    0.82    15.91/1895.00           13.20/1.49      35.70/50.50     4       280.00  portainer_portainer.1.ep75bz1qhn2x9tx6js0u1ap39
0.00    0.96    18.67/1895.00           1.04/0.15       1370.00/0.00    3       684.00  netbox-docker-netbox-housekeeping-1
0.09    0.15    2.89/1895.00            0.02/0.00       3.65/0.00       5       37.80   netbox-docker-redis-1
0.00    1.12    21.73/1895.00           0.14/0.56       102.00/0.19     6       237.00  netbox-docker-postgres-1
0.09    0.20    3.80/1895.00            0.05/0.02       5.43/0.09       5       37.80   netbox-docker-redis-cache-1
0.29    4.66    90.36/1895.00           15.29/12.08     1571.18/50.78   33      1992.6  SUM
```

### 📊 Influx data

![Image alt](https://github.com/Lifailon/docker-stats-to-influxdb/blob/rsa/screen/influxdb-data.jpg)

Tag key **container**:

![Image alt](https://github.com/Lifailon/docker-stats-to-influxdb/blob/rsa/screen/tag-key-container.jpg)

Tag key **host**:

![Image alt](https://github.com/Lifailon/docker-stats-to-influxdb/blob/rsa/screen/tag-key-host.jpg)

Filtering by **summary load (sum)** in the last one minute:

`SELECT * FROM "stats" WHERE container = 'sum' and time > now() - 1m`

![Image alt](https://github.com/Lifailon/docker-stats-to-influxdb/blob/rsa/screen/select-sum.jpg)

### 📈 Grafana dashboard

Example dashboard for sum all containers

![Image alt](https://github.com/Lifailon/docker-stats-to-influxdb/blob/rsa/screen/grafana-dashboard-sum.jpg)

Selected container:

![Image alt](https://github.com/Lifailon/docker-stats-to-influxdb/blob/rsa/screen/grafana-dashboard-uptime.jpg)
