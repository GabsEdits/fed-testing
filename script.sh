#!/bin/bash

usage() {
  echo "Usage: $0 [-f] [-r] [-m] [-a] [-t] [-p] [-x]" 1>&2
  echo "  -f  Make dnf faster"
  echo "  -r  Add RPM Fusion"
  echo "  -m  Add Multimedia Codecs"
  echo "  -a  Install apps"
  echo "  -t  Set up adw-gtk3 & dark sytle"
  echo "  -p  Add Flathub"
  echo "  -x  Add Apx"
  exit 1
}

while getopts ":frmatpx" option; do
  case "${option}" in
    f)
      # Make dnf faster
      if ! grep -q "^fastestmirror=True" /etc/dnf/dnf.conf; then
        sh -c 'echo "fastestmirror=True" >> /etc/dnf/dnf.conf'
      fi

      if ! grep -q "^max_parallel_downloads=10" /etc/dnf/dnf.conf; then
        sh -c 'echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf'
      fi

      if ! grep -q "^defaultyes=True" /etc/dnf/dnf.conf; then
        sh -c 'echo "defaultyes=True" >> /etc/dnf/dnf.conf'
      fi

      if ! grep -q "^keepcache=True" /etc/dnf/dnf.conf; then
        sh -c 'echo "keepcache=True" >> /etc/dnf/dnf.conf'
      fi
      ;;
    r)
      # Add RPM Fusion
      dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
      ;;
    m)
      # Add Multimedia Codecs
      dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
      dnf groupupdate sound-and-video -y
      ;;
    a)
      # Install apps
      dnf install discord -y
      wget https://download.cdn.viber.com/desktop/Linux/viber.rpm && rpm -i viber.rpm
      flatpak install flathub com.jetbrains.IntelliJ-IDEA-Community -y
      ;;
    t)
      # Set up adw-gtk3 & dark style
      dnf copr enable nickavem/adw-gtk3 -y
      dnf install adw-gtk3 -y
      gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
      ;;
    p)
      # Add Flathub
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      flatpak --user override --filesystem=/home/$USER/.icons/:ro
      flatpak --user override --filesystem=/usr/share/icons/:ro
      ;;
    x)
      # Add Apx
      dnf install go -y
      curl -s https://raw.githubusercontent.com/spaceguybob/apx-install/main/installer.sh | sh
      ;;
    *)
      usage
      ;;
  esac
done
