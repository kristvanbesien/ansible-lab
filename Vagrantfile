# -*- mode: ruby -*-
# vi: set ft=ruby :

N=3

Vagrant.configure("2") do |config|


  groups = {
           "gluster" => []
           }

  (1..N).each do |id|
    groups["gluster"].push("gluster-#{id}")
  end



  config.ssh.forward_agent = false


  (1..N).each do |id|
    config.vm.define "gluster-#{id}"   do |nd|
      nd.vm.box = "rhel-7.4-stage"
      nd.vm.provider :libvirt do |lv|
        lv.storage :file, :size => '60G', :type => 'qcow2'
        lv.storage :file, :size => '60G', :type => 'qcow2'
      end
      nd.vm.hostname = "gluster-#{id}.lab"
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
