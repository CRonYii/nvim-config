# Git 迁移与本机定制

共享配置、`after/plugin/indent.lua`、`examples/local.lua` 和 `lazy-lock.json` 应纳入 Git；程序、插件目录和本机设置不随仓库分发。功能说明仍见 `README.md`；安装和迁移以本文为准：入口现在会在缺少 lazy.nvim 时从 GitHub 引导安装，不必另行手工克隆它。

也可将仓库 URL 交给目标机器上的 Agent，要求它先阅读 [AGENTS.md](AGENTS.md)，按本文执行依赖准备和安全部署。

## 依赖与路径

- 当前环境使用 Neovim **0.12.6**。迁移时优先使用相同版本；没有验证更早版本与这些锁定插件的兼容性。lazy.nvim 自身的最低要求不代表整套配置的最低要求。更换 Neovim 版本后请自行检查功能。
- 自行安装 Neovim（例如 GitHub 官方 Release 中适合目标系统/架构的发行包），并让 `nvim` 位于 `PATH`；不要把程序或安装包提交到配置仓库。不要求沿用原机器的安装目录。
- `git`（2.31+，满足 Diffview 要求）、`rg`（ripgrep）、`fzf`（> 0.36；当前使用 0.44.1）应位于 `PATH`。前者用于引导、插件管理和 Git 功能，后两者用于现有搜索功能。需要能访问 GitHub；代理/证书由目标机器自行配置。
- 已集成 Python、JS/TS、C/C++、Rust 的 LSP、补全和大纲。语言服务器仍按机器选装，共享配置不自动下载全套工具。安装方法与 Node/npm、项目工具链要求见 [LANGUAGES.md](LANGUAGES.md)。不自动安装系统依赖，不使用 sudo。
- 图标需要在**终端客户端**选择 Nerd Font。SSH 使用时是本地终端的字体，不需要在远端服务器安装字体。

入口使用 `stdpath("config")` 和 `stdpath("data")`，不包含用户名或机器名判断。默认 Linux 配置目录为 `${XDG_CONFIG_HOME:-$HOME/.config}/${NVIM_APPNAME:-nvim}`；插件位于 `stdpath("data") .. "/lazy"`。Neovim 的数据、状态和缓存遵循 XDG 环境及 `NVIM_APPNAME`。更改这些变量时，部署命令和后续启动必须使用同一环境。

本仓库独立于旧 Vim，不读取或修改 `~/.vimrc`、`~/.vim/`。

## 将共享配置纳入 Git（由用户操作）

尚无仓库时，在**实际配置目录**中操作，而不是在迁移工作快照中提交：

```bash
cd "${XDG_CONFIG_HOME:-$HOME/.config}/${NVIM_APPNAME:-nvim}"
git init
git add .gitignore init.lua lua/plugins after/plugin/indent.lua \
  lazy-lock.json AGENTS.md README.md PORTABILITY.md LANGUAGES.md examples/local.lua
git diff --cached
# Confirm the staged files and your real Git identity before committing.
git commit -m "chore(nvim): track portable configuration"
```

已有仓库则跳过 `git init`，按实际改动挑选暂存文件。不要强制添加被忽略的本机文件。提交身份使用你自己的真实 Git 设置；本文不设置全局身份。远端创建、可见性和发布由你另行决定，本次准备不创建或推送远端。迁移源可以是你自行准备的 GitHub 仓库，也可以是目标机可访问的本地 Git 仓库。

## 在目标机部署：先备份，后克隆

先自行安装依赖。下面是 Bash 命令，**先替换 `repo`**。备份目录使用唯一名称；不删除现有配置，不覆盖旧插件目录，也不改 shell 启动文件。

```bash
(
  set -eu
  repo='https://github.com/YOUR_ACCOUNT/YOUR_NVIM_REPO.git'
  # Alternatively: repo='/path/to/an/accessible/local/repository'
  config="${XDG_CONFIG_HOME:-$HOME/.config}/${NVIM_APPNAME:-nvim}"
  mkdir -p -- "$(dirname -- "$config")"
  if [ -e "$config" ] || [ -L "$config" ]; then
    backup=$(mktemp -d "${config}.backup.XXXXXXXX")
    mv -- "$config" "$backup/config"
    printf 'Previous config saved to %s/config\n' "$backup"
  fi
  git clone -- "$repo" "$config"
)
```

如果克隆失败，备份仍在输出的目录中；先排查网络/权限，保留或移开失败克隆产生的目录，再重试。需要回退时，先退出 Neovim，把新配置移到另一位置保留，再将备份中的 `config` 移回原配置路径；不要向已存在的目录直接覆盖复制。

随后正常启动：

```bash
nvim
```

首次启动会克隆 lazy.nvim 的 `stable` 分支，然后 lazy.nvim 可能下载缺少的插件。这不是离线安装，也不会自动安装系统依赖。若引导失败，入口会显示英文错误和 Git 输出并停止插件配置，不会在同一次启动中循环重试。可在 `:messages` 查看错误。按提示检查 GitHub 访问、Git 和权限；如有不完整的 lazy.nvim 目录，先退出 Neovim，将其移开保留，然后手动重启。路径可用 `:lua print(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")` 查看。

首次安装任务完成后执行：

```vim
:Lazy restore
```

等待恢复完成，再退出并重启 Neovim，让恢复后的插件代码生效。`lazy-lock.json` 是共享版本依据；引导时下载的 lazy.nvim 本身也应通过恢复回到锁定版本。不要将首次拉取 `stable` 分支理解为已经精确锁定插件管理器。

