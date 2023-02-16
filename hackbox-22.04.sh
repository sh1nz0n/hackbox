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
mkdir -p /root/tools/mimikatz \
  && cd /root/tools/mimikatz \
  && unzip $tmpdir/mimikatz_trunk.zip \
  && cp -a /root/tools/mimikatz /etc/skel/tools

cd $tmpdir

# install winPEAS & linPEAS
mkdir -p /root/tools \
  && wget https://github.com/carlospolop/PEASS-ng/archive/refs/tags/20230212.tar.gz \
  && tar xzvf 20230212.tar.gz \
  && mv PEASS-ng-20230212 /root/tools/peass \
  && cp -a /root/tools/peass /etc/skel/tools

cd $tmpdir

# install powerup
wget https://github.com/PowerShellMafia/PowerSploit/blob/master/Privesc/PowerUp.ps1 \
  && cp -a ./PowerUp.ps1 /root/tools/ \
  && cp -a ./PowerUp.ps1 /etc/skel/tools 
