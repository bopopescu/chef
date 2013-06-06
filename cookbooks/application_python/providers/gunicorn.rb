#
# Author:: Noah Kantrowitz <noah@opscode.com>
# Cookbook Name:: application_python
# Provider:: gunicorn
#
# Copyright:: 2011, Opscode, Inc <legal@opscode.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include Chef::Mixin::LanguageIncludeRecipe

action :before_compile do

  include_recipe "supervisor"

  django_resource = new_resource.application.sub_resources.select{|res| res.type == :django}.first
  gunicorn_install "gunicorn-#{new_resource.application.name}" do
    virtualenv django_resource ? django_resource.virtualenv : nil
    interpreter django_resource.interpreter
  end

  if !new_resource.restart_command
    new_resource.restart_command do
      run_context.resource_collection.find(:supervisor_service => new_resource.application.name).run_action(:restart)
    end
  end

  raise "You must specify an application module to load" unless new_resource.app_module

end

action :before_deploy do

  new_resource = @new_resource

  gunicorn_config "#{new_resource.application.path}/shared/gunicorn_config.py" do
    action :create
    template new_resource.settings_template || 'gunicorn.py.erb'
    cookbook new_resource.settings_template ? new_resource.cookbook_name : 'gunicorn'
    listen "#{new_resource.host}:#{new_resource.port}"
    backlog new_resource.backlog
    worker_processes new_resource.workers
    worker_class new_resource.worker_class.to_s
    #worker_connections
    worker_max_requests new_resource.max_requests
    worker_timeout new_resource.timeout
    worker_keepalive new_resource.keepalive
    #debug
    #trace
    preload_app new_resource.preload_app
    #daemon
    pid new_resource.pidfile
    #umask
    #logfile
    #loglevel
    #proc_name
    stderr_logfile new_resource.stderr_logfile
    stdout_logfile new_resource.stdout_logfile
  end

  supervisor_service new_resource.application.name do
    action :enable
    if new_resource.app_module == :django
      django_resource = new_resource.application.sub_resources.select{|res| res.type == :django}.first
      raise "No Django deployment resource found" unless django_resource
      if new_resource.command.include? "wsgi"
        base_command = "#{::File.join(django_resource.virtualenv, "bin", "gunicorn")} #{new_resource.command}"
      else
        base_command = "#{::File.join(django_resource.virtualenv, "bin", "python")} manage.py run_gunicorn"
      end
    else
      base_command = "gunicorn #{new_resource.app_module}"
    end
    command "#{base_command} -c #{new_resource.application.path}/shared/gunicorn_config.py"
    directory ::File.join(new_resource.path, "current")
    autostart new_resource.autostart
    user new_resource.owner
  end

end

action :before_migrate do
end

action :before_symlink do
end

action :before_restart do
end

action :after_restart do
end
