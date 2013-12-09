#Place where application will live

# github location
default[:ingestion_ng][:repo] = 'git@github.com:iheartradio/ingestion.git'
default[:ingestion_ng][:branch] = 'deploy'

# deploy path
default[:ingestion_ng][:deploy_path] = '/data/apps/ingestion-ng'
default[:ingestion_ng][:venv] = 'shared/venv'
default[:ingestion_ng][:var] = '/var/ingestion-ng'

default[:ingestion_ng][:packages] = %w{ python27 python27-libs python27-devel python27-test python27-tools libxslt-devel libevent-devel nfs-utils postgresql-devel }

default[:ingestion_ng][:user] = 'ihr-deployer'
default[:ingestion_ng][:group] = 'ihr-deployer'

default[:ingestion_ng][:apps] = [ 'ingqueue' ].join(',')

# default[:ingestion_ng][:init_style] = "heartbeat" # heartbeat or init

default[:ingestion_ng][:db][:type] = 'mssql'
default[:ingestion_ng][:db][:driver] = 'pymssql'
default[:ingestion_ng][:db][:host] = 'mssql-aws'
default[:ingestion_ng][:db][:port] = 1433
default[:ingestion_ng][:db][:name] = 'ingestion'
default[:ingestion_ng][:db][:user] = 'appbatchuser_devdb'
default[:ingestion_ng][:db][:pass] = 'Ms9P34kW'

default[:ingestion_ng][:celery][:broker_url] = 'amqp://%{user}:%{pass}@iad-stg-rabbitmq101.ihr/%{vhost}'
default[:ingestion_ng][:celery][:default_exchange] = 'ingestion'
default[:ingestion_ng][:celery][:task_serializer] = 'json'
default[:ingestion_ng][:celery][:accept_content] = 'json'
default[:ingestion_ng][:celery][:pool] = 'gevent'
default[:ingestion_ng][:celery][:concurrency] = 8
default[:ingestion_ng][:celery][:result_exchange] = 'ingestion_results'
default[:ingestion_ng][:celery][:result_backend] = 'amqp'
default[:ingestion_ng][:celery][:task_result_expires] = 3600
default[:ingestion_ng][:celery][:imports] = 'ingqueue.tasks'
default[:ingestion_ng][:rabbit][:user] = 'amp-tomcat'
default[:ingestion_ng][:rabbit][:vhost] = '/amp'

# stage nfs mounts
default[:encoders][:stage_server] = "iad-stg-nfs101-v700.ihr"
default[:encoders][:s_ftp_export] = "/data//export/inbound-ftp"
default[:encoders][:s_ftp_mount] = "/data/inbound-ftp"
default[:encoders][:s_encoder_export] = "/data/export/encoder"
default[:encoders][:s_encoder_mount] = "/data/encoder"

# FreeTDS
default[:freetds][:servers][default[:ingestion_ng][:db][:name]] = {
  :description => 'Ingestion3 MSsql in AWS',
  :host => '10.5.1.52',
  :port => 1433,
  :tds_version => '8.0',
  :client_charset => 'UTF-8'
}

# ODBC
default[:odbc][:name] = default[:ingestion_ng][:db][:name]
default[:odbc][:driver] = '/usr/lib64/libtdsodbc.so'
default[:odbc][:database] = 'ingestion'
default[:odbc][:description] = default[:freetds][:servers][default[:odbc][:name]][:description]
default[:odbc][:host] = default[:freetds][:servers][default[:odbc][:name]][:host]
default[:odbc][:client_charset] = default[:freetds][:servers][default[:odbc][:name]][:client_charset]
