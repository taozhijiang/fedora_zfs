# Maintained by the Fedora Workstation WG:
# http://fedoraproject.org/wiki/Workstation
# mailto:desktop@lists.fedoraproject.org

repo --name=fedora --baseurl=http://mirrors.ustc.edu.cn/fedora/linux/releases/$releasever/Everything/$basearch/os/
repo --name=updates --baseurl=http://mirrors.ustc.edu.cn/fedora/linux/updates/$releasever/$basearch/
repo --name=freesign-arch --baseurl=https://freesign.net/freesign-repo/fedora/updates/$releasever/$basearch/
repo --name=freesign-noarch --baseurl=https://freesign.net/freesign-repo/fedora/updates/$releasever/noarch/

%include fedora-live-base.ks

%packages --instLangs=zh_CN.utf8

# Exclude unwanted groups that fedora-live-base.ks pulls in
@standard

# Make sure to sync any additions / removals done here with
# workstation-product-environment in comps
@base-x
@core
@fonts
@guest-desktop-agents
@hardware-support
#@workstation-product
@basic-desktop
@gnome

# Branding for the installer
fedora-productimg-workstation

-efibootmgr

# Exclude unwanted packages
-@dial-up
-@input-methods
#-@networkmanager-submodules
-@libreoffice
-@multimedia
-@printing
#
-gfs2-utils
-reiserfs-utils
#
#
#
-iwl4965-firmware
-iwl3945-firmware
-iwl6000-firmware
-iwl5150-firmware
-iwl1000-firmware
-iwl2030-firmware
-iwl2000-firmware
-iwl5000-firmware
-ipw2100-firmware
-iwl100-firmware
-iwl6000g2a-firmware  
-iwl135-firmware
-iwl105-firmware
-iwl3160-firmware
-ipw2200-firmware
-iwl6050-firmware
-iwl7260-firmware
-libertas-usb8388-firmware 
-iwl6000g2b-firmware
-atmel-firmware
-rsh

-xorg-x11-drv-ati
-xorg-x11-drv-wacom 
-xorg-x11-drv-nouveau
-xorg-x11-drv-openchrome
-ibus
-ibus-wayland
-ibus-gtk2
-ibus-setup
-ibus-gtk3 
-ibus-rawcode
-ibus-qt
-ibus-typing-booster
-ibus-chewing
-ibus-kkc
-ibus-hangul
-ibus-m17n
-ibus-libpinyin  

-elfutils 
-elfutils-libelf
-elfutils-libs 

-emacs-filesystem

-libreoffice-ure
-libreoffice-opensymbol-fonts
-libreoffice-pyuno
-libreoffice-calc             
-libreoffice-core             
-libreoffice-graphicfilter    
-libreoffice-draw             
-libreoffice-pdfimport        
-openoffice.org-diafilter     
-libreoffice-xsltfilter       
-libreoffice-math             
-libreoffice-writer           
-libreoffice-writer2latex     
-libreoffice-impress          
-libreoffice-filters

-tigervnc-license 
-tigervnc-server-minimal

-evolution
-evolution-help
-evolution-ews 
-evolution-data-server

-bluez-libs  
-bluez
-gnome-bluetooth-libs
-pulseaudio-module-bluetooth
-gnome-bluetooth
-NetworkManager-bluetooth
-xen-licenses   
-xen-libs


kernel-devel
zfs


%end

part / --size 6144 

%post

# This is a huge file and things work ok without it
rm -f /usr/share/icons/HighContrast/icon-theme.cache

cat >> /etc/rc.d/init.d/livesys << EOF


# disable updates plugin
cat >> /usr/share/glib-2.0/schemas/org.gnome.software.gschema.override << FOE
[org.gnome.software]
download-updates=false
FOE

# don't run gnome-initial-setup
mkdir ~liveuser/.config
touch ~liveuser/.config/gnome-initial-setup-done

# make the installer show up
if [ -f /usr/share/applications/liveinst.desktop ]; then
  # Show harddisk install in shell dash
  sed -i -e 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop ""
  # need to move it to anaconda.desktop to make shell happy
  mv /usr/share/applications/liveinst.desktop /usr/share/applications/anaconda.desktop

  cat >> /usr/share/glib-2.0/schemas/org.gnome.shell.gschema.override << FOE
[org.gnome.shell]
favorite-apps=['firefox.desktop', 'evolution.desktop', 'rhythmbox.desktop', 'shotwell.desktop', 'org.gnome.Nautilus.desktop', 'anaconda.desktop']
FOE

  # Make the welcome screen show up
  if [ -f /usr/share/anaconda/gnome/fedora-welcome.desktop ]; then
    mkdir -p ~liveuser/.config/autostart
    cp /usr/share/anaconda/gnome/fedora-welcome.desktop /usr/share/applications/
    cp /usr/share/anaconda/gnome/fedora-welcome.desktop ~liveuser/.config/autostart/
  fi

  # Copy Anaconda branding in place
  if [ -d /usr/share/lorax/product/usr/share/anaconda ]; then
    cp -a /usr/share/lorax/product/* /
  fi
fi

# rebuild schema cache with any overrides we installed
glib-compile-schemas /usr/share/glib-2.0/schemas

# set up auto-login
cat > /etc/gdm/custom.conf << FOE
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=liveuser
FOE

# Turn off PackageKit-command-not-found while uninstalled
if [ -f /etc/PackageKit/CommandNotFound.conf ]; then
  sed -i -e 's/^SoftwareSourceSearch=true/SoftwareSourceSearch=false/' /etc/PackageKit/CommandNotFound.conf
fi

# make sure to set the right permissions and selinux contexts
chown -R liveuser:liveuser /home/liveuser/
restorecon -R /home/liveuser/

EOF

%end
