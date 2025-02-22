# Linux System Setup Script

This script automates the installation and configuration of various tools and dependencies on a Linux system. It is designed to install and set up common programming environments, utilities, and system configurations to get your development environment ready.

## Features

- **System Dependencies**: Installs essential development tools and libraries.
- **Programming Languages**: Installs and configures Rust, Lua, Node.js, Ruby, Go, Elixir, Perl, and more using `asdf`.
- **NeoVim & Alacritty**: Installs and configures NeoVim and Alacritty terminal emulator.
- **ZSH**: Configures ZSH as the default shell.
- **Symlinks**: Sets up symlinks for configuration files such as NeoVim, Alacritty, and fonts.

## Prerequisites

This script is designed for Linux systems and should work on most distributions, but it is optimized for Ubuntu-based systems. It has specific handling for WSL (Windows Subsystem for Linux).

1. **WSL (Optional)**: If running inside WSL, some actions (like installing Alacritty) will be skipped.
2. **Root Privileges**: Some actions, such as installing system-wide dependencies and modifying system configurations, require `sudo` privileges.
3. **Installed dependencies**: Ensure that you have `git`, `curl`, and `wget` installed for this script to work properly.

## How to Use

1. Clone repo on your system:

   ```bash
   git clone https://github.com/JoaoPedro61/dotfiles.git ~/.dotfiles -b v2
   ```

2. Enter in the folder:

   ```bash
   cd ~/.dotfiles
   ```

3. Make the script executable:

   ```bash
   chmod +x ./install
   ```

4. Run the script:

   ```bash
   ./install
   ```

5. Source custom env:
   Bash:

   ```bash
   echo '. ~/.dotfiles/user-env.bash' >> .bashrc
   ```

   ZSH:

   ```bash
   echo '. ~/.dotfiles/user-env.zsh' >> .zshrc
   ```

The script will:

- Install common development dependencies (e.g., `curl`, `git`, `python3`, etc.).
- Set up symlinks for NeoVim and Alacritty configurations.
- Install Rust, Lua, LuaRocks, and other programming tools.
- Install and configure `asdf` to manage multiple runtime versions.
- Install NeoVim and Alacritty, as well as set up completions for Alacritty.
- Change your default shell to ZSH if it is already installed.

### WSL-Specific Configuration

If the script detects that it is running inside a WSL environment, it will skip the installation of **Alacritty** since it is not typically used in WSL environments.

## Functions Overview

### 1. `setup_syslinks`

Sets up necessary symbolic links for configuration files and directories.

- **NeoVim**: Creates a symlink to the NeoVim config.
- **Alacritty**: Creates a symlink to the Alacritty config.
- **Fonts**: Sets up symlinks for the MesloLGS font.

### 2. `install_common_dependencies`

Installs a set of essential development dependencies:

- `build-essential`, `curl`, `wget`, `git`, `python3`, `zsh`, `htop`, etc.

### 3. `install_rust_lang`

Installs the Rust programming language using the official installer (`rustup`).

### 4. `install_lua_lang`

Installs Lua (version 5.4.7) from source.

### 5. `install_luarocks`

Installs LuaRocks, the package manager for Lua modules.

### 6. `install_asdf`

Installs `asdf`, a version manager for various programming languages, and sets up plugins for Node.js, Ruby, Go, Elixir, and Perl.

### 7. `install_neovim`

Installs NeoVim (v0.10.2) from a precompiled tarball and sets it up for Ruby and Node.js integrations.

### 8. `install_alacritty`

Installs **Alacritty** terminal emulator from source (skipped if running in WSL). The script also installs the necessary completions for ZSH and Bash.

### 9. `setup_zsh`

Checks if **ZSH** is installed, and if it is, sets it as the default shell.

## Customization

You can modify the script to suit your preferences:

- **Change versions**: Modify the version variables (e.g., for NeoVim, Rust, Lua) to install specific versions.
- **Add or remove dependencies**: You can add or remove dependencies in the `install_common_dependencies` function as needed.
- **WSL handling**: If you're using WSL and want to install Alacritty or make other adjustments, you can modify the WSL-specific checks.

## Troubleshooting

If the script fails or something isn't working as expected:

1. Check the script's output for error messages. The `set -e` command ensures that the script stops on errors, so you will know where it failed.
2. Ensure that your system has all required tools like `curl`, `git`, and `wget` installed.
3. If a package installation fails (e.g., `apt` or `cargo`), try manually installing the package and rerunning the script.

Claro! Aqui está a seção adicional para o **README** sobre a instalação manual e configuração dos mesmos programas e ferramentas que o script automatiza:

---

## Instalação Manual e Configuração

Embora o script automatize o processo de instalação e configuração, você pode preferir realizar a instalação manualmente ou configurar certos aspectos de maneira personalizada. Abaixo está o passo a passo para instalar e configurar cada ferramenta e dependência manualmente.

### 1. **Instalar Dependências Comuns**

Para instalar as dependências comuns necessárias para o desenvolvimento, execute o seguinte comando para instalar as ferramentas essenciais:

```bash
sudo apt update
sudo apt install -y build-essential curl wget git python3 python3-pip python3-dev python3-neovim libreadline-dev unzip cmake g++ pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev scdoc htop coreutils fd-find ripgrep zsh libz-dev libssl-dev libffi-dev libyaml-dev
```

