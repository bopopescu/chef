default[:fac][:script_path] = "/data/jobs/fac"
default[:fac][:url] = "http://archiva.ihrdev.com:8080/archiva/repository/internal/com/ccrd/fac"
default[:fac][:files_url] = "http://files.ihrdev.com/fac"
default[:fac][:radiobuild][:url] = "http://archiva.ihrdev.com:8080/archiva/repository/internal/com/ccrd/radio"
default[:fac][:radiobuild][:echonest] = "http://files.ihrdev.com/fac/ten.915.gz"
default[:fac][:radiobuild2][:url] = "http://archiva.ihrdev.com:8080/archiva/repository/internal/com/ccrd/radio"
default[:fac][:radiobuild2][:echonest] = "http://files.ihrdev.com/fac/ten.915.gz"
default[:fac][:recommendations][:url] = "http://archiva.ihrdev.com:8080/archiva/repository/internal/com/ccrd/fac"
default[:fac][:recommendations][:echonest] = "http://files.ihrdev.com/fac/ten.915.gz"
default[:fac][:amptools][:repo] = "git@github.com:iheartradio/amp-tools.git"
default[:fac][:genre][:radioedit][:rpc_url] = "iad-radioedit-test101.ihr/api/rpc"
default[:fac][:genre][:radioedit][:api_key] = "T2R6dFl2MXY4bA=="
default[:fac][:etl_notify] = %w{ jeremybraff@clearchannel.com kengilmer@clearchannel.com gregorypatmore@clearchannel.com }

case chef_environment

when /^prod/
	default[:fac][:es_vip] = "iad-search-vip-v200.ihr:9200"
	default[:fac][:PRN][:version] = "3.4.62"
	default[:fac][:talk][:version] = "3.4.122"
	default[:fac][:music][:version] = "3.4.98"
	default[:fac][:music2][:version] = "3.4.124"
	default[:fac][:sherpa][:version] = "3.4.94"
	default[:fac][:sherpa][:jarfile] = "FAC-sherpa"
	default[:fac][:radiobuild][:version] = "1.0.22"
	default[:fac][:radiobuild2][:version] = "1.0.23"
	default[:fac][:recommendations][:version] = "3.4.94"
	default[:fac][:genre][:version] = "3.4.110"
	default[:fac][:music2][:music_mongo_server] = "iad-mongo-fac101-v240.ihr:37017,iad-mongo-fac102-v240.ihr:37017,iad-mongo-fac103-v240.ihr:37017"
	default[:fac][:music2][:echonest_mongo_server] = "iad-mongo-fac101-v240.ihr:27017,iad-mongo-fac102-v240.ihr:27017,iad-mongo-fac103-v240.ihr:27017"
	default[:fac][:music2][:radio_mongo_server] = "iad-mongo-fac101-v240.ihr:27017,iad-mongo-fac102-v240.ihr:27017,iad-mongo-fac103-v240.ihr:27017"
	default[:fac][:music2][:habeo_mongo_server] = "iad-mongo-fac101-v240.ihr:27017,iad-mongo-fac102-v240.ihr:27017,iad-mongo-fac103-v240.ihr:27017"
	default[:fac][:music2][:env] = "live"
	default[:fac][:music2][:ingestion_jdbc] = "jdbc:jtds:sqlserver://iad-dwh-db102-vip.ihrint.com:1433;DatabaseName=Ingestion3"
	default[:fac][:music2][:mssql_jdbc] = "jdbc:jtds:sqlserver://iad-dwh-db102-vip.ihrint.com:1433;DatabaseName=radiomodel"
	default[:fac][:music2][:elastic_rabbitmq_username]="thumbplay"
	default[:fac][:music2][:elastic_rabbitmq_password]="clearchannel"
	default[:fac][:music2][:elastic_rabbitmq_virtualHost]="/"
	default[:fac][:music2][:elastic_rabbitmq_host_name]="10.90.20.119"
	default[:fac][:music2][:elastic_rabbitmq_queuename]="es"

when /^stage/
	default[:fac][:es_vip] = "iad-stg-search-vip-v200.ihr:9200"
	default[:fac][:PRN][:version] = "3.4.62"
	default[:fac][:talk][:version] = "3.4.122"
	default[:fac][:music][:version] = "3.4.98"
	default[:fac][:music2][:version] = "3.4.124"
	default[:fac][:sherpa][:version] = "3.4.94"
	default[:fac][:sherpa][:jarfile] = "FAC-sherpa"
	default[:fac][:radiobuild][:version] = "1.0.22"
	default[:fac][:radiobuild2][:version] = "1.0.23"
	default[:fac][:recommendations][:version] = "3.4.94"
	default[:fac][:genre][:version] = "3.4.110"
	default[:fac][:music2][:music_mongo_server] = "iad-stg-mongo-fac101-v240.ihr:37017,iad-stg-mongo-fac102-v240.ihr:37017,iad-stg-mongo-fac103-v240.ihr:37017"
	default[:fac][:music2][:echonest_mongo_server] = "iad-stg-mongo-fac101-v240.ihr:27017,iad-stg-mongo-fac102-v240.ihr:27017,iad-stg-mongo-fac103-v240.ihr:27017"
	default[:fac][:music2][:radio_mongo_server] = "iad-stg-mongo-fac101-v240.ihr:27017,iad-stg-mongo-fac102-v240.ihr:27017,iad-stg-mongo-fac103-v240.ihr:27017"
	default[:fac][:music2][:habeo_mongo_server] = "iad-stg-mongo-fac101-v240.ihr:27017,iad-stg-mongo-fac102-v240.ihr:27017,iad-stg-mongo-fac103-v240.ihr:27017"
	default[:fac][:music2][:env] = "staging_v3_integration"
	default[:fac][:music2][:ingestion_jdbc] = "jdbc:jtds:sqlserver://10.5.50.101:1433;DatabaseName=ingestion3"
	default[:fac][:music2][:mssql_jdbc] = ""
	default[:fac][:music2][:elastic_rabbitmq_username]="fac"
	default[:fac][:music2][:elastic_rabbitmq_password]="tppw2011!"
	default[:fac][:music2][:elastic_rabbitmq_virtualHost]="/ingestion"
	default[:fac][:music2][:elastic_rabbitmq_host_name]="iad-stg-rabbitmq101-v700.ihr"
	default[:fac][:music2][:elastic_rabbitmq_queuename]="elasticsearch"
end