已有插件数据不会被部署命令清空；相同 `NVIM_APPNAME` 会继续使用相同数据路径。想与目标机已有配置/插件完全隔离时，可在当前 shell 先执行 `export NVIM_APPNAME=nvim-migrated`，再运行部署和启动命令；不必修改 shell 启动文件。

## 更新与锁定版本恢复

拉取共享配置前退出 Neovim，在配置仓库确认没有未处理的本地改动，然后：

```bash
cd "${XDG_CONFIG_HOME:-$HOME/.config}/${NVIM_APPNAME:-nvim}"
git status --short
git pull --ff-only
nvim
```

若有未提交改动，先自行提交/保留并处理，不使用强制 reset 或清理命令。启动后等待缺失插件安装完成，运行 `:Lazy restore` 并重启。这用于按照**当前仓库锁文件**恢复已有 specs 对应的插件提交；新引入的插件只有在锁文件含有其记录时才有共享版本保证。

主动升级插件是另一件事：手动 `:Lazy update`，尝试功能，再审查 `git diff -- lazy-lock.json` 并提交有意的锁文件变化。当前配置不启用自动更新检查。**`:Lazy sync` 会包含更新操作，不是冻结版本的方法**；不要把它作为锁定恢复命令。

想退回历史插件版本时，先选择一个已知可用的配置提交（共享 specs 和锁文件应配套），再执行 `:Lazy restore`、退出并重启；仅切换 Git 配置不会自动回退磁盘里的插件。

## 不跟踪的本机设置与插件 specs

创建本机入口（已有文件时不要覆盖）：

```bash
cd "${XDG_CONFIG_HOME:-$HOME/.config}/${NVIM_APPNAME:-nvim}"
mkdir -p lua/config
if [ ! -e lua/config/local.lua ] && [ ! -L lua/config/local.lua ]; then
  cp examples/local.lua lua/config/local.lua
fi
```

`lua/config/local.lua` 被忽略；示例关闭本机鼠标并把文件树宽度设为 36。请按需修改。文件不存在时正常使用共享默认值；存在时通过 `require("config.local")` 执行，语法和运行错误会直接报告，不会被当作“缺失”忽略。

本机入口在共享基础选项之后、lazy.nvim setup 之前执行，必须返回 lazy.nvim spec 列表；只改选项时返回 `{}`：

```lua
vim.opt.mouse = ""
return {}
```

返回的 specs 放在共享 `plugins` 导入之后，按 lazy.nvim 规则合并，可以覆盖插件的 `opts` 或添加本机插件。插件自身稍后执行的配置、文件类型设置仍可能覆盖普通选项；需要调整插件时优先使用其 spec/opts。不要把私有插件文件放入会自动导入且受 Git 跟踪的 `lua/plugins/`。

较大的本机功能可放在被忽略的 `lua/local_only/` 下，例如在本机入口中 `return require("local_only.plugins")`，让该模块返回 spec 列表。这个目录**不会自动加载**，仅通过本机入口显式引用。使用 `vim.env`、`vim.fn.expand("~")` 或 `stdpath()` 表达本机路径，避免在共享文件中写机器名分支或绝对用户路径。

本机插件仍共用 lazy.nvim 的锁文件：有意安装/更新它们可能在 `lazy-lock.json` 中增加本机条目；忽略本机 specs 不等于忽略锁文件变化。提交前审查锁文件，只保留准备共享的条目/变更，不要泄露私有插件信息或丢弃原有共享 pins。本机插件如需锁定，可另行私下备份其提交记录；不会随共享仓库自动迁移。迁移本机入口及辅助模块也需你单独备份/传输，不由 Git 克隆完成。

### 未来的可选 cscope

cscope 是其他机器上大型 C 库的真实后续需求，特别是难以生成 `compile_commands.json` 时。**当前没有实现或安装 cscope 集成**。将来可以先在 `lua/config/local.lua` 返回 opt-in 插件 spec，并将相应本机模块放入 `lua/local_only/`；经确认需要共享时再单独评估纳入共享模块。不要现在就加入未知插件或假装已有查询快捷键。

cscope 程序由目标机自行安装，数据库在对应项目按需生成；`cscope.out`、`cscope.in.out`、`cscope.po.out`、`cscope.files` 和 `compile_commands.json` 不打包进配置仓库。不要复制旧 Vim 插件缓存来替代明确的插件 spec。

## 手动验收清单（本次未执行）

- [ ] 检查暂存内容：只含共享源码、文档和锁文件，没有 `.pi`、本机入口、二进制、插件缓存或索引数据库。
- [ ] 在目标机确认 `nvim`、`git`、`rg`、`fzf` 可用，终端图标字体符合需要。
- [ ] 确认原配置备份位置；正常启动，无本机入口时没有相关报错。
- [ ] 首次安装结束后运行 `:Lazy restore`，重启，确认锁文件没有意外版本变化。
- [ ] 手动尝试 README 所述功能：文件树、文件/全文搜索、Git 视图、英文快捷键提示、配色状态栏、缩进、自动保存、多词高亮；按需安装语言服务器后体验补全和大纲。
- [ ] 复制本机示例后重启，确认鼠标/树宽覆盖；移开本机入口后重启，确认回到共享设置。
- [ ] 提交前确认本机配置未被跟踪，锁文件不包含不准备共享的本机插件变化。

本次准备只改配置和文档；没有运行测试、lint、health check、smoke launch，也没有安装或更新插件。上述命令与清单均留给用户手动执行。
