#!/bin/bash


VIRSH="virsh -c qemu:///system"
NODEFILE=inventory

if [ -e $NODEFIL ]; then
  rm $NODEFILE
fi


touch $NODEFILE


for i in {1..4} ; do
  node=osp11_node-${i}
  echo $node
  ilo_port=6000${i}
  if $VIRSH dominfo $node > /dev/null 2>&1 ; then
    echo -n "$node ilo_address=192.168.121.1 ilo_port=$ilo_port " >> $NODEFILE
    $VIRSH domiflist $node | awk '$3=="ospd_provision" { printf( "boot_mac=%s\n",  $5 ) }' >> $NODEFILE
  fi
done

for i in {1..3} ; do
  node=osp11_store-${i}
  ilo_port=6100${i}
  echo $node
  if $VIRSH dominfo $node > /dev/null 2>&1 ; then
    echo -n "$node ilo_address=192.168.121.1 ilo_port=$ilo_port " >> $NODEFILE
    $VIRSH domiflist $node | awk '$3=="ospd_provision" { printf( "boot_mac=%s\n",  $5 ) }' >> $NODEFILE
  fi
done

cat << EOF >> $NODEFILE

[control]
osp11_node-[1:3]

[compute]
osp11_node-4

[storage]
osp11_store-[1:3]

[overcloud:children]
compute
storage
control

[overcloud:vars]
ilo_username=admin
ilo_password=password

[control:vars]
profile=control

[compute:vars]
profile=compute

[storage:vars]
profile=ceph-storage

EOF
