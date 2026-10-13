# Neovim：逐项迁移

此配置独立于 `~/.vimrc` 和 `~/.vim/`，不会加载旧 Vim 插件。

## 让 Agent 在新机器安装

将仓库 URL 和这段话交给目标机器上的 Agent：

> 请安装这套 Neovim 配置：https://github.com/CRonYii/nvim-config 。先阅读仓库根目录 AGENTS.md、PORTABILITY.md 和 LANGUAGES.md，按这台机器的环境准备依赖并部署。保留旧 Vim，已有 Neovim 配置先备份；恢复锁定插件版本，语言服务器按需确认。不擅自提权、上传或运行测试，完成后告诉我启动方式和需要手工处理的事项。

公开仓库：[CRonYii/nvim-config](https://github.com/CRonYii/nvim-config)。目标 Agent 需要能访问 GitHub。
平台或项目依赖不兼容时由 Agent 说明并协商，不承诺任意机器无条件可用。

## 已确认

- `F3`：nvim-tree 文件树；回车打开目录或文件，`g?` 查看操作帮助。
- `Ctrl-P`：fzf-lua 文件名模糊搜索；输入文件名，方向键选择，回车打开，Esc 退出。
- 普通模式依次按 `空格`、`/`：项目全文搜索，输入文字实时显示结果和预览，回车跳转，Esc 退出。
- 原生 `/文字`（当前文件搜索）、`fa`（本行跳到下一个 a）保持不变。
- 普通 `/` 搜索启用智能大小写：全小写查询忽略大小写，含大写字母时区分大小写。
- 文件搜索和全文搜索以当前工作目录为范围。建议先 `cd 项目目录` 再 `nvim`；默认跳过隐藏文件和 Git 忽略的文件。
- 使用现有系统 fzf 和 rg；已启用 nvim-web-devicons 彩色图标，本地终端需选择 Nerd Font。
- 沿用行号、鼠标、向右分屏；固定显示标记列，避免 Git 标记出现时文字左右跳动。
- 开启 `wrap`：长行在窗口内自动折行显示，不向文件插入换行。
- 开启 `cursorline`，当前行高亮跟随 VS Code 主题，不沿用旧的亮绿色覆盖。
- `scrolloff = 3`：滚动时尽量在光标上下各保留 3 行上下文。
- 开启 `confirm`：普通退出遇到未保存修改时提供保存/放弃/取消选项，`:q!` 仍为强制退出。

## 配色：VS Code 深色

使用 `vscode.nvim`，深色不透明背景，启用终端真彩色。
延续旧 Code Dark 风格；主题在其他界面插件之前加载。

## 状态栏：lualine

使用 VS Code 配套配色，整屏底部只显示一条状态栏，随当前窗口切换。
显示模式、Git 分支、相对文件路径、未保存标记 `[+]`、文件类型、行列位置。
不显示编码、换行格式、进度或诊断统计。

## 快捷键提示：which-key

- 普通模式按 `空格`，停顿约 0.3 秒，显示快捷操作菜单。
- 再按 `g`，显示 Git 分组；熟悉后仍可连续按键，不必等待菜单。
- `空格 ?`：查看普通模式快捷键总览，包括 F3、Ctrl-P 等映射。
- 提示窗口中 `Esc` 退出，退格返回上一级，Ctrl-D / Ctrl-U 滚动。
- 快捷键说明、分组和按键标签统一使用英文。

## 分屏：空格 w

通过 which-key 代理原生 Ctrl-W 操作；原生 Ctrl-W 保留，不绑定 Alt 组合键。
普通模式按 `空格 w` 显示英文窗口菜单：

- `v`：左右分屏；`s`：上下分屏。
- `h/j/k/l`：切换到左/下/上/右窗口；`w`：轮流切换窗口。
- `=`：均分窗口尺寸。
- `q`：关闭当前窗口；若是最后一个窗口，会尝试退出 Neovim，未保存修改仍受原生保护。
- 分屏后用 Ctrl-P 在当前窗口打开另一个文件。

## Git：Gitsigns + Diffview

普通模式依次按下以下按键，无需同时按：

- `空格 g d`：打开项目差异视图，左侧选择文件，回车查看；Tab / Shift-Tab 切换文件。
- `空格 g p`：预览光标所在的改动块。
- `空格 g b`：弹窗查看当前行 blame 和提交信息。
- `空格 g h`：查看当前文件提交历史，回车展开/选择条目。
- `空格 g q`：关闭差异或历史视图；在视图中也可以按 `q`。
- 编辑 Git 仓库内的文件时，边栏自动显示改动标记。blame 按需弹出，不常驻行尾。
- 不绑定 F4/F5/F6；不安装 LazyGit。暂存、取消暂存、恢复文件的 Diffview 面板默认快捷键已禁用。
- 这不是只读沙箱：Diffview 中的工作区文件仍可编辑。提交等操作暂时继续使用终端 Git。

## 缩进：项目规则优先

使用 Neovim 内置 EditorConfig 支持，不额外安装插件。
先应用语言默认值，再由项目 `.editorconfig` 中明确配置的属性覆盖：

- Python、Rust、C/C++：4 空格。
- JS/JSX、TS/TSX、JSON/JSONC、YAML：2 空格。
- Makefile：真实 Tab，显示宽度为 8。
- 其他文件类型维持 Neovim/文件类型插件的默认设置。

不运行格式化或 Tab/空格转换，不自动推断已有文件的缩进。
项目未提供规则且风格不同的文件，可以手动 `:setlocal` 调整。
EditorConfig 的其他属性（如保存时清理行尾空格）也由内置支持遵守。

## 自动保存：接近旧版行为

- 默认启用；退出插入模式或普通模式修改后，延迟 500 毫秒保存触发事件的文件。
- 重新进入插入模式会取消该文件的待保存任务；插入模式中停顿不会触发保存。
- `空格 u a` 开关自动保存并显示英文状态提示；也可使用插件命令 `:ASToggle`。
- 开关只影响当前进程，重开 Neovim 默认启用。插件关闭前已排队的保存仍可能在约 500 毫秒内完成。
- 仅保存已有且可写的普通文件；跳过只读文件、特殊缓冲区、Git 提交消息和 rebase 编辑。
- 新文件第一次用 `:w` 保存；之后自动保存。不会强制保存所有缓冲区，也不在退出/失焦时额外保存。
- 不添加自动格式化，但保留正常保存事件，例如项目 EditorConfig 的行尾空格清理。
- `u` 仍可撤销；`:q!` 无法撤回已经保存到磁盘的修改。
- 使用 `okuuva/auto-save.nvim`，不自行实现保存调度。

## 多关键词高亮：vim-interestingwords

沿用旧插件，在 Neovim 的插件目录独立安装，关闭插件自带快捷键。

- `空格 m m`：标记或取消光标下的单词，可同时用不同颜色标记多个词（6 色）。
- `空格 m c`：清除全部关键词标记。
- 光标在已标记词上时，`空格 m n` / `空格 m p`：跳到该词的下一处/上一处。
- 原生 `/`、`n`、`N` 保持不变；高亮是视觉辅助，不修改文件内容。

## 持久化撤销

启用原生 `undofile`，保存时写入撤销历史，重新打开文件时恢复。
使用默认本机状态目录（Linux 通常为 `~/.local/state/nvim/undo/`），不存进配置仓库。
`u` 撤销、`Ctrl-R` 重做；这不是备份，不保证恢复被外部工具改写后的历史。
敏感文件可在保存前 `:setlocal noundofile`，但这不会删除已有撤销文件。

## 语言支持与代码大纲

采用原生 LSP + nvim-lspconfig、Mason、blink.cmp v1 和 Aerial。
支持 Python（Pyright）、JS/TS、C/C++（clangd）、Rust（rust-analyzer），按机器安装工具，不强制全装。
保留 Neovim LSP 和 blink 默认按键，不搬旧的 gd/gr；仅增加 `空格 c o` 打开大纲。
安装方法、依赖和按键表见 [LANGUAGES.md](LANGUAGES.md)。不配置保存时格式化。

## 已决定不迁移

- 旧 F7 / DiffSaved：与磁盘已保存版本比较；自动保存开启后用途较少，日常使用 Git 差异视图。
- 启动页（vim-startify）：保留当前启动体验，不安装 dashboard。
- 旧 `selection=exclusive`、`selectmode=mouse,key`：改用 Neovim 默认选择行为，Visual 选区包含末尾字符。
- 旧 `showmatch`/`matchtime`：保留 Neovim 默认匹配括号高亮，不增加输入时的短暂跳转。
- Denite、CtrlPTag 的残留配置、重复映射和旧 fzf runtimepath：不迁移。
- `nocompatible`、文件类型/语法启用、`autoread`、命令补全菜单等沿用 Neovim 默认设置；缩进由已配置的语言默认值及项目 EditorConfig 处理，不照搬重复的 smartindent。

## 留待工作机器配置

cscope 保留为工作机器可选功能：用于难以生成 compile_commands.json 的 C 库，当前机器暂不启用。

## 文件位置

- 程序：`~/.local/opt/nvim-0.12.6/`
- 启动链接：`~/.local/bin/nvim`
- 入口：`~/.config/nvim/init.lua`
- 导航插件配置：`~/.config/nvim/lua/plugins/navigation.lua`
- Git 插件配置：`~/.config/nvim/lua/plugins/git.lua`
- 快捷键提示配置：`~/.config/nvim/lua/plugins/which-key.lua`
- 主题配置：`~/.config/nvim/lua/plugins/colorscheme.lua`
- 状态栏配置：`~/.config/nvim/lua/plugins/statusline.lua`
- 缩进配置：`~/.config/nvim/after/plugin/indent.lua`
- 自动保存配置：`~/.config/nvim/lua/plugins/autosave.lua`
- 多关键词高亮配置：`~/.config/nvim/lua/plugins/highlights.lua`
- 语言支持与大纲配置：`~/.config/nvim/lua/plugins/languages.lua`
- 插件版本锁：`~/.config/nvim/lazy-lock.json`
- 插件目录：`~/.local/share/nvim/lazy/`

插件管理使用 lazy.nvim（不是 LazyVim 整套配置）。`:Lazy` 查看插件，
`:Lazy restore` 恢复锁定版本；不会自动检查或更新插件。
迁移指南见 [PORTABILITY.md](PORTABILITY.md)。目标机器安装 Neovim、fzf、rg、git；lazy.nvim 缺失时会自动引导安装。
本机覆盖文件 `lua/config/local.lua` 不进 Git，示例见 `examples/local.lua`。
配置仓库：https://github.com/CRonYii/nvim-config ，默认分支为 `main`。
