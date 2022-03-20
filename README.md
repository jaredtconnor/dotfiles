# Personal `dotfiles` setup: 

Following [this](https://www.ackama.com/what-we-think/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained/) setup. 

# Installing 
1. `echo ".cfg" >> .gitignore`
2. `git clone <remote-git-repo-url> $HOME/.cfg`
3. `alias config='/usr/bin/git --git-dir=$HOME/.cfg/.git --work-tree=$HOME'`
4. `config config --local status.showUntrackedFiles no`
5. `config checkout`
