#!/bin/bash

for i in devel drivers infrastructure lixeiras manager marketing owner profiles public security; do lvcreate -L 500M -n $i storage; done
lvcreate -L 50M -n homes storage