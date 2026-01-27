# Sheldon Setup Guide (Homebrew & Zsh)

## ドキュメント
- [GitHub Repository](https://github.com/rossmacarthur/sheldon)

## 概要
**Sheldon** は、Rust製の高速かつ設定可能なシェルプラグインマネージャーです。
`plugins.toml` という単一の設定ファイルでプラグインを管理でき、高速に動作するのが特徴です。
dotfilesでの管理とも非常に相性が良く、設定の再現性を高めます。

## 前提条件
- **OS**: macOS (推奨) または Linux
- **Shell**: Zsh
- **Package Manager**: Homebrew (`brew` コマンドが使えること)

## インストール手順

### 1. Sheldon のインストール
Homebrew を使用してインストールします。

```bash
brew install sheldon
```

### 2. 設定ファイルの初期化
Sheldon の設定ファイル `plugins.toml` を作成します。
Zsh 向けの設定ファイルとして初期化します。

```bash
sheldon init --shell zsh
```
これにより、`~/.config/sheldon/plugins.toml` が作成されます。

### 3. Zsh への連携設定
`~/.zshrc` に以下の行を追加し、Sheldon が管理するプラグインを読み込むようにします。

```bash
# ~/.zshrc
eval "$(sheldon source)"
```

## 設定例 (plugins.toml)
`~/.config/sheldon/plugins.toml` の設定例です。
プラグインの追加は、ファイルを直接編集するか、`sheldon add` コマンドを使用します。

```toml
# ~/.config/sheldon/plugins.toml

# シェル設定 (ここでは zsh を指定)
shell = "zsh"

# [plugins.プラグイン名] で定義します

# 例: zsh-autosuggestions (入力補完)
[plugins.zsh-autosuggestions]
github = "zsh-users/zsh-autosuggestions"

# 例: zsh-syntax-highlighting (シンタックスハイライト)
# ※ 通常は最後に読み込むことが推奨されます
[plugins.zsh-syntax-highlighting]
github = "zsh-users/zsh-syntax-highlighting"

# 例: 外部コマンドの管理 (例: fzf)
# 外部リポジトリのバイナリなどを管理する場合にも使えますが、
# 基本的には Zsh プラグインの管理がメインです。
```

### コマンドでの追加例
コマンドラインからプラグインを追加する場合の例です。

```bash
# zsh-autosuggestions を追加
sheldon add zsh-autosuggestions --github zsh-users/zsh-autosuggestions

# zsh-syntax-highlighting を追加
sheldon add zsh-syntax-highlighting --github zsh-users/zsh-syntax-highlighting
```

## 基本操作一覧

| コマンド | 説明 |
| --- | --- |
| `sheldon init` | 設定ファイルの初期化 |
| `sheldon lock` | プラグインのバージョンをロックし `plugins.lock` を更新 |
| `sheldon source` | 設定に基づき初期化スクリプトを出力 (zshrcで使用) |
| `sheldon add <name> --github <repo>` | GitHubリポジトリをプラグインとして追加 |
| `sheldon remove <name>` | プラグインを削除 |
| `sheldon edit` | 設定ファイル (`plugins.toml`) をエディタで開く |

## 補足: dotfiles での管理
`~/.config/sheldon/plugins.toml` を dotfiles リポジトリ (`~/dotfiles/.config/sheldon/plugins.toml` 等) に移動し、シンボリックリンクを貼ることで、他の環境でも同じプラグイン構成を即座に再現できます。

```bash
# 例: 設定ファイルを dotfiles に移動してリンク
mkdir -p ~/dotfiles/.config/sheldon
mv ~/.config/sheldon/plugins.toml ~/dotfiles/.config/sheldon/
ln -s ~/dotfiles/.config/sheldon/plugins.toml ~/.config/sheldon/plugins.toml
```
