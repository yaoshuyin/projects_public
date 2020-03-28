#!/bin/bash
# --limit 192.168.1.211
ansible-playbook -v -i hosts.ini ceph.yml --private-key rsa -u user
