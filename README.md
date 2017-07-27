DRAFT [This works with some adjustments; ]
Terraform and Ansible is tied closely together; while terraform creats cluster it also renders some of the configuration for Ansible.

I will be seperating all part of terraform into different modules (i.e black box concepts of managing part of cluster) and additional nodes for etcd/master/minions able to run as Ansible solo (i.e trigger configuraiton on boot.)


Version:
	kubernetes 1.5 by default:
		kubernetes 1.5 is overidden by 1.7 (because of configMap bug had to install 1.7)
                May be incomplete: but its under ansible role; should be able to override by variable

		

Teraform:
Creates VPC with 
- 		CIDR: 10.31.0.0/16
- 		PUBLIC SUBNET: 10.31.0.0/24
- 		PRIVATE SUBNET: 10.31.1.0/24
- 		IG: General Internet Gateway
- 		NAT G: Nat to Internet
- 		RT: General Table of routing
- 		IP: Allocate IP to NAT
- 		Route Association:

			EC2:
- 			    1 Bastian HOST [Public]
- 			    N ETCD Node    [Private]	[behind ELB]
- 			    N Master Node  [Private]	[behind ELB]
- 			    N Nodes        [Private]]
		
			    

Ansible:
- 	Creates ETCD Cluster with TLS
		etcd
		flannel
- 	Creates Kube Master with TLS
		kube-apiserver
		kube-controller-manager
		kube-scheduler
		flannel
- 	Creates kube Nodes with TLS Support for kubelet
		kube-proxy
		kubelete
		flannel
		docker

	Roles:
- 	apiserver: 		Creates api server 
- 	apiserver-operator:	Creates api server [adding additional nodes]
- 	controller-manager:	Creates controller-manager
- 	dumpall:		Dump all variables
- 	efs-client:		mount efs server
- 	etcd:			Creates etcd cluster
- 	etcd-operator:		Adds members to etcd cluster
- 	flanneld:		configure flanneld
- 	kube-common:		creats all general 
- 	prep:			preparation for kube-common
- 	kubelet:		configures kubelet 
- 	provision-ec2:	        provisioning node for addons [based on variables on ansible/vars/etc2/<< tag name>>]	
- 	scheduler:		creates kube scheduler 
- 	selinux:		disable selinux wait until reboot


Incomplete:
	Works with few tweaks
- 		ETCD [adding members]
- 		Master [adding masters]
- 		Node [adding minions]



NOTE:
	vars.tf: takes majority of variable however few things are still to be moved to vars you may find hardcoded stuffs (well its initial stage yet)
#Example: 

- ansible-playbook -i localhost provision-ec2.yml -e 'type=kube-etcd'
- ansible-playbook -i "localhost," -c local etcd.yml --tags=addon

#SOME Hack's to identify next count for addon
- jq -r '.tag_Role_kube_etcd[]' | awk 'BEGIN{FS=OFS="_"}{NF--; print}'
- jq -r '.tag_Role_kube_etcd[]' | awk -F "_" '{print ($NF +1)}'
