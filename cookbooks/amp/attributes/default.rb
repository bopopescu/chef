default[:amp][:version] = "wham-rc-1"
default[:amp][:amp_rest_version] = "2.23.0"
default[:amp][:url] = "http://files.ihrdev.com/amp"

default[:amp][:packages] = %w{ mongo-10gen-server mongo-10gen }

default[:amp][:pgbouncer][:port] = "5432"

default[:amp][:logging][:script_path] = "/data/apps/amp/logging"
default[:amp][:logging][:log_path] = "/var/log/amp"
default[:amp][:logger][:log_path] = "/data/apps/tomcat7/logs"

default[:amp][:logger][:url] = "http://files.ihrdev.com/amp/logger.war"

default[:amp][:logging][:user] = "nobody"
case node[:platform_family]
when "rhel"
  default[:amp][:logging][:group] = "nobody"
when "debian"
  default[:amp][:logging][:group] = "nogroup"
else
  default[:amp][:logging][:group] = "nobody"
end

default[:amp][:new_relic_directory] = "//data/apps/tomcat7/newrelic"
default[:amp][:new_relic_url] = "http://files.ihrdev.com/new_relic"
default[:amp][:new_relic_filename] = "newrelic_agent"
default[:amp][:new_relic_version] = "3.4.2"

