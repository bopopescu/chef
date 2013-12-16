#
# Cookbook Name:: kafka
# Attributes:: default
#

default[:kafka][:version] = '0.8.0'
default[:kafka][:base_url] = 'http://yum.ihr/files'
default[:kafka][:checksum] = nil
default[:kafka][:md5_checksum] = nil
default[:kafka][:scala_version] = nil

default[:kafka][:install_dir] = '/data/kafka/kafka'
default[:kafka][:data_dir] = '/data/kafka/data'
default[:kafka][:log_dir] = '/var/log/kafka'
default[:kafka][:log4j_config] = 'log4j.properties'
default[:kafka][:config] = 'server.properties'

default[:kafka][:user] = 'kafka'
default[:kafka][:group] = 'kafka'

default[:kafka][:log_level] = 'INFO'
default[:kafka][:jmx_port] = 9999

default[:kafka][:install_method] = :source
