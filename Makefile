# Allen Wild
# Makefile for linuxfiles

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
	@echo "    selectf"
	@echo "    submodules (subs)"
	@echo "    subs-update (subsu)"
	@echo "    subs-commit (subsc)"
	@echo "  upgrade"
	@echo "  upgrade-omzsh"

###### CORE #######
.PHONY: links install
.PHONY: $(DOTFILE_PATHS) $(NODOTFILE_PATHS) $(BINFILE_PATHS)
links: $(DOTFILE_PATHS) $(NODOTFILE_PATHS) $(BINFILE_PATHS)
install: links bashrc-append submodules selectf

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

.PHONY: selectf
selectf: submodules
	python selectf/install.py $(HOME)/bin

###### SUBMODULES #######
.PHONY: submodules subs subs-commit subsc subs-update subsu
subs: submodules
submodules:
	git submodule update --init --recursive

subsu: subs-update
subs-update:
	git submodule update --init --recursive --remote

subsc: subs-commit
subs-commit: subs-update
	@[ -x ./commit_submodules.sh ] && ./commit_submodules.sh


###### UPGRADE ######
.PHONY: upgrade upgrade-omzsh
upgrade:
	make LINK_FORCE=-f links

upgrade-omzsh:
	rm -rf $(HOME)/.oh-my-zsh
	ln -sT $(PWD)/oh-my-zsh $(HOME)/.oh-my-zsh
