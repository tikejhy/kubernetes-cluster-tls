- name: Create mountable dir
  file: path=/kube_share state=directory owner=root group=root

- name: Create "/srv/kubernetes" if it doesnot exists
  file:
    path: /srv/kubernetes
    state: directory
    mode: 0755

- name: Install list of packages
  yum: name={{item}} state=installed update_cache=yes enablerepo=epel
  with_items:
    - nfs-utils

- name: mount abovecreated directory
  mount:
    name: /srv/kubernetes
    src: "${efs-url}.efs.eu-west-1.amazonaws.com:/"
    fstype: nfs4
    state: present
