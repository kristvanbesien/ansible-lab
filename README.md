A small Open Shift Vagrant lab.
==============================


What you'll need.
----------------

A Vagrant Rhel 7 box, and a Vagrant  Atomic Host box. I have prepared a few boxes and you can download them here:

http://file.emea.redhat.com/~kvanbesi/vagrantboxes/


Alternatively you can use Vagrantize to create an Atomic Host Vagrant box yourself.



Instructions
------------

Clone this repository.
Edit the Vagrantfile to reflect the names you gave your boxes.

```
vagrant up ws osmaster node-{1..3} storage-{1..3} infra-1 --no-parallel --no-provision 
```

```
vagrant provision ws
````

