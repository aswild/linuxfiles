# Allen Wild
# Makefile for linuxfiles

DOTFILE_NAMES   = \
				  ackrc \
				  agignore \
				  agrc \
				  dircolors \
				  fonts \
				  gitconfig_common \
				  oh-my-zsh \
				  quiltrc \
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


ifeq ($(SRCDIR),)
	SRCDIR = $(PWD)
endif
ifeq ($(DESTDIR),)
	DESTDIR = $(HOME)
endif

LINK_CMD = ln -svT $(LINK_FORCE)

DOTFILE_PATHS   = $(addprefix $(DESTDIR)/., $(DOTFILE_NAMES))
NODOTFILE_PATHS = $(addprefix $(DESTDIR)/, $(NODOTFILE_NAMES))

BINFILE_NAMES	= $(wildcard bin/*)
BINFILE_PATHS	= $(addprefix $(DESTDIR)/, $(BINFILE_NAMES))

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
	@echo "  windows-vim (copy vim files to cygwin Windows home)"

###### CORE #######
.PHONY: links install
.PHONY: $(DOTFILE_PATHS) $(NODOTFILE_PATHS) $(BINFILE_PATHS)
links: $(DOTFILE_PATHS) $(NODOTFILE_PATHS) $(BINFILE_PATHS)
install: links bashrc-append gitconfig-common-add submodules selectf

$(DESTDIR):
	mkdir -p $(DESTDIR)

$(DOTFILE_PATHS) : $(DESTDIR)/.% : $(PWD)/%
	@mkdir -p $(@D)
	@$(LINK_CMD) $(SRCDIR)/$(notdir $<) $@ 2>/dev/null || true

$(NODOTFILE_PATHS) : $(DESTDIR)/% : $(PWD)/%
	@mkdir -p $(@D)
	@$(LINK_CMD) $(SRCDIR)/$(notdir $<) $@ 2>/dev/null || true

$(BINFILE_PATHS) : $(DESTDIR)/bin/% : $(PWD)/bin/%
	@mkdir -p $(DESTDIR)/bin
	@$(LINK_CMD) $(SRCDIR)/bin/$(notdir $<) $@ 2>/dev/null || true

.PHONY: bashrc-append
bashrc-append:
	sh -c 'echo "[[ -e ~/myshrc ]] && . ~/myshrc" >> $(DESTDIR)/.bashrc'
	sh -c 'echo "[[ -e ~/myshrc_local ]] && . ~/myshrc_local" >> $(DESTDIR)/.bashrc'

.PHONY: gitconfig-common-add
gitconfig-common-add:
	git config --global include.path ~/.gitconfig_common || true

.PHONY: selectf
selectf: submodules
	python selectf/install.py $(DESTDIR)/bin $(SRCDIR)/selectf/selectf.sh

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
	rm -rf $(DESTDIR)/.oh-my-zsh
	ln -sT $(PWD)/oh-my-zsh $(DESTDIR)/.oh-my-zsh

.PHONY: windows-vim
windows-vim:
	test -d /cygdrive/c/Users/$(USER) && ( \
		rsync -rLtv --delete vim/ /cygdrive/c/Users/$(USER)/vimfiles ; \
		cp -vf vimrc /cygdrive/c/Users/$(USER)/_vimrc )
