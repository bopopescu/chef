name             'elasticsearch'
maintainer       'iHeartRadio'
maintainer_email 'none@none.com'
license          'All rights reserved'
description      'Installs/Configures elasticsearch'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w{ users nagios }.each do |dep|
  depends dep
end

%w{ centos debian }.each do |os|
  supports os
end
