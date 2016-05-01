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

# help target is first because it's safe
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  install"
	@echo "    links"
	@echo "    bashrc-append"
	@echo "  extras"
	@echo "    oh-my-zsh"
	@echo "    tmux-20"
	@echo "    debian-packages"
	@echo "  upgrade"

###### CORE #######
.PHONY: links install
links: $(DOTFILE_PATHS) $(NODOTFILE_PATHS)
install: links bashrc-append

.PHONY: $(DOTFILE_PATHS) $(NODOTFILE_PATHS)
$(DOTFILE_PATHS) : $(HOME)/.% : $(PWD)/%
	ln -s $(LINK_FORCE) $< $@ || true

$(NODOTFILE_PATHS) : $(HOME)/% : $(PWD)/%
	ln -s $(LINK_FORCE) $< $@ || true

.PHONY: bashrc-append
bashrc-append:
	sh -c 'echo "[[ -e ~/myshrc ]] && . ~/myshrc" >> $(HOME)/.bashrc'
	sh -c 'echo "[[ -e ~/myshrc_local ]] && . ~/myshrc_local" >> $(HOME)/.bashrc'


###### EXTRAS #######
.PHONY: extras
extras: oh-my-zsh debian-packages tmux-20

.PHONY: oh-my-zsh
oh-my-zsh:
	git clone https://github.com/robbyrussell/oh-my-zsh.git $(HOME)/.oh-my-zsh

.PHONY: tmux-20
tmux-20:
	mkdir -p $(HOME)/packages
	wget -O $(HOME)/packages/tmux-2.0.tar.gz \
		https://github.com/tmux/tmux/releases/download/2.0/tmux-2.0.tar.gz

.PHONY: debian-packages
	@ if which apt-get >/dev/null 2>&1; then \
	    sudo apt-get install $(DEBIAN_PACKAGES) \
	  fi

###### UPGRADE ######
.PHONY: upgrade
upgrade:
	make LINK_FORCE=-f links