case chef_environment
when /^prod/
  default[:amp][:usr_mongo][:hosts] = "localhost:27017"
  default[:amp][:usr_mongo][:connections_per_host] = 300
  default[:amp][:usr_mongo][:connect_timeout] = 3000
  default[:amp][:usr_mongo][:socket_timeout] = 3000
  default[:amp][:usr_mongo][:maxWaitTime] = 3000
  default[:amp][:usr_mongo][:threads_allowed_to_block_for_connections_multiplier] = 5
  default[:amp][:fac_mongo][:hosts] = "iad-mongo-fac101-v240.ihr:37017,iad-mongo-fac102-v240.ihr:37017,iad-mongo-fac103-v240.ihr:37017,iad-mongo-fac104-v240.ihr:37017"
  default[:amp][:fac_mongo][:connections_per_host] = 300
  default[:amp][:fac_mongo][:connect_timeout] = 5000
  default[:amp][:fac_mongo][:socket_timeout] = 5000
  default[:amp][:fac_mongo][:maxWaitTime] = 5000
  default[:amp][:fac_mongo][:threads_allowed_to_block_for_connections_multiplier] = 5
  default[:amp][:streams][:cdn][:base_url] = "http://stream.iheart.com"
  default[:amp][:streams][:mixin][:base_url] = "http://talkstream.iheart.com"
  default[:amp][:streams][:prn][:base_url] = "http://media.iheart.com"
  default[:amp][:image][:prefix] = "http://assets.iheart.com"
  default[:amp][:image][:amg_prefix] = "http://assets.iheart.com"
  default[:amp][:image][:talk_prefix] = "http://content.iheart.com"
  default[:amp][:image][:prn_prefix] = "http://content.iheart.com"
  default[:amp][:image][:smt_prefix] = "http://radioedit.iheart.com/service/img/"
  default[:amp][:image][:genre_prefix] = "http://radioedit.iheart.com/service/img/nop()/assets"
  default[:amp][:image][:genre_recs_prefix] = "http://radioedit.iheart.com/service/img/nop()/assets"
  default[:amp][:search][:pool_size] = 50
  default[:amp][:search][:pool_max_size] = 50
  default[:amp][:search][:max_wait] = 10
  default[:amp][:search][:queue_max_size] = 1000
  default[:amp][:search][:attivio][:url] = "http://iad-search-vip-v200.ihr:19001/query"
  default[:amp][:search][:attivio][:timeout] = 7000
  default[:amp][:search][:elastic][:url] = "http://iad-search-vip-v200.ihr:9200/_query"
  default[:amp][:search][:elastic][:timeout] = 5000
  default[:amp][:memcache][:prefix] = "ihr_tomcat"
  default[:amp][:memcache][:pnp_prefix] = "pnp_station_id_"
  default[:amp][:memcache][:pnp_artist_prefix] = "pnp_artist_"
  default[:amp][:memcache][:pnp_station_prefix] = "pnp_station_"
  default[:amp][:memcache][:urls] = "http://iad-amp-cache101-v200.ihr:8091/pools,http://iad-amp-cache102-v200.ihr:8091/pools,http://iad-amp-cache103-v200.ihr:8091/pools,http://iad-amp-cache104-v200.ihr:8091/pools"
  default[:amp][:facebook][:timeout] = 15000
  default[:amp][:facebook][:max_connections] = 150
  default[:amp][:facebook][:url] = "https://graph.facebook.com/me?access_token=%s&fields=email,id"
  default[:amp][:facebook][:exchange_url] = "https://graph.facebook.com/oauth/access_token?grant_type=fb_exchange_token&client_id=121897277851831&client_secret=9875e783fc3b1c8cfc839acf725c49bd&fb_exchange_token=%s"
  default[:amp][:google_plus][:url] = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=%s"
  default[:amp][:google_plus][:client_id] = "884160514548-4917aophkpafpbgh8r1lndhc3f128ouf.apps.googleusercontent.com"
  default[:amp][:google_plus][:secret] = ""
  default[:amp][:amazon][:url] = "https://api.amazon.com/auth/o2/tokeninfo?access_token=%s"
  default[:amp][:amazon][:client_id] = "amzn1.application-oa2-client.35fada61d0764e808b7212125fdd70c6"
  default[:amp][:amazon][:secret] = "46d6c48bfb2f0aa6207b3cfb1ed53a4c3fa5f1177f9b1c9f2c432087dc9afc6b"
  default[:amp][:twitter][:url] = "https://api.twitter.com/1.1/account/verify_credentials.json?include_entities=false&skip_status=true"
  default[:amp][:twitter][:client_id] = "Ueh0hhV1GzQY7a7nbNGw"
  default[:amp][:twitter][:secret] = "27HQsO9wZklHX0kNcGYrcJrTSysKrGuuf5jIVpzcxmI"
  default[:amp][:rabbit][:facebook][:host] = "iad-rabbitmq-vip-v200.ihr"
  default[:amp][:rabbit][:facebook][:port] = 5673
  default[:amp][:rabbit][:facebook][:username] = "amp-tomcat"
  default[:amp][:rabbit][:facebook][:password] = "tppw2011!"
  default[:amp][:rabbit][:host] = "iad-rabbitmq-vip-v200.ihr"
  default[:amp][:rabbit][:port] = 5673
  default[:amp][:rabbit][:consumer][:port] = 5672
  default[:amp][:rabbit][:username] = "amp-tomcat"
  default[:amp][:rabbit][:password] = "tppw2011!"
  default[:amp][:rabbit][:timeout] = 5000
  default[:amp][:cassandra][:hosts] = "iad-cass101-v240.ihr:9160,iad-cass102-v240.ihr:9160,iad-cass103-v240.ihr:9160,iad-cass104-v240.ihr:9160,iad-cass105-v240.ihr:9160"
  default[:amp][:cassandra][:cluster] = "cassandra1a"
  default[:amp][:cassandra][:keyspace] = "CCMP"
  default[:amp][:cassandra][:max_active] = 50
  default[:amp][:cassandra][:keep_alive] = "true"
  default[:amp][:cassandra][:max_wait_millis] = 5000
  default[:amp][:cassandra][:socket_timeout_millis] = 5000
  default[:amp][:dwh][:radiomodel_jdbc_url] = "jdbc:jtds:sqlserver://iad-dwh-db102-vip.ihrint.com:1433;DatabaseName=RadioModel"
  default[:amp][:statsd][:prefix] = "amp.live"
  default[:amp][:statsd][:host] = "iad-statsd101.ihr"
  default[:amp][:statsd][:port] = 8125
  default[:amp][:subscriptions][:host] = "localhost"
  default[:amp][:subscriptions][:port] = 8088
  default[:amp][:subscriptions][:timeout] = 5000
  default[:amp][:subscriptions][:pool_size] = 100
  default[:amp][:subscriptions][:max_pool_size] = 100
  default[:amp][:subscriptions][:queue_size] = 100
  default[:amp][:subscriptions][:max_wait_in_seconds] = 1
  default[:amp][:data_warehouse][:jdbc_url] = "jdbc:jtds:sqlserver://iheartdw.ihrint.com:1433;databaseName=IHRDWH"
  default[:amp][:data_warehouse][:host] = "iheartdw.ihrint.com"
  default[:amp][:data_warehouse][:port] = "1433"
  default[:amp][:data_warehouse][:batch_user_name] = "appBatch"
  default[:amp][:data_warehouse][:batch_user_password] = "i8piZZa4u"
  default[:amp][:authdb][:host] = "iad-auth101-v260.ihr"
  default[:amp][:authdb][:port] = "5432"
  default[:amp][:authdb][:user_name] = "appuser"
  default[:amp][:authdb][:password] = "2ph2Tr@ce"
  default[:amp][:new_relic_app_name] = "PRD-AMP"
