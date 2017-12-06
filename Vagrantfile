# -*- mode: ruby -*-
# vi: set ft=ruby :


# Number of Nodes to Create
Nodes = 10

# The box you want to use for the undercloud
UndercloudBox = "rhel-7.4-stage"

# The default libvirt pool resides in /var/lib/libvirt
# Since on standard fedora boxes the root filesystem is usually rather limited
# and the disk mostly assigned to /home you may want to create a separate pool
# for libvirt in your homedir. If you do this you can enter its name here.
#DefaultPool = "default"


Vagrant.configure("2") do |config|

# Some usefuil defaults....

  config.vm.provider "libvirt" do |libvirt|
    libvirt.driver = "kvm"
    libvirt.uri = "qemu:///system"
    libvirt.memory = 6000
    libvirt.cpus = 1
    libvirt.cpu_mode = "host-passthrough"
    libvirt.storage_pool_name = DefaultPool
  end
  config.vm.synced_folder ".", "/vagrant", type: "nfs", nfs_udp: false

  config.vm.define "undercloud", primary: true do |uc|
    uc.vm.box = UndercloudBox
    uc.vm.hostname = "undercloud.lab"
    uc.vm.provider "libvirt" do |lv|
      lv.memory = "9000"
    end
    uc.vm.network :private_network,
      auto_config: false,
      ip: '192.0.2.1',
      libvirt__network_name: "ospd_provision",
      libvirt__dhcp_enabled: false,
      libvirt__forward_mode: "none",
      libvirt__host_ip: '192.0.2.254'
    uc.vm.synced_folder ".", "/vagrant", type: "nfs"
    uc.vm.provision "ansible" do |ansible|
      ansible.playbook = "undercloud.yml"
    end
  end

  (1..Nodes).each do |i|
    config.vm.define "node-#{i}", autostart: false do |node|
      node.vm.hostname = "node-#{i}"
      node.vm.provider :libvirt do |lv|
        lv.storage :file, :size => '41G', :type => 'qcow2'
#        lv.boot 'network'
#        lv.boot 'hd'
        lv.management_network_name = 'ospd_provision'
        lv.management_network_address = '192.0.2.0/24'
        lv.nested = true
      end
      vbmcport = 60000 + i
      node.trigger.after :up do
        run  "vbmc add osp11_node-#{i} --address 192.168.121.1 --port #{vbmcport}"
        run  "vbmc start osp11_node-#{i}"
      end
      node.trigger.after :destroy do
        run  "vbmc delete  osp11_node-#{i}"
      end
    end
  end

  (1..Nodes).each do |i|
    config.vm.define "store-#{i}", autostart: false  do |node|
      node.vm.hostname = "store-#{i}"
      node.vm.provider :libvirt do |lv|
        lv.storage :file, :size => '41G', :type => 'qcow2'
        lv.storage :file, :size => '60G', :type => 'qcow2'
        lv.storage :file, :size => '60G', :type => 'qcow2'
        lv.storage :file, :size => '60G', :type => 'qcow2'
        lv.storage :file, :size => '60G', :type => 'qcow2'
#        lv.boot 'network'
#        lv.boot 'hd'
        lv.management_network_name = 'ospd_provision'
        lv.management_network_address = '192.0.2.0/24'
      end
      vbmcport = 61000 + i
      node.trigger.after :up do
        run  "vbmc add osp11_store-#{i} --address 192.168.121.1 --port #{vbmcport}"
        run  "vbmc start osp11_store-#{i}"
      end
      node.trigger.after :destroy do
        run  "vbmc delete  osp11_store-#{i}"
      end
    end
  end


end
