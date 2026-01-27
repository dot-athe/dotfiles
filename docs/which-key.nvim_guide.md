# which-key.nvim セットアップガイド

## ドキュメント
- [GitHub Repository](https://github.com/folke/which-key.nvim)

## 概要
**which-key.nvim** は、NeoVim のキーバインドをポップアップで可視化するプラグインです。
リーダーキー（スペースなど）を押した後に「次にどのキーが押せるか」を表示してくれるため、ショートカットを丸暗記する必要がなくなります。v3からは設定方法がより柔軟になりました。

## 前提条件
- **NeoVim Version**: `v0.9.0` 以上 (推奨)
- **Lazy.nvim**: プラグインマネージャー
- **Nerd Font**: アイコン表示のために推奨

## 設定例 (lazy.nvim)
`lua/plugins/which-key.lua` を作成し、以下のコードを記述します。

```lua
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    -- ここにオプション設定を記述 (デフォルトで十分ですが、カスタマイズも可能)
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
```

## キーバインドの登録 (v3 Spec)
`which-key` 自体の設定とは別に、他のプラグインや自分のキー設定に `desc` (説明) を追加するだけで、自動的に表示されます。

```lua
-- 例: 通常のキーマップ設定
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save File" })
```

グループ化（階層化）を行いたい場合は、`which-key` の `spec` を使用して以下のように設定できます。

```lua
-- lua/plugins/which-key.lua の opts.spec に追加するか、
-- require("which-key").add() を使用します

local wk = require("which-key")
wk.add({
  { "<leader>f", group = "File" }, -- グループ名定義
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
  { "<leader>fn", desc = "New File" },
  
  -- ネストした定義も可能
  {
    mode = { "n", "v" }, -- Normal & Visual mode
    { "<leader>q", "<cmd>q<cr>", desc = "Quit" },
    { "<leader>w", "<cmd>w<cr>", desc = "Write" },
  },
})
```

## トラブルシューティング
- **ポップアップが出ない**: `timeoutlen` の設定を確認してください（例：300ms）。
- **`checkhealth`**: 正常に動作しない場合は `:checkhealth which-key` を実行して診断してください。
