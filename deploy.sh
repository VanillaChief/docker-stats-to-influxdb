# Download script and service from Github repository
service_path="/etc/systemd/system/docker-stats-to-influxdb.service"
script_path="/root/docker-stats-to-influxdb.sh"
curl https://raw.githubusercontent.com/Lifailon/docker-stats-to-influxdb/rsa/docker-stats-to-influxdb.service > $service_path
curl https://raw.githubusercontent.com/Lifailon/docker-stats-to-influxdb/rsa/docker-stats-to-influxdb.sh > $script_path
# Service launch
systemctl daemon-reload
systemctl enable docker-stats-to-influxdb.service
systemctl restart docker-stats-to-influxdb
# Get status
systemctl status docker-stats-to-influxdb