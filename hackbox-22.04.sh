#!/usr/bin/bash

tmpdir=/var/tmp/hackbox

mkdir $tmpdir
cd $tmpdir

# install basic enumeration tools
apt -y install nmap sqlmap dnsenum dnsmap dnsrecon ffuf gobuster dirb

# install basic password cracking & brute forcing tools
apt -y install john hydra medusa hashcat

# install seclists
wget https://github.com/danielmiessler/SecLists/archive/refs/tags/2022.4.tar.gz
tar xzvf ./2022.4.tar.gz
mv ./SecLists-2022.4 /usr/share/seclists

# install metasploit
wget https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb
chmod +x msfupdate.erb
./msfupdate.erb

# install mimikatz 2.2.0-20220919
wget https://github.com/gentilkiwi/mimikatz/releases/download/2.2.0-20220919/mimikatz_trunk.zip
mkdir -p /root/tools/mimikatz && cd /root/tools/mimikatz && unzip $tmpdir/mimikatz_trunk.zip
mkdir -p /etc/skel/tools/mimikatz && unzip $tmpdir/mimikatz_trunk.zip
cd $tmpdir

