#!/usr/bin/bash

tmpdir=/var/tmp/hackbox

mkdir $tmpdir
cd $tmpdir

# install basic enumeration tools
apt -y install nmap sqlmap dnsenum dnsmap dnsrecon ffuf gobuster

# install basic password cracking tools
apt -y install john hydra

# install seclists
wget https://github.com/danielmiessler/SecLists/archive/refs/tags/2022.4.tar.gz
tar xzvf ./2022.4.tar.gz
mv ./SecLists-2022.4 /usr/share/seclists

