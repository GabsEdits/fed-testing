# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo sh ./all.sh" 2>&1
  exit 1
fi
# Enable flathub repo
 flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
 
# Enable RPM Fusion
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Media Codecs
dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
dnf groupupdate sound-and-video

# Hostname
hostnamectl set-hostname "asus"

# Apps
flatpak install flathub com.discordapp.Discord
flatpak install flathub org.telegram.desktop
flatpak install flathub com.spotify.Client
wget https://download.cdn.viber.com/desktop/Linux/viber.rpm
rpm -i viber.rpm
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo
dnf check-update
dnf install code

# Clear Cache
dnf clean dbcache
dnf clean all

# Theme
dnf copr enable nickavem/adw-gtk3
dnf install adw-gtk3
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
dnf copr enable peterwu/rendezvous
dnf install bibata-cursor-themes

# DNF Config
nano /etc/dnf/dnf.conf
# fastestmirror=True
# max_parallel_downloads=10
# defaultyes=True
# keepcache=True
# --------
