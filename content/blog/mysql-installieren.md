+++
author = ""
categories = ["Linux"]
date = "2016-09-13T23:06:41+02:00"
description = ""
featured = ""
featuredalt = ""
featuredpath = ""
linktitle = ""
title = "Mysql installieren"
type = "post"
tags = ["MySQL", "Ubuntu", "apparmor"]

+++

Ich wollte auf meinen neuen Server [MySQL] installieren und die Verzeichnisstruktur ändern. Das
ganze ist normal in 5 Minuten erledigt. Aber ich habe nicht daran gedacht, dass bei [Ubuntu 16.04]
[Apparmor] für MySQL aktiv ist. Apparmor ist ein Sicherheitsframework, welches Netzwerk- und
Dateizugriffe für Prozesse bzw. Anwendungen überwacht. So wurde aktiv verhindert, dass MySQL 
seine Dateien an die neue Stelle schreiben konnte. Zum Schluss bin ich mit `dmesg -T` Apparmor 
auf die Schliche gekommen. Die Fehler sehen wie folgt aus:

```
...
[Fri Sep  9 23:03:36 2016] audit: type=1400 audit(1473455017.174:68): apparmor="DENIED" operation="mknod" profile="/usr/sbin/mysqld" name="/srv/mysql/data/0rpheus.lower-test" pid=13709 comm="mysqld" requested_mask="c" denied_mask="c" fsuid=0 ouid=0
[Fri Sep  9 23:03:45 2016] audit: type=1400 audit(1473455026.698:69): apparmor="DENIED" operation="open" profile="/usr/sbin/mysqld" name="/srv/mysql/data/" pid=13710 comm="mysqld" requested_mask="r" denied_mask="r" fsuid=0 ouid=111
[Fri Sep  9 23:05:48 2016] audit: type=1400 audit(1473455149.078:70): apparmor="DENIED" operation="open" profile="/usr/sbin/mysqld" name="/srv/mysql/data/" pid=13719 comm="mysqld" requested_mask="r" denied_mask="r" fsuid=0 ouid=111
[Fri Sep  9 23:06:10 2016] audit: type=1400 audit(1473455171.034:71): apparmor="DENIED" operation="mkdir" profile="/usr/sbin/mysqld" name="/srv/mysql/data/" pid=13724 comm="mysqld" requested_mask="c" denied_mask="c" fsuid=0 ouid=0
...
```

## MySQL mit eigener Verzeichnisstruktur installieren

Ich gehe davon aus, dass man der Nutzer *root* ist. Mit `sudo -i` kann man 
zum Nutzter *root* werden, alternativ schreibt man `sudo` vor jedes Komando.


Zuerst installiert man ganz klassisch MySQL mittels `apt install mysql-server`.
Ich habe mich für die folgende Verzeichnisstruktur entschieden:
```
# tree  /srv/mysql/
/srv/mysql/
├── binlog
├── data
├── log
├── relay
└── tmp
```
Diese habe ich klassisch mit `mkdir -p` angelegt. Der Nutzer *mysql* bekommt die Verzeichnisse mit dem 
Komando `chown -R mysql:mysql /srv/mysql/` übertragen. Als nächstes kommt die Hauptarbeit,
eine Konfiguration für MySQL. Bei Ubuntu 16.04 befindet sich diese unter `/etc/mysql/mysql.conf.d/mysqld.cnf`

#### Beispielkonfiguration

