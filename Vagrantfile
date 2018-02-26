# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|


  groups = {
           "workstation" => ["ws"]
           }

  config.ssh.forward_agent = false

  config.vm.define "ws", primary: true do |nd|
    nd.vm.box = "rhel-7.3-stage"
    nd.vm.synced_folder "./work", "/home/vagrant/work", type: "nfs", nfs_version: 4, nfs_udp: false
    nd.vm.hostname = "ws.lab"
    nd.vm.provision :ansible do |ansible|
      ansible.limit = "all"
      ansible.playbook = "prepare_ws.yml"
      ansible.groups = groups
    end
  end
  
end
