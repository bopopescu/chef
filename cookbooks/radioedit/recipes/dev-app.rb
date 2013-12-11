#
# Cookbook Name:: radioedit
# Recipe:: dev-app
#
# Copyright 2013, iHeartRadio
#
# All rights reserved - Do Not Redistribute
# Installs requirements for a dev version of the radioedit app server
#

include_recipe "yum::epel"

# make all required directories
node[:radioedit][:dev][:req_dirs].each do |d|
  directory d do
    owner "ihr-deployer"
    group "ihr-deployer"
    action :create
  end
end

node[:radioedit][:dev][:packages].each do |p|
  yum_package p do
    action [ :install, :upgrade ]
  end
end

template "#{node[:radioedit][:dev][:path]}/shared/settings.json" do
  source "dev-settings.json.erb"
  owner "ihr-deployer"
  group "ihr-deployer"
end

link "#{node[:radioedit][:dev][:path]}/settings.json" do
  to "#{node[:radioedit][:dev][:path]}/shared/settings.json"
  action :create
  owner "ihr-deployer"
  group "ihr-deployer"
  not_if "test -L #{node[:radioedit][:dev][:path]}/shared/settings.json"
end

python_virtualenv "#{node[:radioedit][:dev][:venv_path]}" do
  interpreter "python27"
  owner "ihr-deployer"
  group "ihr-deployer"
  action :create
end

application "radioedit-core" do
  repository "#{node[:radioedit][:dev][:repo]}"
  revision "#{node[:radioedit][:dev][:intbranch]}"
  path "#{node[:radioedit][:dev][:path]}"
  owner "ihr-deployer"
  group "ihr-deployer"
  enable_submodules true

  gunicorn do
    app_module "#{node[:radioedit][:dev][:module]}"
    port node[:radioedit][:dev][:port]
    host node[:radioedit][:dev][:host]
    workers node[:radioedit][:dev][:num_workers]
    pidfile node[:radioedit][:dev][:pid_file]
    virtualenv "#{node[:radioedit][:dev][:venv_path]}"
    stdout_logfile "#{node[:radioedit][:dev][:out_log]}"
    stderr_logfile "#{node[:radioedit][:dev][:err_log]}"
    packages node[:radioedit][:dev][:pips]
    loglevel "#{node[:radioedit][:dev][:log_level]}"
    autostart true
    interpreter "python27"
    environment {"ENVIRONMENT" => node[:radioedit][:dev][:env],
                 "APP_ENV" => node[:radioedit][:dev][:env]}
  end
end

template "#{node[:radioedit][:dev][:utildir]}/radioedit.conf" do
  source "dev-nginx.conf.erb"
  owner "root"
  group "root"
  mode 0666
end
