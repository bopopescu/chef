# Install production rabbit setup

include_recipe "rabbitmq::mgmt_console"

rabbitmq_vhost "/amp" do
  action :add
end

#Setup all our users/passwords
Chef::EncryptedDataBagItem.load("rabbitmq", "passwords").each do |k,v|
  next if k == "id"
  rabbitmq_user k do
    password v
    action :add
  end
  rabbitmq_user k do
    permissions "\".*\" \".*\" \".*\""
    action :set_permissions
  end
end

rabbitmq_user "guest" do
  action :delete
end
