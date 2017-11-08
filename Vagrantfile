# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|


  groups = {
           "workstation" => ["docker"]
           }


  config.landrush.enabled = true
  config.landrush.tld = 'lab'
  config.landrush.upstream  '127.0.0.1'

  config.ssh.forward_agent = false

  config.vm.define "docker", primary: true do |nd|
    nd.vm.box = "rhel-7.4-stage"
    nd.vm.synced_folder "./work", "/home/vagrant/work", type: "nfs", nfs_version: 4, nfs_udp: false
    nd.vm.hostname = "docker.lab"
    nd.vm.provision :ansible do |ansible|
      ansible.limit = "all"
      ansible.playbook = "prepare_ws.yml"
      ansible.groups = groups
    end
  end
  
end
