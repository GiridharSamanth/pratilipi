export VER="0.21.2"

wget https://github.com/oliver006/redis_exporter/releases/download/v${VER}/redis_exporter-v${VER}.linux-amd64.tar.gz

tar xvf redis_exporter-v${VER}.linux-amd64.tar.gz

sudo mv redis_exporter /usr/local/bin/

rm -f redis_exporter-v${VER}.linux-amd64.tar.gz

sudo groupadd --system prometheus

sudo useradd -s /sbin/nologin --system -g prometheus prometheus

touch /etc/systemd/system/redis_exporter.service

cd /etc/systemd/system

cat << EOF >> redis_exporter.service
[Unit]
Description=Prometheus
Documentation=https://github.com/oliver006/redis_exporter
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/usr/local/bin/redis_exporter \
  --log-format=txt \
  --namespace=redis \
  --web.listen-address=:9121 \
  --web.telemetry-path=/metrics

SyslogIdentifier=redis_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF

cat << EOF >> /etc/init.d/redis_exporter
PROGNAME=redis_exporter
PROG=/usr/local/bin/${PROGNAME}
RUNAS=prometheus
LOCKFILE=/var/lock/subsys/${PROGNAME}
PIDFILE=/var/run/${PROGNAME}.pid
LOGFILE=/var/log/${PROGNAME}.log
DAEMON_SYSCONFIG=/etc/sysconfig/${PROGNAME}

# GO CPU core Limit

#GOMAXPROCS=$(grep -c ^processor /proc/cpuinfo)
GOMAXPROCS=1

# Source config

. ${DAEMON_SYSCONFIG}

start() {
    if [[ -f $PIDFILE ]] > /dev/null; then
        echo "redis_exporter  is already running"
        exit 0
    fi

    echo -n "Starting redis_exporter  service…"
    daemonize -u ${USER} -p ${PIDFILE} -l ${LOCKFILE} -a -e ${LOGFILE} -o ${LOGFILE} ${PROG} ${ARGS}
    RETVAL=$?
    echo ""
    return $RETVAL
}

stop() {
    if [ ! -f "$PIDFILE" ] || ! kill -0 $(cat "$PIDFILE"); then
        echo "Service not running"
        return 1
    fi
    echo 'Stopping service…'
    #kill -15 $(cat "$PIDFILE") && rm -f "$PIDFILE"
    killproc -p ${PIDFILE} -d 10 ${PROG}
    RETVAL=$?
    echo
    [ $RETVAL = 0 ] && rm -f ${LOCKFILE} ${PIDFILE}
    return $RETVAL
}

status() {
    if [ -f "$PIDFILE" ] || kill -0 $(cat "$PIDFILE"); then
      echo "redis exporter  service running..."
      echo "Service PID: `cat $PIDFILE`"
    else
      echo "Service not running"
    fi
     RETVAL=$?
     return $RETVAL
}

# Call function
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    status)
        status
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
        exit 2
esac
EOF


sudo systemctl enable redis_exporter
sudo systemctl start redis_exporter
