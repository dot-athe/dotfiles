#!/bin/bash

# 定数定義
DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/backup"

echo "開始: dotfiles セットアップ"

# バックアップディレクトリの作成
if [ ! -d "$BACKUP_DIR" ]; then
    echo "作成: バックアップディレクトリ ($BACKUP_DIR)"
    mkdir -p "$BACKUP_DIR"
fi

# .zshrc の処理
echo "処理中: .zshrc"
if [ -f "$HOME/.zshrc" ]; then
    echo "バックアップ: $HOME/.zshrc -> $BACKUP_DIR/"
    cp "$HOME/.zshrc" "$BACKUP_DIR/"
    rm "$HOME/.zshrc"
fi

echo "シンボリックリンク作成: $HOME/.zshrc -> $DOTFILES_DIR/.zshrc"
ln -s "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# .config 配下のディレクトリ処理
echo "処理中: .config ディレクトリ"
if [ ! -d "$HOME/.config" ]; then
    mkdir -p "$HOME/.config"
fi

for config_dir in "$DOTFILES_DIR/.config"/*; do
    dir_name=$(basename "$config_dir")
    target_config="$HOME/.config/$dir_name"

    echo "処理中: .config/$dir_name"

    # 既存の設定があればバックアップして削除
    if [ -d "$target_config" ]; then
        echo "バックアップ: $target_config -> $BACKUP_DIR/"
        cp -r "$target_config" "$BACKUP_DIR/"
        rm -rf "$target_config"
    fi

    # シンボリックリンク作成
    echo "シンボリックリンク作成: $target_config -> $config_dir"
    ln -s "$config_dir" "$target_config"
done

echo "完了: dotfiles セットアップが完了しました。"
