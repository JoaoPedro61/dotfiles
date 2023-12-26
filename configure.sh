#!/bin/bash

# Path to script location
CDIR="$(
	cd -- "$(dirname "$0")" >/dev/null 2>&1
	pwd -P
)"

# Base package to instalation
# The key is the package name
# The value is the command
# ["PKG_NAME"]="CLI EXECUTABLE COMMAND"
declare -A BASE_PACKAGES=(
	["cmake"]="cmake",
	["python3.10-venv"]="python3.10",
	["build-essential"]="gcc",
	["git-all"]="git"
	["curl"]="curl",
	["libfontconfig1-dev"]="libfontconfig1-dev",
	["wget"]="wget",
	["ruby-full"]="gem",
)

# Base RCs files
declare -a RCS_FILES=(
	"bashrc"
	"zshrc"
)

declare -a NPM_PACKAGES=(
	"yarn"
	"typescript"
	"typescript-language-server"
	"bash-language-server"
	"azure-pipelines-language-server"
	"azure-pipelines-language-service"
	"vscode-langservers-extracted"
	"custom-elements-languageserver"
	"cssmodules-language-server"
	"@tailwindcss/language-server"
	"@angular/cli"
	"@angular/language-service"
	"@angular/language-server"
)

declare -a CARGO_PACKAGES=(
	"htmx-lsp"
	"fd-find"
	"ripgrep"
)

declare -a MIN_NVIM_VERSION=(0 9 4)

MIN_NVIM_VERSION_MSG="Minimum required NVIM version is v0.9.4"

##########################################################
### Utils functons #######################################
##########################################################

# Check if the content between two directories or files is
# changed
# Example:
#   if [ $(has_changes ./directory1 ./directory2) -eq true ]; then
#     echo "Has changes between the directories"
#   fi
has_changes() {
	if [ $(diff -r $1 $2 | wc -l) -gt 0 ]; then
		echo true
	else
		echo false
	fi
}

# Check if an executable is present in the current instalation
# Example:
#   if [ $(exists_exec node) -eq true ]; then
#     echo "Command node founded in this current instalation"
#   fi
exists_exec() {
	if [ $(command -v $1 | wc -l) -eq 0 ]; then
		echo false
	else
		echo true
	fi
}

##########################################################
### Instaltions functions ################################
##########################################################

# Install base packages
install_base_packages() {
	echo "[BASE]: Installing base packages..."

	for package_name in "${!BASE_PACKAGES[@]}"; do
		if [ $(exists_exec ${BASE_PACKAGES[${package_name}]}) = true ]; then
			echo "[BASE]: Package '$package_name' already installed. Skipping..."
		else
			echo "[BASE]: Installing package '$package_name'..."
			sudo apt install $package_name -y
		fi
	done
}

# Install NVM package
install_nvm_package() {
	echo "[NVM]: Installing NVM package:"
	if ! [ -d "$HOME/.nvm" ]; then
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
	else
		echo "[NVM]: Directory of NVM instalation found in '~/.nvm'. Skipping..."
	fi
}

# Install cargo and rust
install_rust_package() {
	echo "[RUST]: Installing rust..."

	if [ $(exists_exec cargo) = true ]; then
		echo "[RUST]: Appers that some rust tools already installed. Skipping..."
	else
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
	fi
}

