#!/usr/bin/env python

import boto.ec2
import argparse
import subprocess 

c = boto.ec2.connect_to_region('eu-west-1')
reservations = c.get_all_instances(filters={"tag:Role" : ['kube-etcd-master']})
instances = [i for r in reservations for i in r.instances]

class master(object):

 def __init__(self):
    ''' Main Execution Point '''
    self.parse_cli_args()

 def parse_cli_args(self):
    ''' Command line argument processing '''
    parser = argparse.ArgumentParser(description='lets roll baby')
    parser.add_argument('--task', action='store', dest='task', required=True,
                          help='add or remove')
    self.args = parser.parse_args()

    if self.args.task == "add":
        stop_instances()
    elif self.args.task == "remove":
        start_instances()


def add_node():
    for inst in instances:
        if not inst.state == "stopped":
            instanceId=inst.id
            print "I am adding node %s" % (inst.tags['Name'])
            #echo "aws ec2 stop-instances --instance-id %s % (inst.id)"
        

def remove_node():
    for inst in instances:
        if not inst.state == "running":
            instanceId=inst.id
            print "I am removing node %s" % (inst.tags['Name'])
            #echo "aws ec2 start-instances --instance-id %s % (inst.id)"


if __name__ == '__main__':
    # Run the script
    master()
