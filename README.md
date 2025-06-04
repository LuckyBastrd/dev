# How to run

~~~bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:LuckyBastrd/.dotfiles.git

# Change to chezmoi source directory
chezmoi cd

# Initialize and update git submodules
git submodule update --init --recursive

# Apply changes again to ensure submodules are linked properly
chezmoi apply
~~~
