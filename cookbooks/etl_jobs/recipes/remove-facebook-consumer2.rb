
directory "/home/amqp-consumer/facebook-consumer-2" do
  action :delete
  recursive true
end
directory "/data/log/facebook-consumer-2" do
  action :delete
  recursive true
end
directory "/var/run/facebook-consumer-2" do
  action :delete
  recursive true
end
file "/home/amqp-consumer/facebook-consumer-2/facebook_consumer.jar" do
  action :delete 
end
file "/home/amqp-consumer/facebook-consumer-2/env.properties" do
  action :delete
end
file "/home/amqp-consumer/facebook-consumer-2/log4j.xml" do
  action :delete
end
file "/etc/init.d/facebook-consumer-2" do
  action :delete
end
