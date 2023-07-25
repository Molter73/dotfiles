#!/usr/bin/env bash

set -euo pipefail

SCRIPTPATH="$(
	cd -- "$(dirname "$0")" >/dev/null 2>&1
	pwd -P
)"

CONFIG_DIR="${HOME}/.config/zsh"
PLUGINS_DIR="${CONFIG_DIR}/plugins"
THEMES_DIR="${CONFIG_DIR}/themes"

if [[ ! -d "${CONFIG_DIR}" ]]; then
	mkdir -p "${CONFIG_DIR}"
fi

if [[ ! -d "${PLUGINS_DIR}" ]]; then
	mkdir -p "${PLUGINS_DIR}"
fi

if [[ ! -d "${THEMES_DIR}" ]]; then
	mkdir -p "${THEMES_DIR}"
fi

# Agnoster theme
if [[ ! -d "${THEMES_DIR}/agnoster" ]]; then
	mkdir "${THEMES_DIR}/agnoster"
	ln -s "${SCRIPTPATH}/themes/agnoster.zsh-theme" "${THEMES_DIR}/agnoster.zsh-theme"
fi

# command-not-found
if [[ ! -d "${PLUGINS_DIR}/command-not-found" ]]; then
	git clone https://github.com/Tarrasch/zsh-command-not-found "${PLUGINS_DIR}/command-not-found"
fi

# gcloud completion
if [[ ! -d "${PLUGINS_DIR}/gcloud" ]]; then
	mkdir "${PLUGINS_DIR}/gcloud"
	ln -s "${SCRIPTPATH}/plugins/gcloud.plugin.zsh" "${PLUGINS_DIR}/gcloud/gcloud.plugin.zsh"
fi

# git plugin
if [[ ! -d "${PLUGINS_DIR}/git" ]]; then
	git clone https://github.com/mdumitru/git-aliases "${PLUGINS_DIR}/git"
fi

# rust plugin
if [[ ! -d "${PLUGINS_DIR}/rust" ]]; then
	git clone https://github.com/wintermi/zsh-rust "${PLUGINS_DIR}/rust"
fi

if [[ ! -d "${PLUGINS_DIR}/fzf" ]]; then
	mkdir "${PLUGINS_DIR}/fzf"
	ln -s "${SCRIPTPATH}/plugins/fzf.zsh" "${PLUGINS_DIR}/fzf/fzf.zsh"
fi

# Install some useful podman scripting
if [[ ! -e "${PLUGINS_DIR}/podman" ]]; then
	mkdir "${PLUGINS_DIR}/podman"
	ln -s "${SCRIPTPATH}/plugins/podman.zsh" "${PLUGINS_DIR}/podman/podman.zsh"
fi

# Install the .zshrc file
if [[ ! -e "${HOME}/.zshrc" ]]; then
	ln -s "${SCRIPTPATH}/zshrc" "${HOME}/.zshrc"
fi

# Install the .zshenv file
if [[ ! -e "${HOME}/.zshenv" ]]; then
	ln -s "${SCRIPTPATH}/zshenv" "${HOME}/.zshenv"
fi
