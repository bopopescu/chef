results = search(:node, "recipes:attivio\\:\\:clustered AND chef_environment:#{node.chef_environment}")

searchers = Array.new
results.sort.each do |r|
  searchers << "#{r[:hostname]}-v700"
end

template "/etc/init.d/attivio31-zookeeper" do
  source "attivio31-zookeeper.erb"
  owner "root"
  group "root"
  mode "0755"
  variables({
              :attivio => node[:attivio],
              :nodename => "#{node[:hostname]}-v700",
              :zookeeper_port => node[:attivio][:zookeeper_port],
              :searchers => searchers,
              :attivio_env => node.chef_environment,
              :zookeeper => node[:attivio][:zookeeper]
            })
  notifies :restart, "service[attivio31-zookeeper]"
end

service "attivio31-zookeeper" do
  provider Chef::Provider::Service::Redhat
  supports :status =>true, :start => true, :stop => true, :restart => true, :reload => true
  action [:enable, :start]
end
