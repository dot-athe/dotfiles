local wezterm = require 'wezterm'
local act = wezterm.action

return {
  keys = {
    -- ================ タブ操作 ================ 
    -- タブ切替
    { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
    { key = 'Tab', mods = 'SHIFT|CTRL', action = act.ActivateTabRelative(-1) },
    { key = '1', mods = 'SUPER', action = act.ActivateTab(0) },
    { key = '2', mods = 'SUPER', action = act.ActivateTab(1) },
    { key = '3', mods = 'SUPER', action = act.ActivateTab(2) },
    { key = '4', mods = 'SUPER', action = act.ActivateTab(3) },
    { key = '5', mods = 'SUPER', action = act.ActivateTab(4) },
    { key = '6', mods = 'SUPER', action = act.ActivateTab(5) },
    { key = '7', mods = 'SUPER', action = act.ActivateTab(6) },
    { key = '8', mods = 'SUPER', action = act.ActivateTab(7) },
    { key = '9', mods = 'SUPER', action = act.ActivateTab(-1) },
    -- タブを閉じる
    { key = 'w', mods = 'CTRL', action = act.CloseCurrentTab{ confirm = true } },
    { key = 'w', mods = 'SUPER', action = act.CloseCurrentTab{ confirm = true } },
    -- タブ新規作成
    { key = 't', mods = 'SUPER', action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 't', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain' },


    -- =============== Pane操作 ===============
    -- Pane分割
    { key = '-', mods = 'LEADER', action = act.SplitVertical{ domain =  'CurrentPaneDomain' } },
    { key = '\\', mods = 'LEADER', action = act.SplitHorizontal{ domain =  'CurrentPaneDomain' } },
    -- Pane移動
    { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection("Left") },
    { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection("Down") },
    { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection("Up") },
    { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection("Right") },
    -- Pane拡大・縮小
    { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
    -- Paneのりサイズ
    { key = 'p', mods = 'LEADER', action = act.ActivateKeyTable({ 
        name = 'resize_pane', one_shot = false 
    }) },

    -- =============== コピぺ操作 ===============
    -- コピーモード起動
    { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
    -- コピペ
    { key = 'c', mods = 'SUPER', action = act.CopyTo 'Clipboard' },
    { key = 'v', mods = 'SUPER', action = act.PasteFrom 'Clipboard' },

    -- =============== その他 ===============
    -- フルスクリーン
    { key = 'Enter', mods = 'ALT', action = act.ToggleFullScreen },
    -- アプリケーション終了
    { key = 'q', mods = 'SUPER', action = act.QuitApplication },
    -- コマンドパレット表示
    { key = 'p', mods = 'SHIFT|CTRL', action = act.ActivateCommandPalette },
    -- フォントサイズ変更
    { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
    { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
    -- ウィンドウ非表示
    { key = 'h', mods = 'SUPER', action = act.HideApplication },
    -- 新規ウィンドウ作成
    { key = 'n', mods = 'SUPER', action = act.SpawnWindow },
  },

  key_tables = {
    resize_pane = {
        { key = 'h', action = act.AdjustPaneSize({ 'Left', 1 }) },
        { key = 'j', action = act.AdjustPaneSize({ 'Down', 1 }) },
        { key = 'k', action = act.AdjustPaneSize({ 'Up', 1 }) },
        { key = 'l', action = act.AdjustPaneSize({ 'Right', 1 }) },

        { key = 'Enter', action = 'PopKeyTable' },
    },
    copy_mode = {
        -- 移動
        { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
        { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
        { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
        { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
        -- 最初と最後に移動
        { key = '^', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLineContent' },
        { key = '$', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
        -- 左端に移動
        { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },

        { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
        { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
        -- 単語ごとに移動
        { key = 'w', mods= 'NONE', action = act.CopyMode('MoveForwardWord') },
        { key = 'b', mods= 'NONE', action = act.CopyMode('MoveBackwardWord') },
        { key = 'e', mods= 'NONE', action = act.CopyMode('MoveForwardWordEnd') },
        -- 一番上へ
        { key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },
        { key = 'G', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom' },
        -- viewport
        { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
        { key = 'L', mods = 'NONE', action = act.CopyMode 'MoveToViewportBottom' },
        { key = 'M', mods = 'NONE', action = act.CopyMode 'MoveToViewportMiddle' },
        -- 範囲選択モード
        { key = 'v', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Cell' } },
        { key = 'v', mods = 'CTRL', action = act.CopyMode{ SetSelectionMode =  'Block' } },
        { key = 'V', mods = 'NONE', action = act.CopyMode{ SetSelectionMode =  'Line' } },
        -- コピー
        { key = 'y', mods = 'NONE', action = act.CopyTo('Clipboard') },
        -- コピーモードを終了
        {
          key = 'Enter',
          mods = 'NONE',
          action = act.Multiple({ 
              { CopyTo = 'ClipboardAndPrimarySelection' },
              { CopyMode = 'Close' },
          }),
        },
        { key = 'Escape', mods = 'NONE', action = act.CopyMode('Close') },
    },

    search_mode = {
      { key = 'Enter', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
      { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
      { key = 'n', mods = 'CTRL', action = act.CopyMode 'NextMatch' },
      { key = 'p', mods = 'CTRL', action = act.CopyMode 'PriorMatch' },
      { key = 'r', mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },
      { key = 'u', mods = 'CTRL', action = act.CopyMode 'ClearPattern' },
      { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PriorMatchPage' },
      { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'NextMatchPage' },
      { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
      { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },
    },

  }
}
