directory "#{node[:elasticsearchnew][:ihrsearch_path]}/plugins" do
  owner node[:elasticsearchnew][:user]
  group node[:elasticsearchnew][:group]
  recursive true
end

service "elasticsearch" do
  provider Chef::Provider::Service::Init
  supports :start => true, :stop => true
end

unless tagged?("es-plugins-installed") then
  ES_HOME = node[:elasticsearchnew][:deploy_path]

  execute "delete plugins" do
    command "rm -rf #{ES_HOME}/plugins/*"
  end

  execute "install-ihrsearch-query-plugin" do
    command "#{ES_HOME}/bin/plugin --url #{node[:elasticsearchnew][:url]}/#{node[:elasticsearchnew][:install_tag]}/es-plugins/es-query-plugin-1.0.zip --install ihr-query"
    cwd Chef::Config[:file_cache_path]
    user node[:elasticsearchnew][:user]
    group node[:elasticsearchnew][:group]
  end
  execute "install-ihrsearch-indexer-plugin" do
    command "#{ES_HOME}/bin/plugin --url #{node[:elasticsearchnew][:url]}/#{node[:elasticsearchnew][:install_tag]}/es-plugins/es-indexer-plugin-1.0.zip --install ihr-index"
    cwd Chef::Config[:file_cache_path]
    notifies :restart, "service[elasticsearch]"
    user node[:elasticsearchnew][:user]
    group node[:elasticsearchnew][:group]
  end

  
  execute "install-river-rabbitmq-plugin" do
    command "#{ES_HOME}/bin/plugin --url #{node[:elasticsearchnew][:url]}/#{node[:elasticsearchnew][:install_tag]}/es-plugins/elasticsearch-river-rabbitmq.zip --install river-rabbitmq"
    cwd Chef::Config[:file_cache_path]
    # notifies :restart, "service[elasticsearch]"
    user node[:elasticsearchnew][:user]
    group node[:elasticsearchnew][:group]
  end

  primary_node=search(:node, "role:elasticsearchnew AND chef_environment:#{node.chef_environment}")[0]

  Chef::Log.info("Primary node info: #{primary_node}")
  Chef::Log.info("Host name info: #{node[:hostname]}")

  case node.chef_environment
  when /^stage/ then
    if primary_node[:hostname] == node[:hostname] then
      execute "configure-river-rabbitmq-plugin" do
        command <<-EOH 
          /usr/bin/curl -XPUT '#{node[:ipaddress]}:9200/_river/my_river/_meta' -d '{ \
          "type" : "rabbitmq", \
          "rabbitmq" : { \
              "addresses" : [ \
                  { \
                      "host" : "iad-stg-rabbitmq101.ihr.", \
                      "port" : 5672 \
                  }, \
                  { \
                      "host" : "iad-stg-rabbitmq102.ihr.", \
                      "port" : 5672 \
                  } \
              ], \
              "user" : "fac", \
              "pass" : "tppw2011!", \
              "vhost" : "/ingestion", \
              "queue" : "elasticsearch", \
              "exchange" : "elasticsearch", \
              "routing_key" : "elasticsearch", \
              "exchange_declare" : true, \
              "exchange_type" : "direct", \
              "exchange_durable" : true, \
              "queue_declare" : true, \
              "queue_bind" : true, \
              "queue_durable" : true, \
              "queue_auto_delete" : false, \
              "heartbeat" : "30s" \
          }, \
          "index" : { \
              "bulk_size" : 100, \
              "bulk_timeout" : "50ms", \
              "ordered" : false \
          } \
         }'
				EOH
      end # execute
    end # if primary
  end # when

end #unless tagged

tag("es-plugins-installed")
  
