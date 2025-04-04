# Allen Wild
# Makefile for linuxfiles

DOTFILE_NAMES = \
 ackrc \
 agignore \
 agrc \
 dircolors \
 fonts \
 gitconfig_common \
 oh-my-zsh \
 quiltrc \
 tmux.conf \
 vim \
 vimrc \
 zshrc

NODOTFILE_NAMES = \
 myshrc

XDG_CONFIG_DIRS = \
 bat

ifeq ($(SRCDIR),)
SRCDIR = $(PWD)
endif
ifeq ($(DESTDIR),)
DESTDIR = $(HOME)
endif

ifeq ($(MSYSTEM),)
LINK_CMD = ln -srvT $(LINK_FORCE) $1 $2 2>/dev/null || true
else
# symlinks don't work in MSYS/MinGW, so do a recursive copy (hardlink files)
LINK_CMD = cp -alLfT $1 $2
endif

DOTFILE_PATHS   = $(addprefix $(DESTDIR)/., $(DOTFILE_NAMES))
NODOTFILE_PATHS = $(addprefix $(DESTDIR)/, $(NODOTFILE_NAMES))

BINFILE_NAMES = $(wildcard bin/*)
BINFILE_PATHS = $(addprefix $(DESTDIR)/, $(BINFILE_NAMES))

XDG_CONFIG_HOME ?= $(DESTDIR)/.config
XDG_CONFIG_PATHS = $(addprefix $(XDG_CONFIG_HOME)/, $(XDG_CONFIG_DIRS))

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
	@echo "  windows-vim (copy vim files to cygwin Windows home)"

###### CORE #######
.PHONY: links install
.PHONY: $(DOTFILE_PATHS) $(NODOTFILE_PATHS) $(BINFILE_PATHS) $(XDG_CONFIG_PATHS)
links: $(DOTFILE_PATHS) $(NODOTFILE_PATHS) $(BINFILE_PATHS) $(XDG_CONFIG_PATHS)
ifneq ($(MSYSTEM),)
	@# on msys, where symlinks don't work, copy over pathogen.vim symlink, since \
	 # the cp command will fail to do that for some reason
	cp -f $(SRCDIR)/vim/bundle/vim-pathogen/autoload/pathogen.vim $(DESTDIR)/.vim/autoload/pathogen.vim
	git -C $(SRCDIR) update-index --assume-unchanged vim/autoload/pathogen.vim
endif

install: links bashrc-append gitconfig-common-add submodules

$(DESTDIR):
	mkdir -p $(DESTDIR)

$(DOTFILE_PATHS) : $(DESTDIR)/.% : $(PWD)/%
	@mkdir -p $(@D)
	$(call LINK_CMD,$(SRCDIR)/$(notdir $<),$@)

$(NODOTFILE_PATHS) : $(DESTDIR)/% : $(PWD)/%
	@mkdir -p $(@D)
	$(call LINK_CMD,$(SRCDIR)/$(notdir $<),$@)

$(BINFILE_PATHS) : $(DESTDIR)/bin/% : $(PWD)/bin/%
	@mkdir -p $(DESTDIR)/bin
	$(call LINK_CMD,$(SRCDIR)/bin/$(notdir $<),$@)

$(XDG_CONFIG_PATHS) : $(XDG_CONFIG_HOME)/% : $(PWD)/%
	@mkdir -p $(@D)
	$(call LINK_CMD,$(SRCDIR)/$(notdir $<),$@)

.PHONY: bashrc-append
bashrc-append:
	sh -c 'echo "[[ -e ~/myshrc ]] && . ~/myshrc" >> $(DESTDIR)/.bashrc'
	sh -c 'echo "[[ -e ~/myshrc_local ]] && . ~/myshrc_local" >> $(DESTDIR)/.bashrc'

.PHONY: gitconfig-common-add
gitconfig-common-add:
	git config --global include.path ~/.gitconfig_common || true

.PHONY: selectf
selectf: submodules
	bash selectf/install.sh $(DESTDIR)/bin $(SRCDIR)/selectf/selectf.sh

.PHONY: uninstall-selectf
uninstall-selectf: submodules
	bash selectf/install.sh --uninstall $(DESTDIR)/bin $(SRCDIR)/selectf/selectf.sh

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

.PHONY: windows-vim
windows-vim:
	./extra/copy-windows-vim.sh
