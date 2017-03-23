ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

install: vim neovim git bash task scripts

vim: vimlinks
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim -c PlugInstall -c quitall

neovim: 
	rm -rf $(HOME)/.config/nvim
	mkdir -p $(HOME)/.config/nvim
	mkdir -p $(HOME)/.config/nvim/ftplugin
	ln -sf $(ROOT_DIR)/vimfiles/vimrc $(HOME)/.config/nvim/init.vim
	ln -sf $(HOME)/.vim/plugged $(HOME)/.config/nvim/plugged
	ln -sf $(ROOT_DIR)/vimfiles/ftplugin $(HOME)/.config/ftplugin
	curl -fLo $(HOME)/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	nvim -c PlugInstall -c quitall
	cp -r $(ROOT_DIR)/dotfiles/vimfiles/fixes/browserlink.vim $(HOME)/.nvim/plugged/browserlink.vim/autoload/browserlink.vim

vimlinks:
	rm -rf ~/.vim
	mkdir $(HOME)/.vim
	mkdir $(HOME)/.vim/functions
	ln -sf $(ROOT_DIR)/vimfiles/*.vim $(HOME)/.vim/functions
	ln -sf $(ROOT_DIR)/vimfiles/vimrc $(HOME)/.vimrc

git:
	ln -sf $(ROOT_DIR)/gitfiles/gitconfig $(HOME)/.gitconfig
	ln -sf $(ROOT_DIR)/gitfiles/gitignore $(HOME)/.gitignore

bash:
	ln -sf $(ROOT_DIR)/bash_profile $(HOME)/.bash_profile
	ln -sf $(ROOT_DIR)/bashrc $(HOME)/.bashrc

task:
	ln -sf $(ROOT_DIR)/taskrc $(HOME)/.taskrc

scripts:
	ln -sf $(ROOT_DIR)/bin $(HOME)/.scripts
	
applescripts:
	ln -sf $(ROOT_DIR)/applescripts $(HOME)/.applescripts

scientific:
	# set up some taps and update brew
	brew tap homebrew/science 		# a lot of cool formulae for scientific tools
	brew tap homebrew/python 			# numpy, scipy, matplotlib, ...
	brew update && brew upgrade
	# install a brewed python
	brew install python3
	# invalidate bash's lookup cache for python
	hash -r python  
	# Check this all worked 
	brew doctor
	# Install python stuff
	pip install numpy
	pip install scipy
	pip install matplotlib

clean:
	rm -rf $(HOME)/.vim
	rm -rf $(HOME)/.config/nvim
	rm -rf $(HOME)/.vimrc
	rm -rf $(HOME)/.gitconfig
	rm -rf $(HOME)/.gitignore
	rm -rf $(HOME)/.bashrc
