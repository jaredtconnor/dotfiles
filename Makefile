.PHONY: install install-osx install-linux install-windows karabiner phoenix macos brew brew-restore phoenix-dev

# Run dotbot install script
# Run dotbot install script
install:
	@if [ "$(shell uname)" = "Darwin" ]; then \
		make install-macos; \
	elif [ "$(shell uname)" = "Linux" ]; then \
		make install-linux; \
	elif [ "$(OS)" = "Windows_NT" ]; then \
		make install-windows; \
	else \
		echo "Unsupported OS"; \
		exit 1; \
	fi


install-linux:
	./install-linux.sh

install-macos:
	./install-macos.sh 

install-windows:
	powershell.exe -ExecutionPolicy Bypass -File ./install.ps1

link:
	./install --only link

# Build and output karabiner.json
karabiner:
	deno run --allow-env --allow-read --allow-write ./tools/karabiner/karabiner.ts

karabiner-dev:
	deno run --watch --allow-env --allow-read --allow-write ./tools/karabiner/karabiner.ts

# Install extensions from vscode/extensions.txt
vscode-install:
	cat ${DOTFILES}/vscode/extensions.txt | xargs -L 1 code --install-extension

# Save all current extensions to vscode/extensions.txt
vscode-save:
	code --list-extensions > ${DOTFILES}/vscode/extensions.txt

# Save snapshot of all Homebrew packages to macos/Brewfile
brew:
	brew bundle dump -f --file=machines/osx/Brewfile
	brew bundle --force cleanup --file=machines/osx/Brewfile

# Restore Homebrew packages
brew-restore:
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew update
	brew upgrade
	brew install mas
	brew bundle install --file=machines/osx/Brewfile
	brew cleanup

# Set MacOS defaults
macos:
	./machines/osx/set-defaults.sh
