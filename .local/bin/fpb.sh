#!/bin/sh

# build from manifest
flatpak-builder --force-clean --user --install-deps-from=flathub --repo=repo --install builddir $1.yaml

# create bundle
flatpak build-bundle repo out.flatpak $1

# install
flatpak install --user out.flatpak
