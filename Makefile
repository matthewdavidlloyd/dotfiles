ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

install: setup homebrew python r git bash scripts applescripts scientific-python

setup:
	mkdir -p $(HOME)/.scratch

homebrew: setup
	# TODO: Make this actually do somthing
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

postgres: setup homebrew
	brew install postgresql

python: setup homebrew
	# install python 3
	brew install python

	# invalidate bash's lookup cache for python
	hash -r python

	# Install virtualenv
	pip3 install virtualenv

	# Create a directory in which to store our virtualenv
	mkdir -p $(HOME)/.virtualenv

	# Install global python packages (jupyter etc.)
	pip install -r $(ROOT_DIR)/python/requirements_global.txt

r: setup homebrew python
	# Install R
	brew install r

	# Copy the Rprofile to home directory
	ln -sf $(ROOT_DIR)/rfiles/Rprofile $(HOME)/.Rprofile

	# Install the jupyter kernal
	R -e "install.packages(c('repr', 'IRdisplay', 'evaluate', 'crayon', 'pbdZMQ', 'devtools', 'uuid', 'digest'))"
	R -e "devtools::install_github('IRkernel/IRkernel')"
	R -e "IRkernel::installspec()"

vimlinks: setup
	rm -rf ~/.vim
	mkdir -p $(HOME)/.vim
	mkdir -p $(HOME)/.vim/functions
	ln -sf $(ROOT_DIR)/vimfiles/*.vim $(HOME)/.vim/functions
	ln -sf $(ROOT_DIR)/vimfiles/vimrc $(HOME)/.vimrc

powerline: setup python
	# Install globally
	# https://powerline.readthedocs.io/en/latest/installation/osx.html
	/usr/local/bin/pip3 install --user powerline-status

	# Also install the patched powerline fonts
	git clone https://github.com/powerline/fonts.git $(HOME)/.scratch/fonts --depth=1
	$(HOME)/.scratch/fonts/install.sh
	rm -rf $(HOME)/.scratch/fonts/fonts

vim: setup vimlinks powerline
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim -c PlugInstall -c quitall

neovim: setup python vimlinks powerline vim
	rm -rf $(HOME)/.config/nvim
	mkdir -p $(HOME)/.config/nvim
	mkdir -p $(HOME)/.config/nvim/ftplugin
	ln -sf $(ROOT_DIR)/vimfiles/vimrc $(HOME)/.config/nvim/init.vim
	ln -sf $(HOME)/.vim/plugged $(HOME)/.config/nvim/plugged
	ln -sf $(ROOT_DIR)/vimfiles/ftplugin $(HOME)/.config/ftplugin
	curl -fLo $(HOME)/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	nvim -c PlugInstall -c quitall
	cp -r $(ROOT_DIR)/vimfiles/fixes/browserlink.vim $(HOME)/.nvim/plugged/browserlink.vim/autoload/browserlink.vim

git:
	ln -sf $(ROOT_DIR)/gitfiles/gitconfig $(HOME)/.gitconfig
	ln -sf $(ROOT_DIR)/gitfiles/gitignore $(HOME)/.gitignore

bash:
	ln -sf $(ROOT_DIR)/bash_profile $(HOME)/.bash_profile
	ln -sf $(ROOT_DIR)/bashrc $(HOME)/.bashrc

scripts:
	ln -sf $(ROOT_DIR)/bin $(HOME)/.scripts
	
applescripts:
	ln -sf $(ROOT_DIR)/applescripts $(HOME)/.applescripts

scientific-python: setup python
	# Make a new virtualenv
	virtualenv -p /usr/local/bin/python3.6 $(HOME)/.virtualenv/scientific_python

	# Install the python packages into the virtualenv
	( \
		source $(HOME)/.virtualenv/scientific_python/bin/activate; \
		pip install -r $(ROOT_DIR)/python/requirements_scientific.txt; \
		deactivate; \
	)

	# Install pandoc (for converting notebooks to pdf)
	brew install pandoc

clean:
	# Remove any global pip packages
	/usr/local/bin/pip3 freeze | xargs /usr/local/bin/pip3 uninstall -y

	# Uninstall Homebrew
	# TODO: Make this actually do somthing
#	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"

	# Remove all of the directories
	rm -rf $(HOME)/.scratch
	rm -rf $(HOME)/.vim
	rm -rf $(HOME)/.config/nvim
	rm -rf $(HOME)/.vimrc
	rm -rf $(HOME)/.gitconfig
	rm -rf $(HOME)/.gitignore
	rm -rf $(HOME)/.bashrc
	rm -rf $(HOME)/.virtualenv
	rm -rf $(HOME)/.Rprofile