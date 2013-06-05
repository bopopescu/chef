name             'sonos'
maintainer       'iHeartRadio'
maintainer_email 'jake.plimack@gmail.com'
license          'All rights reserved'
description      'Installs/Configures sonos'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w{ centos debian }.each do |os|
  supports os
end

%w{ users application_python mysql nagios }.each do |cb|
  depends cb
end
