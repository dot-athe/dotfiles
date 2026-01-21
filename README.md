# dotfiles

## 本プロジェクトの概要
このプロジェクトでは .zsh やその他ツール(WezTerm や NeoVim)の configファイルを管理し、別マシンでも利用できるようにするためのものです。

## 使い方(.zshrcの例)
1. 使っているシェルの設定(`~/.zshrc`)をdotfiles以下にコピーする
   ```bash
   cp ~/.zshrc ~/dotfiles/.zshrc
   ```
2. 元の`~/.zshrc`を退避させる 
   ```bash
   mkdir backup && mv ~/.zshrc backup
   ```
3. dotfilesの.zshrcにシンボリックリンクを貼る
   ```bash
   ln -s ~/dotfiles/.zshrc ~
   ```
4. あとはdotfiles以下でコミットしてpushしたら出来上がり 
5. 同じように管理したいものdotfilesディレクトリにコピーしてシンボリックリンクを貼っていく