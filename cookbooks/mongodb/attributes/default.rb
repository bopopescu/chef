#Default MongoDB Configuration elements

include_attribute 'mongodb::arbmongod'
include_attribute 'mongodb::mongosd'
include_attribute 'mongodb::cfgserver'


default[:mongodb][:packages] = %w{mongo-10gen mongo-10gen-server numactl pymongo munin-node}

#/etc/init.d/mongod startup file elements
default[:mongodb][:user]		='mongod'
default[:mongodb][:group]		='mongod'
default[:mongodb][:pidfile_name]	='mongod.pid'
default[:mongodb][:pidfile_loc]		='/var/run/mongod'
default[:mongodb][:lock_file]		='/var/lock/subsys/mongod'
default[:mongodb][:data_dir]		='/data/db/mongo'
default[:mongodb][:data_device]		='/dev/mapper/centos-data'
default[:mongodb][:data_mount_point]	='/data'
default[:mongodb][:startup_script_name] ='/etc/init.d/mongod'

#mongod.conf config elements
default[:mongodb][:config_file_dir]	='/etc/'
default[:mongodb][:config_file_name]	='mongod.conf'
default[:mongodb][:replset]		=''
default[:mongodb][:port]		=37017
default[:mongodb][:logpath]		='/var/log/mongo/mongod.log'
default[:mongodb][:logdir]		='/var/log/mongo'
default[:mongodb][:rest]		='true'
default[:mongodb][:journal]		='true'
default[:mongodb][:configsvr]		='false'
default[:mongodb][:arbiter]		='false'
default[:mongodb][:oplogsize]           ='23552'

default[:mongodb][:backupdir]		='/data/db/backups'

default[:mongodb][:ulimits] = [ {
                                   "type" => "soft",
                                   "item" => "nofile",
                                   "value" => "65535"
                                 },
                                 {
                                   "type" => "hard",
                                   "item" => "nofile",
                                   "value" => "65535"
                                 }
                                ]


default[:mongodb][:source][:url] = "http://downloads.mongodb.org/linux/mongodb-linux-x86_64"
default[:mongodb][:source][:version] = "2.0.2"
default[:mongodb][:source][:install_path] = "/usr/bin"
default[:mongodb][:admin_scripts][:dir] = '/root/scripts'
default[:mongodb][:admin_scripts][:rev] = "HEAD"
default[:mongodb][:admin_scripts][:repo] = "git@github.ihrint.com:DB-OPS-QAC1/mongodba.git"
