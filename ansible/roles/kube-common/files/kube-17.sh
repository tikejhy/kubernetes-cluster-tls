#!/bin/bash

VERSION=$(kube-apiserver --version | awk '{ print $NF }' | sed 's/v//g;s/\.//g;s/.$//g')
NEWVERSION=$(/usr/local/src/kubernetes/server/kubernetes/server/bin/kube-apiserver --version | awk '{ print $NF }' | sed 's/v//g;s/\.//g;s/.$//g')
FILES='kubectl kubelet kube-proxy kube-apiserver kube-controller-manager kube-scheduler'
RENAME_FROM='/usr/bin /bin'
BRING_IN_FROM='/usr/local/src/kubernetes/server/kubernetes/server/bin/'


for i in $FILES; do
    for j in $RENAME_FROM; do
        mv $j/$i $j/$i-$VERSION
        mv $BRING_IN_FROM/$i $j/$i-$NEWVERSION
        ln -sfn $j/$i-$NEWVERSION $j/$i

    done
done
