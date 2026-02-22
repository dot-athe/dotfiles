# nvim-autopairs セットアップガイド

## ドキュメント
- [GitHub Repository](https://github.com/windwp/nvim-autopairs)

## 概要
**nvim-autopairs** は、括弧 `()` `[]` `{}` や引用府 `""` `''` などを自動的に閉じるためのプラグインです。
入力時に自動でペアを挿入するだけでなく、Enterキーを押した際に適切に改行とインデントを行う機能などを提供します。

## 前提条件
- **NeoVim Version**: `v0.7.0` 以上
- **Lazy.nvim**: プラグインマネージャー
- **nvim-cmp** (推奨): 補完確定時の挙動と連携するために推奨されます。

## 設定例 (lazy.nvim)
`lua/plugins/nvim-autopairs.lua` を作成し、以下のコードを記述します。

```lua
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = true,
  -- または詳細設定をする場合:
  -- config = function()
  --   require("nvim-autopairs").setup({})
  -- end
}
```

### nvim-cmp との連携（推奨）
補完ウィンドウが出ている状態でアイテムを選択（Enter）した際に、自動的に括弧を追加したりする機能です。
これは `nvim-cmp` の設定ファイル側（例: `lua/plugins/completion.lua` など）に記述する必要があります。

```lua
-- nvim-cmp の config 内に追加する設定例
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
```

## 基本機能
特別なキー操作は必要ありません。インサートモードでの入力時に自動的に動作します。

- **ペアの自動挿入**: `(` を入力すると `()` になりカーソルが中に移動。
- **ペアの削除**: `()` の状態でバックスペースを押すと両方消える。
- **Fast Wrap**: 既に書かれているテキストを括弧で囲みたい場合に便利な機能（デフォルトで `<M-e>` などに割り当て可能）。

## トラブルシューティング
- **Treesitter連携**: Treesitterのノード判定を使って、コメント内ではペアを無効にするなどの設定が可能です。
  ```lua
  require("nvim-autopairs").setup({
    check_ts = true,
  })
  ```
