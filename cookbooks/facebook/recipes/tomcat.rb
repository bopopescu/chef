node.set[:java][:oracle][:accept_oracle_download_terms] = true
node.save
include_recipe "java"
include_recipe "tomcat7"

remote_file "#{node[:tomcat7][:webapp_dir]}/fbtomcat.war" do
  Chef::Log.info("Installing fbgraph.war from #{node[:fbgraph][:url]}")
  source node[:fbgraph][:url]
  owner node[:tomcat7][:user]
  group node[:tomcat7][:group]
  action :create_if_missing
  only_if "test -d #{node[:tomcat7][:webapp_dir]}"
  notifies :restart, "service[tomcat]", :immediately
end

directory "/var/run/tomcat" do
  owner node[:tomcat7][:user]
  group node[:tomcat7][:group]
  recursive true
end

service "tomcat" do
  supports :start => true, :stop => true, :status => true
  action [:enable, :start]
end
