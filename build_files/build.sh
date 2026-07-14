#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# remove kde plasma
dnf5 -y remove plasma-workspace plasma-* kde-*

# setup niri
dnf5 -y install \
  niri \
  alacritty \
  foot \
  gdm \
  xdg-desktop-portal-gtk \
  xdg-desktop-portal-gnome \
  gnome-keyring \
  nautilus \
  mako \
  waybar \
  swayidle \
  swaylock \
  polkit-kde \
  xwayland-satellite \
  swaybg

dnf5 -y copr enable erikreider/swayosd
dnf5 -y install swayosd
dnf5 -y copr disable erikreider/swayosd

systemctl enable podman.socket
systemctl --global add-wants niri.service mako.service
systemctl --global add-wants niri.service swayidle.service
systemctl --global add-wants niri.service swaybg.service
systemctl --global add-wants niri.service plasma-polkit-agent.service
systemctl --global add-wants niri.service swayosd-server.service

# Clean up boot artifacts from base image
rm -rf /boot/extlinux

# Clean up runtime-only directories
rm -rf /run/dnf

# Clean up dnf state (repos, lock, countme, cache)
rm -rf /var/lib/dnf
