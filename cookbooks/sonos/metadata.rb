name             'sonos'
maintainer       'iHeartRadio'
maintainer_email 'none@none.com'
license          'All rights reserved'
description      'Installs/Configures sonos'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '1.0.1'

%w{ centos debian }.each do |os|
  supports os
end

%w{ users application_python nagios mysql }.each do |cb|
  depends cb
end
