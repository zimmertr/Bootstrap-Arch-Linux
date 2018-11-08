# Bootstrap Arch Linux

Basic Ansible project to provision my Arch Linux workstation.

## Instructions
1) Create an Arch Linux bootable USB.
2) Boot from USB with `pci=nomsi` option to GRUB to suppress pcieport errors from Thunderbolt addin card.
3) Once booted, make the TTY font size bigger: `setfont sun12x22`
4) Follow guide here: https://wiki.archlinux.org/index.php/installation_guide
5) Install GRUB: `Pacman -S grub efibootmgr`
6) Mount EFI partition: `mnt /dev/sd## /boot`
7) Create EFI entry: `grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB`
8) Configure grub settings: `vim /etc/default/grub`
    `GRUB_CMDLINE_LINUX_DEFAULT="pci=nomsi"`
9) Generate a GRUB configuration: `grub-mkconfig -o /boot/grub/grub.cfg`
10) Exit chroot and reboot into new install.
11) Connect to the network: `systemctl enable --now dhcpcd`
12) Install Ansible & git: `pacman -S ansible git`
13) Clone down this repository and `cd` into it.
14) Execute playbooks: `ansible-playbook -e @vars.yml site.yml`

## TODO

1) Sublime Configuration
2) git Configuration
3) Terminator Configuration
4) Update GRUB automatically
5) Configure network adapter on i3bar
6) Commit changes made to .i3config manually.
7) Set background.
8) End to end testing
