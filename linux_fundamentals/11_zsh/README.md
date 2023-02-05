# zsh
```bash

# TODO slides sh vs bash vs fish vs zsh - fish marketing joke

apt install zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cat /etc/passwd | grep root
chsh

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

vi .zshrc
i
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
esc
wq
source .zshrc

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
vi .zshrc
i
ZSH_THEME="powerlevel10k/powerlevel10k"
esc
wq
p10k configure

```


install zsh



install oh-my-zsh
install plugins zsh-autosuggestions zsh-syntax-highlighting
enable plugins plugins=( git zsh-autosuggestions zsh-syntax-highlighting kube-ps1 kubectx )
install and set ZSH_THEME="powerlevel10k/powerlevel10k"