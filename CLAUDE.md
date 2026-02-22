# CLAUDE.md

このファイルは Claude Code (claude.ai/code) がこのリポジトリで作業する際のガイドです。

## ルール

- チャット、プランの提案、コミットメッセージ以外のすべてのやり取りは日本語で行うこと
- ドキュメントやコメントも日本語で記述すること

## 概要

ZSH、Neovim、WezTerm、Starship、Sheldon の設定ファイルを管理する dotfiles リポジトリ。設定は `~/dotfiles/` に保存し、シンボリックリンクで配置する。

前提条件、セットアップ手順、メンテナンス方法については `README.md` を参照。

## アーキテクチャ

### シンボリックリンク戦略
- `install.sh` が `.zshrc` → `~/`、`.config/` 配下の各ディレクトリ → `~/.config/` にシンボリックリンクを作成
- 既存の設定は `~/backup/` にバックアップしてから上書き

### Neovim 設定 (`.config/nvim/`)
- **エントリポイント**: `init.lua` → `config.options` と `config.lazy` を読み込み
- **プラグインマネージャ**: lazy.nvim (`lua/config/lazy.lua` でブートストラップ)
- **プラグイン設定**: `lua/plugins/` 配下にプラグインごとに1ファイル
- **ファイルタイプ設定**: `after/ftplugin/` (例: TypeScript は2スペースインデント)
- **LSP**: mason.nvim が `lua_ls`, `ts_ls`, `eslint`, `gopls` を自動インストール。ESLint は保存時に自動修正

### WezTerm 設定 (`.config/wezterm/`)
- `wezterm.lua` — メイン設定 (フォント、カラー、透過、タブスタイル)
- `keybinds.lua` — キーバインド定義 (リーダーキー: Ctrl+G)。`wezterm.lua` から読み込み

### シェル構成
- `.zshrc` — エイリアス (`vi`/`vim` → `nvim`)、Starship と Sheldon の読み込み
- `.config/starship/starship.toml` — Gruvbox-dark テーマのプロンプト
- `.config/sheldon/plugins.toml` — zsh-autosuggestions, zsh-syntax-highlighting

## ドキュメント

`docs/` に各プラグインの日本語セットアップガイドを格納。`.agent/` にはガイド自動生成用のワークフローがある。

## 規約

- Neovim プラグインは `lua/plugins/` 配下にプラグインごとに個別ファイルで管理
- 対象開発スタック: React/TypeScript + Go