when /^stage/
  default[:amp][:usr_mongo][:hosts] = "localhost:27017"
  default[:amp][:usr_mongo][:connections_per_host] = 300
  default[:amp][:usr_mongo][:connect_timeout] = 5000
  default[:amp][:usr_mongo][:socket_timeout] = 5000
  default[:amp][:usr_mongo][:maxWaitTime] = 5000
  default[:amp][:usr_mongo][:threads_allowed_to_block_for_connections_multiplier] = 5
  default[:amp][:fac_mongo][:hosts] = "iad-stg-mongo-fac101-v760.ihr:37017,iad-stg-mongo-fac102-v760.ihr:37017"
  default[:amp][:fac_mongo][:connections_per_host] = 300
  default[:amp][:fac_mongo][:connect_timeout] = 5000
  default[:amp][:fac_mongo][:socket_timeout] = 5000
  default[:amp][:fac_mongo][:maxWaitTime] = 5000
  default[:amp][:fac_mongo][:threads_allowed_to_block_for_connections_multiplier] = 5
  default[:amp][:streams][:cdn][:base_url] = "http://testcdn.thumbplay.com"
  default[:amp][:streams][:mixin][:base_url] = "http://talkstream.iheart.com"
  default[:amp][:streams][:prn][:base_url] = "http://talkstream.iheart.com"
  default[:amp][:image][:prefix] = "http://assets.iheart.com"
  default[:amp][:image][:amg_prefix] = "http://assets.iheart.com"
  default[:amp][:image][:talk_prefix] = "http://staging.content.iheart.com"
  default[:amp][:image][:prn_prefix] = "http://staging.content.iheart.com"
  default[:amp][:image][:smt_prefix] = "http://radioedit-stg1-origin.ihrdev.com/service/img/"
  default[:amp][:image][:genre_prefix] = "http://radioedit-stg1-origin.ihrdev.com/service/img/nop()/assets"
  default[:amp][:image][:genre_recs_prefix] = "http://radioedit-stg1-origin.ihrdev.com/service/img/nop()/assets"
  default[:amp][:search][:pool_size] = 50
  default[:amp][:search][:pool_max_size] = 50
  default[:amp][:search][:max_wait] = 10
  default[:amp][:search][:queue_max_size] = 1000
  default[:amp][:search][:attivio][:url] = "http://iad-stg-search-vip-v700.ihr:19001/query"
  default[:amp][:search][:attivio][:timeout] = 7000
  default[:amp][:search][:elastic][:url] = "http://iad-stg-search-vip-v700.ihr:9200/_query"
  default[:amp][:search][:elastic][:timeout] = 5000
  default[:amp][:memcache][:prefix] = "ihr_tomcat"
  default[:amp][:memcache][:pnp_prefix] = "pnp_station_id_"
  default[:amp][:memcache][:pnp_artist_prefix] = "pnp_artist_"
  default[:amp][:memcache][:pnp_station_prefix] = "pnp_station_"
  default[:amp][:memcache][:urls] = "http://iad-stg-membase101-v700.ihr:8091/pools,http://iad-stg-membase102-v700.ihr:8091/pools"
  default[:amp][:facebook][:timeout] = 15000
  default[:amp][:facebook][:max_connections] = 100
  default[:amp][:facebook][:url] = "https://graph.facebook.com/me?access_token=%s&fields=email,id"
  default[:amp][:facebook][:exchange_url] = "https://graph.facebook.com/oauth/access_token?grant_type=fb_exchange_token&client_id=214588375268980&client_secret=41e22a79bb59ebb4785d01d0366123e6&fb_exchange_token=%s"
  default[:amp][:google_plus][:url] = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=%s"
  default[:amp][:google_plus][:client_id] = "884160514548-7rrpob5uu4gn3bova3rvkn1ng16v4138.apps.googleusercontent.com"
  default[:amp][:amazon][:url] = "https://api.amazon.com/auth/o2/tokeninfo?access_token=%s"
  default[:amp][:amazon][:client_id] = "amzn1.application-oa2-client.35fada61d0764e808b7212125fdd70c6"
  default[:amp][:amazon][:secret] = "46d6c48bfb2f0aa6207b3cfb1ed53a4c3fa5f1177f9b1c9f2c432087dc9afc6b"
  default[:amp][:twitter][:url] = "https://api.twitter.com/1.1/account/verify_credentials.json?include_entities=false&skip_status=true"
  default[:amp][:twitter][:client_id] = "Ueh0hhV1GzQY7a7nbNGw"
  default[:amp][:twitter][:secret] = "27HQsO9wZklHX0kNcGYrcJrTSysKrGuuf5jIVpzcxmI"
  default[:amp][:rabbit][:facebook][:host] = "iad-stg-rabbitmq-vip-v700.ihr"
  default[:amp][:rabbit][:facebook][:port] = 5673
  default[:amp][:rabbit][:facebook][:username] = "amp-tomcat"
  default[:amp][:rabbit][:facebook][:password] = "tppw2011!"
  default[:amp][:rabbit][:host] = "iad-stg-rabbitmq-vip-v700.ihr"
  default[:amp][:rabbit][:port] = 5673
  default[:amp][:rabbit][:consumer][:port] = 5672
  default[:amp][:rabbit][:username] = "amp-tomcat"
  default[:amp][:rabbit][:password] = "tppw2011!"
  default[:amp][:rabbit][:timeout] = 5000
  default[:amp][:cassandra][:hosts] = "iad-stg-cass101-v760.ihr:9160,iad-stg-cass102-v760.ihr:9160,iad-stg-cass103-v760.ihr:9160,iad-stg-cass104-v760.ihr:9160"
  default[:amp][:cassandra][:cluster] = "cassandra1a"
  default[:amp][:cassandra][:keyspace] = "CCMP"
  default[:amp][:cassandra][:max_active] = 50
  default[:amp][:cassandra][:keep_alive] = "true"
  default[:amp][:cassandra][:max_wait_millis] = 5000
  default[:amp][:cassandra][:socket_timeout_millis] = 5000
  default[:amp][:dwh][:radiomodel_jdbc_url] = "jdbc:jtds:sqlserver://iad-dwh-db102-vip.ihrint.com:1433;DatabaseName=RadioModel"
  default[:amp][:statsd][:prefix] = "amp.stage"
  default[:amp][:statsd][:host] = "iad-stg-statsd101.ihr"
  default[:amp][:statsd][:port] = 8125
  default[:amp][:subscriptions][:host] = "localhost"
  default[:amp][:subscriptions][:port] = 8088
  default[:amp][:subscriptions][:timeout] = 5000
  default[:amp][:subscriptions][:pool_size] = 100
  default[:amp][:subscriptions][:max_pool_size] = 100
  default[:amp][:subscriptions][:queue_size] = 100
  default[:amp][:subscriptions][:max_wait_in_seconds] = 1
  default[:amp][:data_warehouse][:jdbc_url] = "jdbc:jtds:sqlserver://10.5.50.101;databaseName=IHRDWH"
  default[:amp][:data_warehouse][:host] = "10.5.50.101"
  default[:amp][:data_warehouse][:port] = "1433"
  default[:amp][:data_warehouse][:batch_user_name] = "appBatch"
  default[:amp][:data_warehouse][:batch_user_password] = "i8piZZa4u"
  default[:amp][:authdb][:host] = "iad-stg-auth101-v760.ihr"
  default[:amp][:authdb][:port] = "5432"
  default[:amp][:authdb][:user_name] = "appuser"
  default[:amp][:authdb][:password] = "Pk32T783q9"
  default[:amp][:new_relic_app_name] = "STG-AMP"
