default[:batchjobs][:packages] = %w{ pymongo pyodbc amqp freetds python-suds python-psycopg2 }
default[:batchjobs][:pip_packages] = { "sqlcmd" => "0.7.1" , "celery" => nil }
default[:batchjobs][:repo] = "git@github.ihrint.com:Ingestion/BatchJobs.git"
default[:batchjobs][:rev] = "HEAD"
default[:batchjobs][:deploy_path] = "/data/apps/batchjobs"
default[:batchjobs][:secretpath] = "/etc/chef/encrypted_data_bag_secret"
default[:batchjobs][:user] = "batchjobs"
default[:batchjobs][:group] = "batchjobs"
default[:batchjobs][:mssql_db] = "10.5.61.12"
case chef_environment
when /^development/
default[:batchjobs][:rabbit_host] = "iad-int-rabbitmq101.ihr"
default[:batchjobs][:rabbit_port] = 5672
default[:batchjobs][:rovi_upload_indentity] = "Dev"
end
