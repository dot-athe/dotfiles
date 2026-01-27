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

### 2. 設定ファイルの配置 (インストールスクリプト実行)

付属のセットアップスクリプトを実行することで、必要なシンボリックリンクが自動的に作成されます。

```bash
./install.sh
```

## 新しい設定を追加する手順
1. `~/dotfiles` 配下に実体ファイルを置く (例: `~/dotfiles/.config/myapp/config`)

2. 元の場所にシンボリックリンクを貼る (`ln -s ~/dotfiles/... ~/.config/myapp/config`)
3. `git add`, `git commit`, `git push` する

## メンテナンス (NeoVim)

### プラグインの削除・クリーンアップ

プラグインを削除した後は、不要なデータをディスクから完全に消去するために以下のコマンドをNeoVim内で実行してください。

1. プラグインの設定ファイル (`lua/plugins/xxx.lua`) を削除または編集
2. NeoVimを再起動
3. コマンドモードで以下を実行

   ```vim
   :Lazy clean
   ```

### プラグインのアップデート

インストール済みのプラグインを一括で最新版に更新するには、以下のコマンドを実行します。

```vim
:Lazy update
```
