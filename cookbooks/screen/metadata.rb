maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs screen"
version           "1.0.0"

%w{ redhat centos fedora ubuntu debian }.each do |os|
  supports os
end
