#!/bin/bash

#Update packages and install pacaur
pacman -Syu
mkdir -p /tmp/pacaur_install && cd /tmp/pacaur_install
curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=cower && makepkg PKGBUILD --skippgpcheck --install --needed
curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=pacaur && makepkg PKGBUILD --install --needed
cd && rm -rf /tmp/pacaur_install


#Enable multiarch support
vim /etc/pacman.d/mirrorlist
pacaur -Syu


#Install base packages
pacaur -S acroread-bin alac arandr arch-firefox-search autoconf automake baobab bash-completion binutils bluez bmon bzip2 calc calibre chatzilla cheese codecs codecs64 compton cups curl dmenu dialog docker-git dropbox-cli dropbox-experimental expac exfat-fuse exfat-utils fail2ban fakeroot feh firefox-nightly flac freerdp gcc gimp git gparted grub-git gufw htop hunspell intel-ucode i3blocks-git i3status-git i3-gaps-next-git iotop iw lame libcdio libmpeg2 libreoffice lm-sensors lsof make mlocate ntfs-3g ntfs-config numlockx nemo nemo-dropbox netdata networkmanager networkmanager-openvpn networkmanager-ssh-git network-manager-applet ntp open-vm-tools openvpn pinta pkg-config playerctl-git pavucontrol qt4 ranger rar redshift-git remmina rocketchat-client scrot screen shotwell slack-desktop snmpd speedtest-cli spotify sublime-text-dev sshfs sudo sysstat terminator tlp tree unrar unzip util-linux vim vlc-git wget wpa_supplicant xorg-apps xorg-server-git xorg-xbacklight xorg-xrandr yajl zoom --noconfirm --needed


#Enable microcode updates and configure grub
grub-mkconfig -o /boot/grub/grub.cfg
grub-install --target=i386-pc /dev/nvme0n1p6


#Configure swap space
mkswap /dev/nvme0n1p7
swapon /dev/nvme0n1p7
#Configure fstab


#Install graphics drivers
#pacaur -S --noconfirm --needed
#primusrun nvidia intel-mesa


#Configure Systemd modules
systemctl daemon-reload
systemctl disable dhcpcd systemd-networkd systemd-resolved 
systemctl enable compton cups docker netdata networkmanager numlockx ntpd snmpd tlp tlp-sleep vmtoolsd
systemctl mask systemd-rfkill.service systemd-rfkill.socket


#Disable SELinux
sed -i --follow-symlinks 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux


#Discover hardware sensors
sensors-detect


#Add second user, install zsh & plugins, configure zsh
useradd tj
mkdir -p /home/tj/git && cd /home/tj/git

git clone https://github.com/zimmertr/zsh-Configuration.git
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git 
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" 

cp -r /home/tj/zsh-syntax-highlighting /root/
cp -r /home/tj/.oh-my-zsh /root/ 
cp zsh-Configuration/.zshrc\ \(Arch\) /root/.zshrc
cp /root/.zshrc /home/tj/.zshrc
cp zsh-Configuration/.vimrc\ \(Arch\) /etc/vimrc

chsh -s /usr/bin/zsh root
chsh -s /usr/bin/zsh tj


#Enable loop module for docker
tee /etc/modules-load.d/loop.conf <<< "loop"
modprobe loop 
usermod -aG docker tj


#Configure i3
cd /home/tj/git && git clone https://github.com/zimmertr/i3wm-Configuration.git && cd i3wm-Configuration
mkdir /home/tj/i3

cp /home/tj/i3wm-Configuration/i3config_1080p_three_monitors /home/tj/i3/
cp /home/tj/i3config_4k_laptop /home/tj/i3/ 
cp /home/tj/i3config_4k_laptop /etc/i3/config
cp /home/tj/i3wm-Configuration/i3blocks_4k_laptop.conf /etc/i3blocks.conf

mkdir /usr/lib/i3blocks
cp /home/tj/i3wm-Configuration/scripts/ /usr/lib/i3blocks



#vim /etc/xinitrc

#Configure SNMP
#vim /etc/snmp/snmpd.conf


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



#Configure networks
