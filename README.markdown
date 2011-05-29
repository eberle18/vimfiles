## First time configuration

First time on this machine?

### Fetching content

    git clone git@github.com:freitass/vimfiles.git ~/.vim

### Linking configuration file

    ln -s ~/.vim/vimrc ~/.vimrc

### Getting plugins

	cd ~/.vim/bundle/<plugin>
	git submodule update --init

## Updating .vim

Want to get or make changes?

### Getting last version

    cd ~/.vim
    git pull

### Installing new plugin

    cd ~/.vim
    git submodule add <plugin-repository> bundle/<plugin-name>
    git commit -m "Install <plugin-name>"
    git push

## Reference

<http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen/>

