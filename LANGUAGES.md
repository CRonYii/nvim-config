# 语言支持与默认按键

## 组成

- Neovim 内置 LSP + `nvim-lspconfig`：连接语言服务，不搬旧的 `gd` / `gr` 映射。
- `mason.nvim`：安装外部语言服务器；`mason-lspconfig.nvim` 自动启用本机已安装的四种受支持服务器。
- `blink.cmp` 稳定版 v1：默认补全按键，使用 Lua 匹配器，避免本地编译或下载平台专用匹配器。
- `aerial.nvim`：从 LSP 获取代码大纲，保留插件窗口内的默认按键。
- 不安装自动格式化插件，不添加保存时格式化；LSP 自带的代码操作和原生手动格式化仍可使用。

## 每台机器自行选择语言工具

共享配置不强制安装全部工具，`ensure_installed = {}`。使用 `:Mason` 管理，或按需执行：

```vim
:MasonInstall pyright
:MasonInstall typescript-language-server
:MasonInstall clangd
:MasonInstall rust-analyzer
```

装完后重新打开相关项目文件。Mason 工具留在本机 data 目录，不复制到配置仓库。
`lazy-lock.json` 只锁定 Neovim 插件，**不锁定语言服务器版本**。
有严格复现要求时，可用 Mason 支持的 `package@version` 显式安装并记录版本。

| 语言 | Mason 包名 | LSP 配置名 | 项目注意事项 |
| --- | --- | --- | --- |
| Python | pyright | pyright | 需要 Node/npm 安装运行；Python 虚拟环境和项目依赖仍由项目管理 |
| JS/TS | typescript-language-server | ts_ls | 需要 Node/npm；正确的 package.json、tsconfig/jsconfig 有助于项目识别 |
| C/C++ | clangd | clangd | compile_commands.json 最完整；简单项目可用 compile_flags.txt，但不保证复杂项目准确性 |
| Rust | rust-analyzer | rust_analyzer | 通常从 Cargo.toml 识别项目；Rust 工具链、依赖及必要的 rust-src 需本机准备 |

不自动生成编译数据库，不修改项目配置，不自动安装 Rust/Python 项目依赖。
语言服务器本身可能索引项目、调用 Cargo 等项目工具；这不同于安装过程中运行测试。
工作机器的 cscope 需求仍保留，不强迫用 clangd 替代。

自动启用桥接仅识别 Mason 安装的工具。已有系统工具也可接入，但需本机配置显式启用相应 LSP；不要同时启动两份相同服务器。若仅想启用部分 Mason 服务，可在 `lua/config/local.lua` 返回：

```lua
return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = { automatic_enable = { "pyright", "ts_ls" } },
  },
}
```

## Neovim 原生 LSP 按键

在已连接并支持相关能力的语言服务器的文件中使用；未自定义旧的 `gd` / `gr`：

| 按键 | 操作 |
| --- | --- |
| `Ctrl-]` | 通过 LSP 的 tagfunc 跳到定义 |
| `Ctrl-T` | 返回标签跳转前的位置 |
| `K` | 悬浮文档 |
| `grr` | 引用 |
| `grn` | 重命名 |
| `gra` | 代码操作 |
| `gri` | 实现 |
| `grt` | 类型定义 |
| `gO` | 当前文件符号列表 |
| `[d` / `]d` | 上一个/下一个诊断 |
| 插入模式 `Ctrl-S` | 函数参数提示（部分终端可能被流控拦截） |

`grr` 等按键是依次输入，不是同时按。`空格 ?` 可查看已注册按键说明。

## blink.cmp 默认补全按键

插入模式中：

- `Ctrl-N` / `Ctrl-P` 或上下方向键：选择候选。
- `Ctrl-Y`：确认候选。
- `Ctrl-E`：关闭/取消补全。
- `Ctrl-Space`：显示菜单、显示/隐藏文档；若被本地输入法拦截，可先用自动弹出的菜单。
- `Ctrl-B` / `Ctrl-F`：滚动补全文档。
- `Tab` / `Shift-Tab`：在活动代码片段内跳转占位符，否则回落到原本行为；不是 Tab 接受补全。
- 回车仍用于换行，不改成接受补全。

正常模式 Ctrl-P 仍然是文件搜索。blink 默认也提供命令行补全，命令行 Tab 用于打开/切换候选。

## Aerial 代码大纲

Aerial 没有统一的默认全局打开键，因此仅额外提供一个菜单入口：

- `空格 c o` / `:AerialToggle`：打开/关闭大纲并进入侧栏。
- 侧栏内 `j/k` 移动，回车跳转，`q` 关闭，`?` 查看插件默认按键。
- 使用 LSP 后端，未连接语言服务或服务不提供符号时可能没有大纲。
- 不覆盖普通编辑区的 `{`、`}`、`gd`、`gr` 等原生操作。
