               id: 23
             name: post_install.sh
              url: post_install.sh
       date_added: 2013-03-06
     
          content: #!/bin/bash

V=`/usr/bin/lsb_release -rs`

################################################################################

if [ $V \< 12.10 ]; then

	#
	#Hide Ubuntu desktop icons
	#
	gsettings set org.gnome.nautilus.desktop computer-icon-visible false
	gsettings set org.gnome.nautilus.desktop home-icon-visible false
	gsettings set org.gnome.nautilus.desktop network-icon-visible false
	gsettings set org.gnome.nautilus.desktop trash-icon-visible false

	#
	#Disable overlay scrollbars in Ubuntu
	#
	echo "export LIBOVERLAY_SCROLLBAR=0" > /etc/X11/Xsession.d/80overlayscrollbars
	sudo apt-get -y purge overlay-scrollbar liboverlay-scrollbar-0.1-0

	#
	#Disable Unity Menu Bar#
	#
	sudo apt-get -y purge appmenu-gtk appmenu-gtk3 appmenu-qt
	gsettings set com.canonical.desktop.interface scrollbar-mode normal

	#
	#Disable the HUD when pressing the ALT key
	#
	gconftool-2 --set "/apps/compiz-1/plugins/unityshell/screen0/options/show_hud" --type string "<Alt>l"
	gsettings set org.gnome.nautilus.preferences always-use-location-entry true

	#
	# Disabling privacy invasive Zeitgeist
	#
	sudo apt-get -y purge zeitgeist-core zeitgeist-datahub python-zeitgeist rhythmbox-plugin-zeitgeist zeitgeist geoclue geoclue-ubuntu-geoip
	rm -rf ~/.local/share/zeitgeist/

	#
	#Custom install scripts#
	#
	sudo apt-get -y purge unity-scope-musicstores rhythmbox-ubuntuone ubuntuone-installer ubuntuone-control-panel ubuntuone-couch ubuntuone-client-gnome
	sudo apt-get -y purge libsyncdaemon-1.0-1 gir1.2-ubuntuoneui-3.0 libubuntuoneui-3.0-1 ubuntuone-client
	sudo apt-get -y purge libgwibber-gtk2 libgwibber2 gwibber-service-twitter gwibber-service-identica gwibber-service-facebook gwibber-service gwibber
	sudo apt-get -y install hal vim aptitude pidgin xvnc4viewer filezilla gthumb myunity

else

	#
	#Hide Ubuntu desktop icons
	#
	gsettings set org.gnome.nautilus.desktop home-icon-visible false
	gsettings set org.gnome.nautilus.desktop network-icon-visible false
	gsettings set org.gnome.nautilus.desktop trash-icon-visible false

	#
	#Disable overlay scrollbars in Ubuntu
	#
	gsettings set com.canonical.desktop.interface scrollbar-mode normal

	#
	# Turn off "Remote Search", so search terms in Dash don't get sent to the internet
	#
	gsettings set com.canonical.Unity.Lenses remote-content-search none

	#
	# Install compiz manager
	#
	sudo apt-get -y install compizconfig-settings-manager

	#
	#Disable the HUD when pressing the ALT key
	#
	dconf write /org/compiz/integrated/show-hud "['disable']"

	#
	# Disable remote scopes
	#
	gsettings set com.canonical.Unity.Lenses disabled-scopes "['more_suggestions-amazon.scope', 'more_suggestions-u1ms.scope','more_suggestions-populartracks.scope', 'music-musicstore.scope','more_suggestions-ebay.scope', 'more_suggestions-ubuntushop.scope','more_suggestions-skimlinks.scope']"

	#
	# Remove UbuntuOne
	#
	killall ubuntuone-login ubuntuone-preferences ubuntuone-syncdaemon
	sudo rm -rf ~/.local/share/ubuntuone
	rm -rf ~/.cache/ubuntuone
	rm -rf ~/.config/ubuntuone
	mv ~/Ubuntu\ One/ ~/UbuntuOne_old/``
	sudo apt-get -y purge ubuntuone-client python-ubuntuone-storage*

	#
	#Custom install scripts
	#
	sudo apt-get -y install vim pidgin xvnc4viewer filezilla gthumb unity-tweak-tool
	sudo apt-get -y unity-lens-music unity-lens-photos unity-lens-gwibber unity-lens-shopping unity-lens-video
	sudo apt-get -y install flashplugin-installer
	sudo apt-get -y install p7zip-rar p7zip-full unace unrar zip unzip sharutils rar uudeview mpack arj cabextract file-roller