```
[mysqld_safe]
socket          = /var/run/mysqld/mysqld.sock
nice            = 0

[mysqld]

user                           = mysql
skip-external-locking

# Connection and Thread variables

port                           = 3306
socket                         = /var/run/mysqld/mysqld.sock
pid-file                       = /var/run/mysqld/mysqld.pid
basedir                        = /usr
lc-messages-dir                = /usr/share/mysql
datadir                        = /srv/mysql/data/
tmpdir                         = /srv/mysql/tmp

max_allowed_packet             = 16M
default_storage_engine         = InnoDB
explicit_defaults_for_timestamp = 1                                  # MySQL 5.6, test carefully! This can have an impact on application.

character_set_server           = utf8                                # If you prefer utf8
collation_server               = utf8_general_ci

max_connections                = 205                                 # Values < 1000 are typically good
max_user_connections           = 200                                 # Limit one specific user/application
thread_cache_size              = 205                                 # Up to max_connections makes sense


# Query Cache

query_cache_type               = 1                                   # Set to 0 to avoid global QC Mutex
query_cache_size               = 32M                                 # Avoid too big (> 128M) QC because of QC clean-up lock!


# Session variables

sort_buffer_size               = 2M                                  # Could be too big for many small sorts
tmp_table_size                 = 32M                                 # Make sure your temporary results do NOT contain BLOB/TEXT attributes

read_buffer_size               = 128k                                # Resist to change this parameter if you do not know what you are doing
read_rnd_buffer_size           = 256k                                # Resist to change this parameter if you do not know what you are doing
join_buffer_size               = 128k                                # Resist to change this parameter if you do not know what you are doing


# Other buffers and caches

table_definition_cache         = 400                                 # As big as many tables you have
table_open_cache               = 512                                 # connections x tables/connection (~2)


# MySQL error log

log_error                      = /srv/mysql/log/error.log
log_timestamps                 = SYSTEM                              # MySQL 5.7, equivalent to old behaviour
log_error_verbosity            = 3                                   # MySQL 5.7, equivalent to log_warnings = 2
innodb_print_all_deadlocks     = 1
# wsrep_log_conflicts            = 1                                 # for Galera only!


# Slow Query Log

slow_query_log_file            = /srv/mysql/log/slow.log
slow_query_log                 = 0
log_queries_not_using_indexes  = 0
long_query_time                = 0.5
min_examined_row_limit         = 100


# General Query Log

general_log_file               = /srv/mysql/log/general.log
general_log                    = 0


# Binary logging and Replication

server_id                      = 64
log_bin                        = /srv/mysql/binlog/binlog            # Locate outside of datadir
master_verify_checksum         = ON                                  # MySQL 5.6
binlog_cache_size              = 1M
binlog_stmt_cache_size         = 1M
max_binlog_size                = 200M                                # Make bigger for high traffic to reduce number of files
sync_binlog                    = 0                                   # Set to 1 or higher to reduce potential loss of binary-log data
expire_logs_days               = 30                                  # We will survive easter holidays
binlog_format                  = ROW                                 # Use MIXED if you experience some troubles
binlog_row_image               = MINIMAL                             # Since 5.6
# auto_increment_increment       = 2                                 # For Master/Master set-ups use 2 for both nodes
# auto_increment_offset          = 1                                 # For Master/Master set-ups use 1 and 2


# Slave variables

log_slave_updates              = 1                                   # Use if Slave is used for Backup and PiTR
read_only                      = 0                                   # Set to 1 to prevent writes on Slave
# skip_slave_start               = 1                                 # To avoid start of Slave thread
relay_log                      = /srv/mysql/relay/relay-bin
# relay_log_info_repository      = table                             # MySQL 5.6
# master_info_repository         = table                             # MySQL 5.6
slave_load_tmpdir              = '/srv/mysql/tmp'


# Security variables

# local_infile                   = 0                                 # If you are security aware
# secure_auth                    = 1                                 # If you are security aware
# sql_mode                       = TRADITIONAL,ONLY_FULL_GROUP_BY,NO_ENGINE_SUBSTITUTION,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER   # Be careful changing this afterwards
# skip_name_resolve              = 0                                 # Set to 1 if you do not trust your DNS or experience problems
# secure_file_priv               = '/tmp'                            # chmod 750


# MyISAM variables

key_buffer_size                = 8M                                  # Set to 25 - 33 % of RAM if you still use MyISAM
myisam_recover_options         = 'BACKUP,FORCE'
disabled_storage_engines       = 'MyISAM'                            # MySQL 5.7, do NOT during/before mysql_upgrade


# MEMORY variables

max_heap_table_size            = 64M                                 # Should be greater or equal to tmp_table_size


# InnoDB variables

innodb_strict_mode             = ON
innodb_file_format_check       = 1
innodb_file_format             = Barracuda                           # For dynamic and compressed InnoDB tables
innodb_buffer_pool_size        = 256M                                # Go up to 80% of your available RAM
innodb_buffer_pool_instances   = 2                                   # Bigger if huge InnoDB Buffer Pool or high concurrency

innodb_file_per_table          = 1                                   # Is the recommended way nowadays
# innodb_flush_method            = O_DIRECT                          # O_DIRECT is sometimes better for direct attached storage
# innodb_write_io_threads        = 8                                 # If you have a strong I/O system or SSD
# innodb_read_io_threads         = 8                                 # If you have a strong I/O system or SSD
# innodb_io_capacity             = 1000                              # If you have a strong I/O system or SSD

innodb_flush_log_at_trx_commit = 0                                   # 1 for durability, 0 or 2 for performance
innodb_log_buffer_size         = 8M                                  # Bigger if innodb_flush_log_at_trx_commit = 0
innodb_log_file_size           = 256M                                # Bigger means more write throughput but longer recovery time


# Galera specific MySQL parameter

# default_storage_engine         = InnoDB                            # Galera only works with InnoDB
# innodb_flush_log_at_trx_commit = 0                                 # Durability is achieved by committing to the Group
# innodb_autoinc_lock_mode       = 2                                 # For parallel applying
# binlog_format                  = row                               # Galera only works with RBR
# query_cache_type               = 0                                 # Use QC with Galera only in a Master/Slave set-up
# query_cache_size               = 0


# WSREP parameter

# wsrep_provider                 = none                                # Start mysqld without Galera
# wsrep_provider                 = /usr/lib/galera/libgalera_smm.so    # Location of Galera Plugin on Ubuntu ?
# wsrep_provider                 = /usr/lib64/galera-3/libgalera_smm.so   # Location of Galera Plugin on CentOS 7
# wsrep_provider_options         = 'gcache.size = 1G'                  # Depends on you workload, WS kept for IST

# wsrep_cluster_name             = "My cool Galera Cluster"            # Same Cluster name for all nodes
# wsrep_cluster_address          = "gcomm://"                          # Initial Cluster start
# wsrep_cluster_address          = "gcomm://192.168.0.2,192.168.0.3"   # Start other nodes like this

# wsrep_node_name                = "Node A"                            # Unique node name
# wsrep_node_address             = 192.168.0.1                         # Our address where replication is done
# wsrep_node_incoming_address    = 10.0.0.1                            # Our external interface where application comes from
# wsrep_causal_reads             = 1                                   # If you need realy full-synchronous replication (Galera 3.5 and older)
# wsrep_sync_wait                = 1                                   # If you need realy full-synchronous replication (Galera 3.6 and newer)
# wsrep_slave_threads            = 1                                   # 4 - 8 per core, not more than wsrep_cert_deps_distance

# wsrep_sst_method               = mysqldump                           # SST method (initial full sync): mysqldump, rsync, rsync_wan, xtrabackup-v2
# wsrep_sst_auth                 = sst:secret                          # Username/password for sst user
# wsrep_sst_receive_address      = 192.168.0.1                         # Our address where to receive SST
```