# Install the latest stable version from neovim
install_nvim_package() {
	echo "[NVIM]: Installing NVIM package:"

	# go to home directory to download nvim files
	cd $HOME

	should_install_min_version=false
	already_installed=false

	if [ $(exists_exec nvim) = true ]; then
		already_installed=true
		version_str=$(nvim --version | grep -Po 'v\d+\.\d+\.\d+' | grep -Po '\d+\.\d+\.\d+')
		echo "[NVIM]: Detected a version of a nvim installed $version_str"
		version=(${version_str//./ })

		if [[ ${version[0]} -lt ${MIN_NVIM_VERSION[0]} ]]; then
			echo "[NVIM]: $MIN_NVIM_VERSION_MSG"
			should_install_min_version=true
		fi

		if [[ ${version[1]} -lt ${MIN_NVIM_VERSION[1]} ]]; then
			echo "[NVIM]: $MIN_NVIM_VERSION_MSG"
			should_install_min_version=true
		fi

		if [[ ${version[2]} -lt ${MIN_NVIM_VERSION[2]} ]]; then
			echo "[NVIM]: $MIN_NVIM_VERSION_MSG"
			should_install_min_version=true
		fi
	fi

	if [ -f $HOME/nvim-linux64.tar.gz -a $should_install_min_version = true ]; then
		echo "[NVIM]: Founded '~/nvim-linux64.tar.gz' file but don't match with the min required version..."
		rm $HOME/nvim-linux64.tar.gz
	fi

	if [ $already_installed = false -o $should_install_min_version = true ]; then
		echo "[NVIM]: Trying to install a NVIM with a min version required..."

		if ! [ -f $HOME/nvim-linux64.tar.gz ]; then
			wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
		else
			echo "[NVIM]: Founded '~/nvim-linux64.tar.gz' file. Skip download. Skipping..."
		fi

		if [ -f $HOME/nvim-linux64.tar.gz ]; then

			if [[ -d $HOME/.nvim ]]; then
				echo "[NVIM]: Deleting old NVIM instaled package..."
				rm -rf $HOME/.nvim
			fi

			echo "[NVIM]: Extracting the new NVIM package..."
			tar xzvf $HOME/nvim-linux64.tar.gz

			echo "[NVIM]: moving the new files to $HOME/.nvim"
			mv $HOME/nvim-linux64 $HOME/.nvim

			rm -rf $HOME/nvim-linux64.tar.gz
		else
			echo "[NVIM]: Can't find $HOME/nvim-linux64.tar.gz"
			echo "[NVIM]: Failed to download nvim-linux64.tar.gz"
		fi

	else
		echo "[NVIM]: Already installed a NVIM version with a min version required. Skipping..."
	fi

	# back to latest directory in use
	cd -
}

# Install node basic packages
install_node_packages() {
	if [ -f ~/.nvm/nvm.sh ]; then
		source ~/.nvm/nvm.sh
	fi

	nvm install --lts

	for package_name in "${NPM_PACKAGES[@]}"; do
		echo "[BASE]: Installing package '$package_name'..."
		npm install -g $package_name -y
	done
}

# Install alacritty package
install_alacritty_package() {
	echo "[ALACRITTY]: Installing alacritty"
	if [ $(exists_exec cargo) = true ]; then
		cargo install alacritty

		# Add desktop icon
		if [ $(exists_exec alacritty) = true -a $(exists_exec git) = true ]; then
			echo "[ALACRITTY]: Trying to add alacritty desktop icon..."
			cd /tmp
			git clone https://github.com/alacritty/alacritty.git
			if [ -d /tmp/alacritty ]; then
				cd /tmp/alacritty
				sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
				sudo desktop-file-install extra/linux/Alacritty.desktop
				sudo update-desktop-database
			fi
		fi
	else
		echo "[ALACRITTY]: No rust tools founded. Skipping..."
	fi
}

install_cargo_packages() {
	echo "[CARGO]: Installing packages..."
	if [ $(exists_exec cargo) = true ]; then
		for package_name in "${CARGO_PACKAGES[@]}"; do
			echo "[BASE]: Installing package '$package_name'..."
			cargo install $package_name
		done
	fi
}

##########################################################
### Configurations functions #############################
##########################################################

# Apply rc's files config
# !!! IMPORTANT !!!: Do not use symbolik link for rc's configs files.
apply_rcs_files_config() {
	echo "[RC]: Checking RC's files..."

	for file_name in "${RCS_FILES[@]}"; do
		proceed_with_replace() {
			echo "[RC]: Apply new changes to .$file_name file. Please source it before use."
			cat "$CDIR/$file_name" >"$HOME/.$file_name"

			if [ $file_name = "bashrc" ]; then
				source "$HOME/.${file_name}"
			fi
		}

		if ! [ -f "$HOME/.$file_name" ]; then
			proceed_with_replace
		else
			if [ $(has_changes "$HOME/.$file_name" "$CDIR/$file_name") = true ]; then
				proceed_with_replace
			else
				echo "[RC]: No changes detected for file '~/.$file_name'. Skipping..."
			fi
		fi
	done
}

# Apply alacritty config
install_alacritty_package() {
	echo "[ALACRITTY_CONFIG]: Checking nvim config..."

	proceed_with_symlink() {
		echo "[ALACRITTY_CONFIG]: Applying alacritty config files..."
		ln -s $CDIR/config/alacritty $HOME/.config/alacritty
	}

	if ! [ -d $HOME/.config/alacritty ]; then
		proceed_with_symlink
	else
		if [ -e $HOME/.config/alacritty ]; then
			echo "[ALACRITTY_CONFIG]: Removing old alacritty config files..."
			rm -rf $HOME/.config/alacritty
			proceed_with_symlink
		else
			echo "[ALACRITTY_CONFIG]: No changes detected for alacritty config. Skipping..."
		fi
	fi
}

# Apply nvim files config
apply_nvim_files_config() {
	echo "[NVIM_CONFIG]: Checking nvim config..."

	proceed_with_symlink() {
		echo "[NVIM_CONFIG]: Applying nvim config files..."
		ln -s $CDIR/config/nvim $HOME/.config/nvim
	}

	if ! [ -d $HOME/.config/nvim ]; then
		proceed_with_symlink
	else
		if [ -e $HOME/.config/nvim ]; then
			echo "[NVIM_CONFIG]: Removing old nvim config files..."
			rm -rf $HOME/.config/nvim
			proceed_with_symlink
		else
			echo "[NVIM_CONFIG]: No changes detected for NVIM config. Skipping..."
		fi
	fi
}

##########################################################
### Exection functions ###################################
##########################################################

execute_installers() {
	install_base_packages
	install_rust_package
	install_nvm_package
	install_nvim_package

	# Source files before continue instalations
	if [ -f "$HOME/.bashrc" ]; then
		source "$HOME/.bashrc" # This inject new packages installed on previews steps
	fi

	install_cargo_packages
	install_node_packages
	install_alacritty_package
}

execute_configs() {
	apply_rcs_files_config
	apply_nvim_files_config
}

if [ "$#" -lt 1 ]; then
	echo "Example:"
	echo "  ./configure.sh [COMMAND]"
	echo "Available commands: "
	echo "  all - Execute all instaltions and configurations settings"
	echo "  packages - Execute only instalations packages"
	echo "  configs - Execute only configurations settings"
	exit 1
fi

if [ $1 = "all" ]; then
	execute_installers
	execute_configs
fi

if [ $1 = "packages" ]; then
	execute_installers
fi

if [ $1 = "configs" ]; then
	execute_configs
fi