fi

#
# If you're using earlier than 13.10, uninstall unity-lens-shopping
#
sudo apt-get remove -y unity-lens-shopping

#
#Always show location in Nautilus#
#
gsettings set org.gnome.nautilus.preferences always-use-location-entry true


#
#Disable the drum beat sound in Ubuntu#
#
sudo mv /usr/share/sounds/ubuntu/stereo/desktop-login.ogg /usr/share/sounds/ubuntu/stereo/desktop-login.ogg.old
sudo mv /usr/share/sounds/ubuntu/stereo/system-ready.ogg /usr/share/sounds/ubuntu/stereo/system-ready.ogg.old

#
#Install fonts in Ubuntu#
#
wget http://www.customizeubuntu.com/source/mac_fonts.tar.gz -O /tmp/mac_fonts.tar.gz
tar zxvf /tmp/mac_fonts.tar.gz
sudo mkdir -p /usr/share/fonts/truetype/macos/
sudo mv /tmp/fonts/* /usr/share/fonts/truetype/macos/
sudo fc-cache -f -v
sudo apt-get -y install msttcorefonts
sudo apt-get -y install ttf-mscorefonts-installer

#
# Fix slow connection in ssh
#
sudo sed -i 's/GSSAPIAuthentication/#GSSAPIAuthentication/g' /etc/ssh/ssh_config
sudo sed -i 's/GSSAPIDelegateCredentials/#GSSAPIDelegateCredentials/g' /etc/ssh/ssh_config

#
# Block connections to Ubuntu's ad server, just in case
#
if ! grep -q productsearch.ubuntu.com /etc/hosts; then
	sudo echo -e "\n127.0.0.1 productsearch.ubuntu.com" | sudo tee -a /etc/hosts >/dev/null
fi

#
#Custom install scripts
#
sudo apt-get -y purge thunderbird-globalmenu thunderbird-gnome-support thunderbird-locale-en thunderbird-locale-en-us thunderbird
sudo apt-get -y purge totem-mozilla totem-plugins totem
sudo apt-get -y purge transmission-common transmission-gtk
sudo apt-get -y purge nautilus-sendto-empathy empathy-common empathy
sudo apt-get -y purge shotwell gnome-orca gnome-screensaver
sudo apt-get -y purge gnomine gnome-sudoku gnome-mahjongg

#
#Fix Adobe flash player version is not supported
#
cd 
rm -rf ~/.adobe/Flash_Player/NativeCache
rm -rf ~/.adobe/Flash_Player/AssetCache
rm -rf ~/.adobe/Flash_Player/APSPrivateData2

#
# Install LAMP
#
sudo apt-get -y install apache2
sudo echo "ServerName `hostname`" > /etc/apache2/httpd.conf
sudo updatedb
sudo echo "LoadModule rewrite_module `locate mod_rewrite.so`" > /etc/apache2/mods-available/rewrite.load
sudo sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/sites-available/default
sudo ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled
sudo ln -s /etc/apache2/mods-available/deflate.load /etc/apache2/mods-enabled
sudo ln -s /etc/apache2/mods-available/expires.load /etc/apache2/mods-enabled
sudo apt-get -y install php5 libapache2-mod-php5 mysql-server libapache2-mod-auth-mysql php5-mysql php5-cli php5-cli php5-curl php5-gd php5-imap php5-mcrypt
sudo /etc/init.d/apache2 restart
sudo echo -e "[mysqld]\ndefault-storage-engine = myisam" >> /etc/mysql/my.cnf

#
# Clean
#
sudo apt-get -y autoclean
sudo apt-get -y autoremove
