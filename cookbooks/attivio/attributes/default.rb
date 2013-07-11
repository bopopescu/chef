default[:attivio][:aie_install_path] = "/data/apps/attivio"
default[:attivio][:install_path] = "/data/apps/attivio31"
default[:attivio][:input_path] = "/data/apps/attivio31/input"
default[:attivio][:config_path] = "/data/apps/attivio31/iheartradio3/conf"
default[:attivio][:bin_path] = "/data/apps/attivio31/iheartradio3/bin"
default[:attivio][:user] = "attivio"
default[:attivio][:group] = "attivio"

default[:attivio][:repo] = "git@github.com:iheartradio/attivio.git"
default[:attivio][:rev] = "deploy"

default[:attivio][:packages] = %w{ expect }

default[:attivio][:search_config] = ({
                                       "maxBooleanClauses" => "1000000",
                                       "searchCacheSize" => "50000",
                                       "searchAutowarmFactor" => "0.01",
                                       "searchCacheMaxRows" => "20",
                                       "searchCacheWindow" => "20",
                                       "filterCacheSize" => "25",
                                       "filterAutowarmFactor" => "0.01",
                                       "filterCacheSize" => "25",
                                       "filterAutowarmFactor" => "0.5",
                                       "documentCacheMinSize" => "50000",
                                       "documentCacheMaxSize" => "75000",
                                       "documentCacheLoadFactor" => "0.01" # cache size will be 10% of the segment size
                                     })
default[:attivio][:searcher][:memory] = "24g"
default[:attivio][:indexer][:memory] = "4g"
default[:attivio][:connector][:memory] = "1g"
default[:attivio][:memory] = "2g"

default[:attivio][:connector_port] = "19200"
default[:attivio][:indexer_port] = "19100"
default[:attivio][:searcher_port] = "19000"
default[:attivio][:zookeeper_port] = "15000"

default[:attivio][:backup_dir] = "/data/apps/backups"
default[:attivio][:backup_source] = "/data/apps/attivio31/iheartradio3/data1"

# ARTIST XML INDEXING
# These paths are appended to default[:attivio][:install_path]
default[:attivio][:directory][:xml_ingest] = "/input"
default[:attivio][:directory][:priority_ingest] = "/input/priority"
default[:attivio][:directory][:fac_archive] = "/fac-archive3"

default[:attivio][:xml][:artist_delete_batch_size] = "10"
default[:attivio][:xml][:track_update_batch_size] = "10"
default[:attivio][:xml][:artist_update_batch_size] = "10"
default[:attivio][:xml][:track_bundle_update_batch_size] = "10"

# ulimits
default[:attivio][:ulimits] = [{
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
