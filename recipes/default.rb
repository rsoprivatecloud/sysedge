if node.attribute?('sysedge') then
  puts "Sysedge Already Exists!!! Chescking if it needs updates"
  if !node['sysedge']['sysdescr']
    node.set['sysedge']['sysdescr'] = node['hostname']
  end
  if !node['sysedge']['syslocation']
    node.set['sysedge']['syslocation'] = 'cdc'
    node.set['sysedge']['trapCommunityDest'] = "10.4.63.210"
  else
    case node['sysedge']['syslocation']
      when "cdc"
        node.set['sysedge']['trapCommunityDest'] = "10.4.63.210"
      when "dfw"
        node.set['sysedge']['trapCommunityDest'] = "72.3.141.208"
      when "iad"
        node.set['sysedge']['trapCommunityDest'] = "173.203.179.56"
      when "ord"
        node.set['sysedge']['trapCommunityDest'] = "184.106.13.160"
      when "lon"
        node.set['sysedge']['trapCommunityDest'] = "83.138.176.26"
      when "hkg"
        node.set['sysedge']['trapCommunityDest'] = "180.150.153.168"
    end     
  end
  if !node['sysedge']['community']
    node.set['sysedge']['community'] = (0...8).map { (65 + rand(26)).chr }.join
  end
  if !node['sysedge']['communityType']
    node.set['sysedge']['communityType'] = "read-write"
  end
  if !node['sysedge']['trapCommunity']
    node.set['sysedge']['trapCommunity'] = "public"
  end
  if !node['sysedge']['trapSource']
    node.set['sysedge']['trapSource'] = node['ipaddress']
  end
else
  puts "Creating Sysedge:SysDescr"
  node.set['sysedge']['sysdescr'] = node['hostname']
  puts "Creating Sysedge:syslocation"
  node.set['sysedge']['syslocation'] = "cdc"
  puts "Creating Sysedge:community"
  node.set['sysedge']['community'] = (0...8).map { (65 + rand(26)).chr }.join
  puts "Creating Sysedge:communityType"
  node.set['sysedge']['communityType'] = "read-write"
  puts "Creating Sysedge:trapCommunity"
  node.set['sysedge']['trapCommunity'] = "public"
  puts "Creating Sysedge:trapCommunityDest"
  node.set['sysedge']['trapCommunityDest'] = "10.4.63.210"
  puts "Creating Sysedge:trapSource"
  node.set['sysedge']['trapSource'] = node['ipaddress']
end
  
if node.attribute?('sysedge.cf') then
  puts 'Sysedge.cf Already Exists!!!'
else
  puts 'Creating Sysedge.cf'
  sysedge = Array.[]
  rec = node[:recipes]
  puts 'Installing monitors'
  rec.each { |r| case r
    when "horizon::server"
      puts "horizon::server"
      sysedge << node['sysedge']['monitors']['apache2']
    when "mysql-openstack::server"
      puts "mysql-openstack::server"
      sysedge << node['sysedge']['monitors']['mysqld']
    when "nova-network::quantum-dhcp-agent"
      puts "nova-network::quantum-dhcp-agent"
      sysedge << node['sysedge']['monitors']['quantum']['dhcp']
    when "nova-network::quantum-metadata-agent"
      puts "nova-network::quantum-metadata-agent"
      sysedge << node['sysedge']['monitors']['quantum']['metadata-agent']
      sysedge << node['sysedge']['monitors']['quantum']['metadata-proxy']
    when "nova-network::quantum-plugin"
      puts "nova-network::quantum-plugin"
      sysedge << node['sysedge']['monitors']['quantum']['ovs-agent']
    when "nova-network::nova-controller"
      puts "nova-network::nova-controller"
      sysedge << node['sysedge']['monitors']['quantum']['server']
    when "memcached-openstack::default"
      puts "memcached-openstack::default"
      sysedge << node['sysedge']['monitors']['memcached']
    when "cinder::cinder-api"
      puts "cinder::cinder-api"
      sysedge << node['sysedge']['monitors']['cinder']['api']
    when "cinder::cinder-scheduler"
      puts "cinder::cinder-scheduler"
      sysedge << node['sysedge']['monitors']['cinder']['scheduler']
    when "glance::api"
      puts "glance::api"
      sysedge << node['sysedge']['monitors']['glance']['api']
    when "glance::registry"
      puts "glance::registry"
      sysedge << node['sysedge']['monitors']['glance']['registry']
    when "keystone::setup"
      puts "keystone::setup"
      sysedge << node['sysedge']['monitors']['keystone']
    when "nova::api-os-compute"
      puts "nova::api-os-compute"
      sysedge << node['sysedge']['monitors']['nova']['api']
    when "nova::nova-cert"
      puts "nova::nova-cert"
      sysedge << node['sysedge']['monitors']['nova']['cert']
    when "nova::nova-conductor"
      puts "nova::nova-conductor"
      sysedge << node['sysedge']['monitors']['nova']['conductor']
    when "nova::vncproxy"
      puts "nova::vncproxy"
      sysedge << node['sysedge']['monitors']['nova']['novncproxy']
      sysedge << node['sysedge']['monitors']['nova']['consoleauth']
    when "nova::scheduler"
      puts "nova::scheduler"
      sysedge << node['sysedge']['monitors']['nova']['scheduler']
    when "nova-network::nova-compute"
      puts "nova-network::nova-compute"
      sysedge << node['sysedge']['monitors']['nova']['nova-network']
      sysedge << node['sysedge']['monitors']['nova']['nova-api-metadata']
    when "nova::compute"
      puts "nova::compute"
      sysedge << node['sysedge']['monitors']['nova']['compute']
      sysedge << node['sysedge']['monitors']['libvertd']
    end
  }
  sysmon = node['sysedge']['sys-mon']
  sysmon.each { |r| 
    sysedge << r
  }
  sysedge = sysedge.compact
  sysedge.each_with_index { |s,i| 
    if !s.nil?
      sysedge[i] = s.sub(/edge-count/,(580000+i).to_s)
    end
  }
  node.set['sysedge.cf'] = sysedge
