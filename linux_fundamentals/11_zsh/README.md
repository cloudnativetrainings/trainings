# ZSH

ZSH brings in some neat behaviour and good styling into your daily work with Linux Machines. Lets give it a try.

## Install ZSH

```bash
# first check that /bin/bash is the current shell
cat /etc/passwd | grep root

# install zsh
apt install zsh

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# now zsh has become the current shell (note you change the shell via the command `chsh`)
cat /etc/passwd | grep root
```

## Add Plugins to ZSH

```bash
# git clone the plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# add the plugins to the plugins section via vi, so it looks like this: `plugins=(git zsh-autosuggestions zsh-syntax-highlighting)`
vi ~/.zshrc

# execute the file again
source ~/.zshrc

# now you have some syntax higlighting in place and also some good proposals from your history
```

# Making your shell beautiful

```bash
# git clone the theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# execute the file again, you will get some questions about your preferred look and feel
source ~/.zshrc

# et voilà => you have pimped your shell  ;)
```