## Apparmor konfigurieren

Ich mache es mir einfach und erlaube MySQL, dass es unter `/srv/mysql/` alles machen darf. Dazu habe die Datei
`/etc/apparmor.d/local/usr.sbin.mysqld` mit dem folgenden Inhalt erstellt:

```
# Site-specific additions and overrides for usr.sbin.mysqld.
# For more details, please see /etc/apparmor.d/local/README.

/srv/mysql/** rwk,

/run/mysqld/mysql.sock.lock rw,
/var/run/mysqld/mysql.sock.lock rw,
```


## Installation abschließen

1. Apparmor Profile neu laden `systemctl reload apparmor.service`
2. MySQL anhalten `systemctl stop mysql.service`
3. MySQL initialisieren `mysqld --initialize`
4. Temporäres root-Passwort auslesen `cat /srv2/mysql/log/error.log | grep "temporary password"`
5. MySQL starten `systemctl start mysql.service`


Man kann sich nun als Nutzer *root* mit dem Passwort aus Schritt 4 einloggen:
```
mysql -uroot -p
```


[MySQL]: https://www.mysql.de/
[Ubuntu 16.04]: https://wiki.ubuntuusers.de/Xenial_Xerus/
[Apparmor]: https://wiki.ubuntu.com/AppArmor
