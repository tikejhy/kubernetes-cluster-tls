Host 10.31.*
    StrictHostKeyChecking no
    ProxyCommand ssh ${bastionIP} -W %h:%p
    IdentityFile ./keys/kube-key

Host ${bastionIP}
     StrictHostKeyChecking no
     IdentityFile ./keys/kube-key
     User centos
