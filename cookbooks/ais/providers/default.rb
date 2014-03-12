# LWRP for deploying AIS
# Mark Rechler 2014-03-04: Initial creation

# Enable whyrun in case anyone wants to do a dry-run
def whyrun_supported?
  true
end

# Deploy block for AIS, pulls all required files and starts/restarts the service
action :deploy do
  unless node.tags.include?('ais-deployed')
    package 'java-1.7.0-openjdk'
    package 'ais' do
      version new_resource.version 
    end
    user_ulimit new_resource.owner do
      filehandle_limit 1048576
    end
    service 'ais'
    %w{ user.config etc/ais.instance }.each do |config|
      template "#{new_resource.path}/#{config}" do
        owner new_resource.owner
        group new_resource.group
        source "#{config}.erb"
        variables ({
          :ais_path => new_resource.path,
          :ais_user => 'root'
        })
      end
    end
    remote_file "#{new_resource.path}/config.xml" do
      source "http://#{new_resource.config_site}/#{new_resource.cluster_name}/#{new_resource.ais_type}/config.xml"
      owner new_resource.owner
      group new_resource.group
      action :create_if_missing
      notifies :restart, 'service[ais]', :immediately
    end
    node.tags << 'ais-deployed'
  end
  new_resource.updated_by_last_action(true)
end

# Removes AIS and cleans up anything left behind
action :delete do
  package 'ais' do
    action :remove
  end
  directory new_resource.path do
    recursive true
    action :delete
  end
  new_resource.updated_by_last_action(true)
end