end

tmp = Chef::Config[:file_cache_path]
case node["platform"]
  when "debian", "ubuntu"
    package "ia32-libs"
    package "libglib2.0-0:i386"
    package "libdbus-glib-1-2:i386"
    src_url = node['sysedge']['debian']['deb_src_url']
    sysedge_installer = tmp + "sysedge.bz2"
    tarit = "tar -jxvf "
  
    cookbook_file "sysedge.conf" do
      backup false
      path "/etc/init/sysedge.conf"
      source "sysedge.conf.erb"
      owner "root"
      group "root"
      mode  "644"
      action :create_if_missing
    end

    service "sysedge" do
      action :nothing
      start_command "start sysedge"
      stop_command "stop sysedge"
      restart_command "stop sysedge && start sysedge"
      status_command "status sysedge"
      supports :status => true, :start => true, :stop => true, :restart => true
    end

  when "redhat", "centos", "fedora"
    yum_package "glibc.i686" do
      action :install
    end

    service "sysedge" do
      action :nothing
      service_name "sysedge"
      start_command "service sysedge start"
      stop_command "service sysedge stop"
      restart_command "service sysedge restart"
      status_command "status sysedge"
      supports :status => true, :start => true, :stop => true, :restart => true
    end

    src_url = node['sysedge']['redhat']['src_url']
    sysedge_installer = tmp + "/sysedge.tgz"
    tarit = "tar -xvf "
end

unless File.exists?(node['sysedge']['dataDirectory'] + "/port1691/sysedge.cf")
  remote_file sysedge_installer do
    source src_url
    mode "0644"
  end

  execute "extract-sysedge" do
      cwd tmp
      command tarit + sysedge_installer
  end

  case node["platform"]
    when "debian", "ubuntu"

      execute "move-sysedge" do
        user "root"
        cwd tmp
        command "mv ./CA /opt/"
      end

    when "redhat", "centos", "fedora"

      execute "check-tmp" do
        cwd tmp
        command "mount -l | grep -E '\s/tmp\s'"
        returns [1]
      end

      execute "tmp-mount-exec" do
        cwd tmp
        command "mount -o remount,exec /tmp"
        only_if "exectue[check-tmp]"
      end

      execute "install-sysedge" do
        cwd tmp + "/Linux_x86/Agent/SysMan/CA_SystemEDGE_Core/"
        command "./ca-setup.sh /e " + tmp + "/sysedge_install.out /t EULA_ACCEPTED=1 CASE_SNMP_PORT=1691 CASE_INSTALL_DOCS=0 > /dev/null 2>&1"
      end

      execute "tmp-mount-noexec" do
        cwd tmp
        command "mount -o remount,noexec /tmp"
        only_if "exectue[check-tmp]"
      end
    end

  execute "rm -rf /opt/CA/SystemEDGE/config/sysedge.cf" do
    user "root"
  end

  execute "ln -s /opt/CA/SystemEDGE/config/port1691/sysedge.cf /opt/CA/SystemEDGE/config/sysedge.cf" do
    user "root"
  end

  execute "rm -rf /etc/sysedge.cf" do
    user "root"
  end

  execute "ln -s /opt/CA/SystemEDGE/config/port1691/sysedge.cf /etc/sysedge.cf" do
    user "root"
  end
end

  template "/opt/CA/SystemEDGE/config/port1691/sysedge.cf" do
    source "sysedge.cf.erb"
    owner "root"
    group "root"
    mode  "644"
    variables(
        :trapCommunity => node['sysedge']['trapCommunity'],
        :trapSource => node['sysedge']['trapSource'],
        :community => node['sysedge']['community'],
        :sysdescr => node['sysedge']['sysdescr'],
        :syscontact => node['sysedge']['syscontact'],
        :syslocation => node['sysedge']['syslocation'],
        :dataDirectory => node['sysedge']['dataDirectory'],
        :port => node['sysedge']['port'],
        :trapCommunityDest => node['sysedge']['trapCommunityDest'],
	:monitors => node['sysedge.cf']
    )
    notifies :restart, resources(:service => "sysedge"), :immediately
  end
