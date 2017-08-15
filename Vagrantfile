# -*- mode: ruby -*-
# vi: set ft=ruby :

N = 2
M = 3
I = 1

Vagrant.configure("2") do |config|


  groups = {
           "workstation" => ["ws"],
           "masters" => ["osmaster"],
           "nodes" => [],
           "storage" => [],
           "infra" => [],
           }

  (1..N).each do |id|
    groups["nodes"].push("node-#{id}")
  end
  (1..M).each do |id|
    groups["storage"].push("storage-#{id}")
  end
  (1..I).each do |id|
    groups["infra"].push("infra-#{id}")
  end

  config.landrush.enabled = true
  config.landrush.tld = 'lab'
  config.landrush.upstream  '127.0.0.1'
  config.landrush.host 'apps.lab', 'infra-1.lab'

  config.ssh.forward_agent = false

  config.vm.define "ws", primary: true do |nd|
    nd.vm.box = "rhel-7.4-stage"
    nd.vm.synced_folder "./work", "/home/vagrant/work", type: "nfs", nfs_version: 4, nfs_udp: false
    nd.vm.hostname = "ws.lab"
    nd.vm.provision :ansible do |ansible|
      ansible.limit = "all"
      ansible.playbook = "prepare_ocp.yml"
      ansible.groups = groups
    end
  end

  config.vm.define "osmaster" do |nd|
    nd.vm.box = "rhel-7.4-stage"
    nd.vm.hostname = "master.lab"
    nd.vm.synced_folder  ".", "/vagrant", disabled: true 
  end
  
  (1..N).each do |i|
    config.vm.define "node-#{i}" do |nd|
      nd.vm.box = "rhel-7.4-stage"
      nd.vm.hostname = "node-#{i}.lab"
      nd.vm.synced_folder  ".", "/vagrant", disabled: true 
    end
  end
  (1..M).each do |i|
    config.vm.define "storage-#{i}" do |nd|
      nd.vm.box = "rhel-7.4-stage"
      nd.vm.hostname = "storage-#{i}.lab"
      nd.vm.synced_folder  ".", "/vagrant", disabled: true 
      nd.vm.provider :libvirt do |lv|
        lv.storage :file, :size => '60G', :type => 'qcow2'
        lv.storage :file, :size => '60G', :type => 'qcow2'
      end
    end
  end
  (1..I).each do |i|
    config.vm.define "infra-#{i}" do |nd|
      nd.vm.box = "rhel-7.4-stage"
      nd.vm.hostname = "infra-#{i}.lab"
      nd.vm.synced_folder  ".", "/vagrant", disabled: true 
    end
  end
  
end
