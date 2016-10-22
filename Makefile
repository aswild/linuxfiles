# Allen Wild
# Makefile for linuxfiles
#
# TODO:
#  * install directories for bin and .config

DOTFILE_NAMES   = \
				  ackrc \
				  dircolors \
				  gitconfig_common \
				  tmux.conf \
				  tmux_version_conf.sh \
				  vim \
				  vimrc \
				  zshrc \
				  oh-my-zsh \


NODOTFILE_NAMES = \
				  myshrc \


DEBIAN_PACKAGES = \
				  zsh \
                  git \
                  vim \
                  tmux \
                  htop \
                  ack-grep \


DOTFILE_PATHS   = $(addprefix $(HOME)/., $(DOTFILE_NAMES))
NODOTFILE_PATHS = $(addprefix $(HOME)/, $(NODOTFILE_NAMES))

BINFILE_NAMES	= $(wildcard bin/*)
BINFILE_PATHS	= $(addprefix $(HOME)/, $(BINFILE_NAMES))

# help target is first because it's safe
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  install"
	@echo "    links"
	@echo "    bashrc-append"
	@echo "    submodules (subs)"
	@echo "    subs-commit (subsc)"
	@echo "  extras"
	@echo "    tmux-20"
	@echo "    debian-packages"
	@echo "  upgrade"
	@echo "  upgrade-omzsh"

###### CORE #######
.PHONY: links install
.PHONY: $(DOTFILE_PATHS) $(NODOTFILE_PATHS) $(BINFILE_PATHS)
links: $(DOTFILE_PATHS) $(NODOTFILE_PATHS) $(BINFILE_PATHS)
install: links bashrc-append submodules

$(DOTFILE_PATHS) : $(HOME)/.% : $(PWD)/%
	ln -sT $(LINK_FORCE) $< $@ || true

$(NODOTFILE_PATHS) : $(HOME)/% : $(PWD)/%
	ln -sT $(LINK_FORCE) $< $@ || true

$(BINFILE_PATHS) : $(HOME)/bin/% : $(PWD)/bin/%
	@mkdir -p $(HOME)/bin
	ln -sT $(LINK_FORCE) $< $@ || true

.PHONY: bashrc-append
bashrc-append:
	sh -c 'echo "[[ -e ~/myshrc ]] && . ~/myshrc" >> $(HOME)/.bashrc'
	sh -c 'echo "[[ -e ~/myshrc_local ]] && . ~/myshrc_local" >> $(HOME)/.bashrc'

###### SUBMODULES #######
.PHONY: submodules subs subs-commit subsc subs-update subsu
subs: submodules
submodules:
	git submodule update --init --recursive

subsu: subs-update
subs-update:
	git submodule update --init --recursive --remote

subsc: subs-commit
subs-commit: submodules-update
	@[ -x ./commit_submodules.sh ] && ./commit_submodules.sh


###### EXTRAS #######
.PHONY: extras
extras: debian-packages tmux-20

.PHONY: tmux-20
tmux-20:
	mkdir -p $(HOME)/packages
	wget -O $(HOME)/packages/tmux-2.0.tar.gz \
		https://github.com/tmux/tmux/releases/download/2.0/tmux-2.0.tar.gz

.PHONY: debian-packages
debian-packages:
	@which apt-get >/dev/null 2>&1 && sudo apt-get install $(DEBIAN_PACKAGES)

###### UPGRADE ######
.PHONY: upgrade upgrade-omzsh
upgrade:
	make LINK_FORCE=-f links

upgrade-omzsh:
	rm -rf $(HOME)/.oh-my-zsh
	ln -sT $(PWD)/oh-my-zsh $(HOME)/.oh-my-zsh
