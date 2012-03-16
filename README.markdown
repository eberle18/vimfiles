The objective of this file is to maintain the .vim directory in order and up to
date between all the machines where it is used. Here we will find the
instructions necessary to complete common tasks related to insertion, remotion
and modification of vim files and plugins.

## First time configuration

This instructions will configure the .vim directory for the first time on our
machine. If you are not Leandro Freitas but you want to get this files because
you liked it (or because of any other reason), this is your place too; in that
case, just replace `git@github.com:freitass/vimfiles.git` in the first command
for `git://github.com/freitass/vimfiles.git`.

First of all you have to clone the remote repository to our local machine:

    git clone git@github.com:freitass/vimfiles.git ~/.vim

After that, create a symlink from the vim runtime configure file (`~/.vimrc`)
to `~/.vim/vimrc` (Notice that the file provided is not hidden):

    ln -s ~/.vim/vimrc ~/.vimrc

You may notice that the clone script has created one folder per plugin inside
the `~/.vim/bundle` directory but those folders (the ones wich are kept as git
submodules) are empty. To get their content, init and update the submodules
running the following command:

    cd ~/.vim
    git submodule update --init

And we are done. Now, maybe it is a good idea to update the plugins.

## New plugin installation (with Git)

This section will guide you through the steps to install a new plugin. You are
encouraged to install plugins this way so you can easily get the lastest
changes as they are being committed by the developer (instructions in *Update
installed plugins*). The plugins are managed with *Pathogen*, so each plugin is
installed inside its own directory inside `bundle`.

From the `~/.vim` directory, add the new plugin repository as a submodule of
the current repository with the command below, where `<plugin-repository>` is
the address to the plugin repository (oh, really?) and the `<plugin-name>` is
(guess what?) the name of the directory, inside `bundle` where it will be
installed and it is generally the same as the repository name:

    cd ~/.vim
    git submodule add <plugin-repository> bundle/<plugin-name>

When the submodules are changed, Git catch those changes as modifications, so
it is important to commit them and push to the remote repository so that they
can be accessed from other machines:

    git commit -m "Install <plugin-name>"
    git push

## Update (just) installed plugins

When you add a submodule, the most recent commit of the submodule is stored in
the main repository’s index. That means that as the code in the submodule’s
repository updates, the same code will still be pulled on the repositories
relying on the submodule. This is how Git works by default. If you are in a
hurry, just run the following command. On the following lines there is an
explanation about how it works:

    cd ~/.vim
    git submodule foreach '\
    cd ~/.vim/$path;\
    git checkout master;\
    git pull'
    git add .
    git commit -m "Update plugins"

This command assume that your submodules are already initialized and
up-to-date. If this is not your case, see *First time configuration*.

As a matter of teaching, instead of updating all the plugins at once, as that
first command does, the following commands will update a single plugin. To
update a plugin we first get to its directory. In this example we will update
the *Todo.txt* plugin (maintained by myself for incredible two days at the time
of this writting):

    cd ~/.vim/bundle/todo.txt

Submodule repositories added by `git submodule update` are not on a current
branch. To fix this we simply need to switch to a branch, in most cases the
*master* branch:

    git checkout master

The last step is the update step itself. The command is pretty familiar:

    git pull

Now that the plugin was updated, we have to get back to the root of the
repository and commit the changes:

    cd ../..
    git add .
    git commit -m "Update todo.txt"

## Update .vim dir (synchronize with remote repository)

As you may have noticed, plugins can be installed through any clone of this
repository and we need a way to propagate the modifications made in one clone
to the others. For a standard git repository, a mere `git pull` would suffice
for the task. However, to catch up with the new installed plugins (submodules)
one more thing is necessary:

    git pull
    git submodule update --init

The first command will fetch and merge the lastest modifications made at the
repository including -- if a plugin has been recently installed in another
machine -- the folder of the plugin but not its contents. If you issue `git
pull` and check for the contents of the directory `bundle/<new-plugin>`, you
will see that it is empty. To fill the dir with the correct information you
need to issue the second command, just like if you were cloning the repository
for the first time (see *First time configuration*).

## References

<http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen/>

<http://chrisjean.com/2009/04/20/git-submodules-adding-using-removing-and-updating/>