else
  default[:amp][:usr_mongo][:hosts] = "localhost:27017"
  default[:amp][:usr_mongo][:connections_per_host] = 300
  default[:amp][:usr_mongo][:connect_timeout] = 3000
  default[:amp][:usr_mongo][:socket_timeout] = 3000
  default[:amp][:usr_mongo][:maxWaitTime] = 3000
  default[:amp][:usr_mongo][:threads_allowed_to_block_for_connections_multiplier] = 5
  default[:amp][:fac_mongo][:hosts] = "iad-mongo-fac101-v240.ihr:37017,iad-mongo-fac102-v240.ihr:37017,iad-mongo-fac103-v240.ihr:37017,iad-mongo-fac104-v240.ihr:37017"
  default[:amp][:fac_mongo][:connections_per_host] = 300
  default[:amp][:fac_mongo][:connect_timeout] = 5000
  default[:amp][:fac_mongo][:socket_timeout] = 5000
  default[:amp][:fac_mongo][:maxWaitTime] = 5000
  default[:amp][:fac_mongo][:threads_allowed_to_block_for_connections_multiplier] = 5
  default[:amp][:streams][:cdn][:base_url] = "http://stream.iheart.com"
  default[:amp][:streams][:mixin][:base_url] = "http://talkstream.iheart.com"
  default[:amp][:streams][:prn][:base_url] = "http://media.iheart.com"
  default[:amp][:image][:prefix] = "http://assets.iheart.com"
  default[:amp][:image][:amg_prefix] = "http://assets.iheart.com"
  default[:amp][:image][:talk_prefix] = "http://content.iheart.com"
  default[:amp][:image][:prn_prefix] = "http://content.iheart.com"
  default[:amp][:image][:smt_prefix] = "http://radioedit.iheart.com/service/img/"
  default[:amp][:image][:genre_prefix] = "http://radioedit.iheart.com/service/img/nop()/assets"
  default[:amp][:image][:genre_recs_prefix] = "http://radioedit.iheart.com/service/img/nop()/assets"
  default[:amp][:search][:pool_size] = 50
  default[:amp][:search][:pool_max_size] = 50
  default[:amp][:search][:max_wait] = 10
  default[:amp][:search][:queue_max_size] = 1000
  default[:amp][:search][:attivio][:url] = "http://iad-search-vip-v200.ihr:19001/query"
  default[:amp][:search][:attivio][:timeout] = 7000
  default[:amp][:search][:elastic][:url] = "http://iad-search-vip-v200.ihr:9200/_query"
  default[:amp][:search][:elastic][:timeout] = 5000
  default[:amp][:memcache][:prefix] = "ihr_tomcat"
  default[:amp][:memcache][:pnp_prefix] = "pnp_station_id_"
  default[:amp][:memcache][:pnp_artist_prefix] = "pnp_artist_"
  default[:amp][:memcache][:pnp_station_prefix] = "pnp_station_"
  default[:amp][:memcache][:urls] = "http://iad-amp-cache101-v200.ihr:8091/pools,http://iad-amp-cache102-v200.ihr:8091/pools,http://iad-amp-cache103-v200.ihr:8091/pools,http://iad-amp-cache104-v200.ihr:8091/pools"
  default[:amp][:facebook][:timeout] = 15000
  default[:amp][:facebook][:max_connections] = 150
  default[:amp][:facebook][:url] = "https://graph.facebook.com/me?access_token=%s&fields=email,id"
  default[:amp][:facebook][:exchange_url] = "https://graph.facebook.com/oauth/access_token?grant_type=fb_exchange_token&client_id=121897277851831&client_secret=9875e783fc3b1c8cfc839acf725c49bd&fb_exchange_token=%s"
  default[:amp][:google_plus][:url] = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=%s"
  default[:amp][:google_plus][:client_id] = "884160514548-4917aophkpafpbgh8r1lndhc3f128ouf.apps.googleusercontent.com"
  default[:amp][:google_plus][:secret] = ""
  default[:amp][:amazon][:url] = "https://api.amazon.com/auth/o2/tokeninfo?access_token=%s"
  default[:amp][:amazon][:client_id] = "amzn1.application-oa2-client.35fada61d0764e808b7212125fdd70c6"
  default[:amp][:amazon][:secret] = "46d6c48bfb2f0aa6207b3cfb1ed53a4c3fa5f1177f9b1c9f2c432087dc9afc6b"
  default[:amp][:twitter][:url] = "https://api.twitter.com/1.1/account/verify_credentials.json?include_entities=false&skip_status=true"
  default[:amp][:twitter][:client_id] = "Ueh0hhV1GzQY7a7nbNGw"
  default[:amp][:twitter][:secret] = "27HQsO9wZklHX0kNcGYrcJrTSysKrGuuf5jIVpzcxmI"
  default[:amp][:rabbit][:facebook][:host] = "iad-rabbitmq-vip-v200.ihr"
  default[:amp][:rabbit][:facebook][:port] = 5673
  default[:amp][:rabbit][:facebook][:username] = "amp-tomcat"
  default[:amp][:rabbit][:facebook][:password] = "tppw2011!"
  default[:amp][:rabbit][:host] = "iad-rabbitmq-vip-v200.ihr"
  default[:amp][:rabbit][:port] = 5673
  default[:amp][:rabbit][:consumer][:port] = 5672
  default[:amp][:rabbit][:username] = "amp-tomcat"
  default[:amp][:rabbit][:password] = "tppw2011!"
  default[:amp][:rabbit][:timeout] = 5000
  default[:amp][:cassandra][:hosts] = "iad-cass101-v240.ihr:9160,iad-cass102-v240.ihr:9160,iad-cass103-v240.ihr:9160,iad-cass104-v240.ihr:9160,iad-cass105-v240.ihr:9160"
  default[:amp][:cassandra][:cluster] = "cassandra1a"
  default[:amp][:cassandra][:keyspace] = "CCMP"
  default[:amp][:cassandra][:max_active] = 50
  default[:amp][:cassandra][:keep_alive] = "true"
  default[:amp][:cassandra][:max_wait_millis] = 5000
  default[:amp][:cassandra][:socket_timeout_millis] = 5000
  default[:amp][:statsd][:prefix] = "amp.live"
  default[:amp][:statsd][:host] = "iad-statsd101.ihr"
  default[:amp][:statsd][:port] = 8125
  default[:amp][:subscriptions][:host] = "localhost"
  default[:amp][:subscriptions][:port] = 8088
  default[:amp][:subscriptions][:timeout] = 5000
  default[:amp][:subscriptions][:pool_size] = 100
  default[:amp][:subscriptions][:max_pool_size] = 100
  default[:amp][:subscriptions][:queue_size] = 100
  default[:amp][:data_warehouse][:jdbc_url] = "jdbc:jtds:sqlserver://iheartdw.ihrint.com:1433;databaseName=IHRDWH"
  default[:amp][:data_warehouse][:host] = "iheartdw.ihrint.com"
  default[:amp][:data_warehouse][:port] = "1433"
  default[:amp][:data_warehouse][:batch_user_name] = "appBatch"
  default[:amp][:data_warehouse][:batch_user_password] = "i8piZZa4u"
  default[:amp][:authdb][:host] = "iad-auth101-v260.ihr"
  default[:amp][:authdb][:port] = "5432"
  default[:amp][:authdb][:user_name] = "appuser"
  default[:amp][:authdb][:password] = "2ph2Tr@ce"
  default[:amp][:new_relic_app_name] = "DEFAULT-AMP"
end
# GP EDIT 8/16/13 Included a list of people to notify when endpoints show alert levels of 500s 
# Used in ./templates/default/amp-extended-log-chk.sh.erb
default[:amp][:logging][:notify_list] = %w{ jeremybraff@clearchannel.com kengilmer@clearchannel.com LaurentVauthrin@clearchannel.com }