### 2. **Instalar Rust**

Rust é instalado usando o `rustup`, o instalador oficial que configura o ambiente do Rust no seu sistema.

1. Execute o comando abaixo para baixar e instalar o `rustup`:

   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
   ```

2. Após a instalação, adicione o caminho do Rust ao seu shell (ZSH ou Bash):

   ```bash
   source $HOME/.cargo/env
   ```

3. Verifique a instalação do Rust:

   ```bash
   rustc --version
   ```

### 3. **Instalar Lua**

Para instalar o Lua manualmente, faça o seguinte:

1. Baixe o código-fonte do Lua:

   ```bash
   curl -R -O https://www.lua.org/ftp/lua-5.4.7.tar.gz
   ```

2. Extraia e compile o Lua:

   ```bash
   tar -zxvf lua-5.4.7.tar.gz
   cd lua-5.4.7
   make linux
   sudo make install
   ```

3. Verifique se o Lua foi instalado corretamente:

   ```bash
   lua -v
   ```

### 4. **Instalar LuaRocks**

O LuaRocks é o gerenciador de pacotes para Lua. Para instalar:

1. Baixe o código-fonte do LuaRocks:

   ```bash
   curl -R -O https://luarocks.github.io/luarocks/releases/luarocks-3.11.1.tar.gz
   ```

2. Extraia e compile:

   ```bash
   tar -zxvf luarocks-3.11.1.tar.gz
   cd luarocks-3.11.1
   ./configure --with-lua-include=/usr/local/include
   make
   sudo make install
   ```

3. Verifique a instalação:

   ```bash
   luarocks --version
   ```

### 5. **Instalar `asdf` (Version Manager)**

`asdf` é um gerenciador de versões universal para várias linguagens de programação. Para instalá-lo:

1. Clone o repositório do `asdf`:

   ```bash
   git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
   ```

2. Adicione o `asdf` ao seu shell (ZSH ou Bash):

   Adicione a linha abaixo ao arquivo de configuração do seu shell (`~/.bashrc` ou `~/.zshrc`):

   ```bash
   . $HOME/.asdf/asdf.sh
   ```

3. Instale os plugins de linguagem com o comando `asdf plugin add`:

   ```bash
   asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
   asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
   asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
   asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
   asdf plugin add perl https://github.com/ouest/asdf-perl.git
   ```

4. Instale as versões desejadas e defina-as como globais:

   ```bash
   asdf install nodejs latest
   asdf global nodejs latest
   asdf install ruby latest
   asdf global ruby latest
   ```

5. Verifique se o `asdf` está funcionando:

   ```bash
   asdf list
   ```

### 6. **Instalar NeoVim**

Para instalar o NeoVim manualmente:

1. Baixe o tarball do NeoVim:

   ```bash
   curl -LO https://github.com/neovim/neovim/releases/download/v0.10.2/nvim-linux64.tar.gz
   ```

2. Extraia e mova para o diretório desejado:

   ```bash
   tar -xvzf nvim-linux64.tar.gz
   mv nvim-linux64 ~/.nvim
   ```

3. Adicione o NeoVim ao seu caminho de execução:

   ```bash
   export PATH="$PATH:$HOME/.nvim/bin"
   ```

4. Verifique a instalação:

   ```bash
   nvim --version
   ```

### 7. **Instalar Alacritty**

Alacritty é um terminal acelerado por GPU. Para instalá-lo manualmente:

1. Clone o repositório do Alacritty:

   ```bash
   git clone https://github.com/alacritty/alacritty.git
   cd alacritty
   ```

2. Compile o Alacritty usando o Cargo (precisa ter o Rust instalado):

   ```bash
   cargo build --release
   ```

3. Copie o binário compilado para o diretório de binários do sistema:

   ```bash
   sudo cp target/release/alacritty /usr/local/bin
   ```

4. Instale as entradas de desktop e ícones:

   ```bash
   sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
   sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
   sudo desktop-file-install extra/linux/Alacritty.desktop
   sudo update-desktop-database
   ```

5. Verifique se o Alacritty foi instalado corretamente:

   ```bash
   alacritty --version
   ```

### 8. **Configurar ZSH como Shell Padrão**

Se você quiser configurar o ZSH como o shell padrão, siga as etapas abaixo:

1. Verifique se o ZSH está instalado:

   ```bash
   zsh --version
   ```

2. Se o ZSH não estiver instalado, instale-o:

   ```bash
   sudo apt install zsh
   ```

3. Para definir o ZSH como shell padrão, execute:

   ```bash
   sudo chsh -s $(which zsh)
   ```

4. Reinicie o terminal ou faça logout e login novamente para aplicar a mudança.

---

Essas etapas permitem que você configure manualmente seu ambiente de desenvolvimento com as mesmas ferramentas e dependências que o script automatiza. Se você encontrar algum erro ou desejar personalizar ainda mais a configuração, cada uma dessas ferramentas pode ser ajustada com base em suas necessidades.

## License

This script is open-source and licensed under the MIT License. Feel free to use, modify, and distribute it as needed.

---

With this setup, you'll have a productive development environment up and running quickly!
