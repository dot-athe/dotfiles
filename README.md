# dotfiles

## 本プロジェクトの概要
このプロジェクトでは .zsh やその他ツール(WezTerm や NeoVim)の configファイルを管理し、別マシンでも利用できるようにするためのものです。

## 必須ツール (Prerequisites)
この設定を利用するには、以下のツールをインストールしてください。

```bash
# Homebrew (Macの場合)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 必須パッケージのインストール
brew install \
  starship \
  sheldon \
  neovim \
  --cask wezterm \
  --cask font-jetbrains-mono-nerd-font
```

## セットアップ手順

### 1. dotfiles の取得
```bash
git clone https://github.com/YourUsername/dotfiles.git ~/dotfiles
```

### 2. 設定ファイルの配置 (シンボリックリンク)
既存の設定がある場合は、必ずバックアップを取ってから実行してください。

#### Zsh & Starship
```bash
# 退避
mkdir -p ~/backup
mv ~/.zshrc ~/backup/

# リンク作成
ln -s ~/dotfiles/.zshrc ~/.zshrc
# Starship設定 (必要に応じてディレクトリ作成)
mkdir -p ~/.config
ln -s ~/dotfiles/starship.toml ~/.config/starship.toml 
```

#### WezTerm
```bash
# ディレクトリごとリンク (推奨)
# ~/.config/wezterm ディレクトリが存在しないことを確認してから実行
rm -rf ~/.config/wezterm 
ln -s ~/dotfiles/.config/wezterm ~/.config/wezterm
```

#### Sheldon (プラグインマネージャー)
```bash
# ~/.config/sheldon/plugins.toml として配置
mkdir -p ~/.config/sheldon
ln -s ~/dotfiles/.config/sheldon/plugins.toml ~/.config/sheldon/plugins.toml
```

#### NeoVim (lazy.nvim)
設定ディレクトリごとリンクします。`lazy.nvim` 本体は初回起動時に自動的にインストールされます。
```bash
# 退避
mv ~/.config/nvim ~/backup/nvim.bak

# リンク作成 (dotfiles/.config/nvim が存在する場合)
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
```

## 新しい設定を追加する手順
使い方はシンプルです。
1. `~/dotfiles` 配下に実体ファイルを置く (例: `~/dotfiles/.config/myapp/config`)
2. 元の場所にシンボリックリンクを貼る (`ln -s ~/dotfiles/... ~/.config/myapp/config`)
3. `git add`, `git commit`, `git push` する