# -*- mode: ruby -*-
# vi: set ft=ruby :

N=3

Vagrant.configure("2") do |config|


  groups = {
           "gluster" => [],
           "workstation" => ["ws"]
           }

  (1..N).each do |id|
    groups["gluster"].push("gluster-#{id}")
  end



  config.ssh.forward_agent = false

  config.vm.define "ws", primary: true do |nd|
    nd.vm.box = "rhel7.4.1-stage"
    nd.vm.synced_folder "./work", "/home/vagrant/work", type: "nfs", nfs_version: 4, nfs_udp: false
    nd.vm.hostname = "ws.lab"
    nd.vm.provision :ansible do |ansible|
      ansible.limit = "all"
      ansible.playbook = "gluster.yml"
      ansible.groups = groups
    end
  end




  (1..N).each do |id|
    config.vm.define "gluster-#{id}"   do |nd|
      nd.vm.box = "rhel7.4.1-stage"
      nd.vm.provider :libvirt do |lv|
        lv.storage :file, :size => '60G', :type => 'qcow2'
        lv.storage :file, :size => '60G', :type => 'qcow2'
      end
      nd.vm.hostname = "gluster-#{id}.lab"
      nd.vm.network :private_network,
        libvirt__network_name: "gluster_backend",
        libvirt__forward_mode: "none"
      nd.vm.synced_folder  ".", "/vagrant", disabled: true
      if id == N
        nd.vm.provision :ansible do |ansible|
          ansible.limit = "all"
          ansible.playbook = "gluster.yml"
          ansible.groups = groups
        end
      end
    end
  end
  
end
