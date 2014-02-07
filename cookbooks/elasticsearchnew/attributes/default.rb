


default[:elasticsearchnew][:version] = "0.90.3"
default[:elasticsearchnew][:url] = "http://files.ihrdev.com/elasticsearch"

default[:elasticsearchnew][:base_path] = "/data/apps"
default[:elasticsearchnew][:deploy_path] = "/data/apps/elasticsearch"
default[:elasticsearchnew][:ihrsearch_path] = "/data/apps/ihr-search"
default[:elasticsearchnew][:input_path] = "/data/apps/ihr-search/input"
default[:elasticsearchnew][:ihrsearch][:files] = "configs.tar.gz"
default[:elasticsearchnew][:user] = "elasticsearch"
default[:elasticsearchnew][:group] = "elasticsearch"

# elasticsearch.yml
default[:elasticsearchnew][:shards] = "3"
default[:elasticsearchnew][:replicas] = "1"
default[:elasticsearchnew][:mlockall] = true
default[:elasticsearchnew][:cluster_name] = ""
case chef_environment 
when /^prod/
  default[:elasticsearchnew][:slowlog_settings] = { "index.search.slowlog.threshold.query.warn" => "10s", "index.search.slowlog.threshold.query.info" => "5s", "index.search.slowlog.threshold.query.debug" => "5s", "index.search.slowlog.threshold.query.trace" => "500ms", "index.search.slowlog.threshold.fetch.warn" => "1s", "index.search.slowlog.threshold.fetch.info" => "800ms", "index.search.slowlog.threshold.fetch.debug" => "800ms", "index.search.slowlog.threshold.fetch.trace" => "200ms", "index.indexing.slowlog.threshold.index.warn" => "10s", "index.indexing.slowlog.threshold.index.info" => "5s", "index.indexing.slowlog.threshold.index.debug" => "2s", "index.indexing.slowlog.threshold.index.trace" => "500ms" }
when /^stage/
  default[:elasticsearchnew][:slowlog_settings] = { "index.search.slowlog.threshold.query.warn" => "5s", "index.search.slowlog.threshold.query.info" => "2500ms", "index.search.slowlog.threshold.query.debug" => "2500ms", "index.search.slowlog.threshold.query.trace" => "250ms", "index.search.slowlog.threshold.fetch.warn" => "500ms", "index.search.slowlog.threshold.fetch.info" => "400ms", "index.search.slowlog.threshold.fetch.debug" => "400ms", "index.search.slowlog.threshold.fetch.trace" => "100ms", "index.indexing.slowlog.threshold.index.warn" => "5s", "index.indexing.slowlog.threshold.index.info" => "2500ms", "index.indexing.slowlog.threshold.index.debug" => "1s", "index.indexing.slowlog.threshold.index.trace" => "250ms" }
else
  default[:elasticsearchnew][:slowlog_settings] = { "index.search.slowlog.threshold.query.warn" => "5s", "index.search.slowlog.threshold.query.info" => "2500ms", "index.search.slowlog.threshold.query.debug" => "2500ms", "index.search.slowlog.threshold.query.trace" => "250ms", "index.search.slowlog.threshold.fetch.warn" => "500ms", "index.search.slowlog.threshold.fetch.info" => "400ms", "index.search.slowlog.threshold.fetch.debug" => "400ms", "index.search.slowlog.threshold.fetch.trace" => "100ms", "index.indexing.slowlog.threshold.index.warn" => "5s", "index.indexing.slowlog.threshold.index.info" => "2500ms", "index.indexing.slowlog.threshold.index.debug" => "1s", "index.indexing.slowlog.threshold.index.trace" => "250ms" }
end

# ulimits
default[:elasticsearchnew][:ulimits] = [{
                                 "type" => "hard",
                                 "item" => "nproc",
                                 "value" => "4096"
                               },
                               {
                                 "type" => "soft",
                                 "item" => "nproc",
                                 "value" => "4096"
                               },
                               {
                                 "type" => "hard",
                                 "item" => "nofile",
                                 "value" => "65535"
                               },
                               {
                                 "type" => "soft",
                                 "item" => "nofile",
                                 "value" => "65535"
                               }]
