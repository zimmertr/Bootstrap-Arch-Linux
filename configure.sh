#!/bin/bash

#Update yum repos and add EPEL
yum update -y 
rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-10.noarch.rpm 

#Install group packages
yum group install "Development Tools" -y 

#Install stress
rpm -Uvh ftp://fr1.rpmfind.net/linux/dag/redhat/el7/en/x86_64/dag/RPMS/stress-1.0.2-1.el7.rf.x86_64.rpm 
rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-10.noarch.rpm

#Install other  packages
yum install -y wget tree curl htop screen vim git sshfs mlocate nmap net-tools snmpd net-snmp lsof autoconf automake curl gcc git htop iotop bmon sysstat calc mlocate open-vm-tools 

#Update mlocate database
updatedb

#Configure SNMP
vim /etc/snmp/snmpd.conf

#Replace the contents of snmpd.conf with the following:
#		com2sec readonly  default         >YOUR COMMUNITY STRING<
#
#		group MyROGroup v2c        readonly
#		view all    included  .1                               80
#		access MyROGroup ""      any       noauth    exact  all    none   none
#
#		syslocation Saturn
#		syscontact Your Name <tj@tjzimmerman.com>
#
#		extend .1.3.6.1.4.1.2021.7890.1 distro /usr/bin/distro

#Install dependencies for netdata
yum install -y libmnl-devel libuuid-devel lm-sensors make MySQL-python nc pkgconfig python python-psycopg2 PyYAML zlib-devel 

#Install netdata
git clone https://github.com/firehol/netdata.git --depth=1 
cd netdata 
./netdata-installer.sh 
sudo ln -s /root/netdata/netdata-updater.sh /etc/cron.daily/netdata-updater

#Enable Systemd modules
systemctl daemon-reload 
systemctl enable netdata 
systemctl enable snmpd 
systemctl enable vmtoolsd 

#Disable SELinux
sed -i --follow-symlinks 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux

#Install and configure ZSH
yum install zsh -y
cd ~ && git clone https://github.com/zimmertr/zsh-Configuration.git 
cp zsh-Configuration/.zshrc\ \(Ubuntu\) /root/.zshrc 
cp zsh-Configuration/.zshrc\ \(Ubuntu\) /home/tj/.zshrc 
cp zsh-Configuration/vimrc\ \(Ubuntu\) /etc/vimrc 

#Add ZSH Plugins
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" 
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git 
cp -r /root/zsh-syntax-highlighting /home/tj/ 
cp -r /root/.oh-my-zsh /home/tj 

#Update user shells
chsh -s /usr/bin/zsh root 
chsh -s /usr/bin/zsh tj

#Configure networking
nmtui

#Reboot to finalize
reboot
