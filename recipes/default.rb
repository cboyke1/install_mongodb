case node[:platform]
  when 'centos'
		file '/etc/yum.repos.d/mongodb-org-3.4.repo' do
			content '
[mongodb-org-3.4]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.4.asc
		'
		end
  when 'ubuntu'
      #getting permission denied
      #sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6

    file '/etc/apt/sources.list.d/mongodb-org-3.4.list' do
      content 'deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse'
    end
    apt_update 'update' do
      action :update
    end
end

package 'mongodb-org' do
  case node[:platform]
  when 'ubuntu'
    options '--allow-unauthenticated'
  end
	action :install
end

service 'mongod' do
  action [ :enable, :start ]
end
