#!/usr/bin/env bash

if command -v code >/dev/null 2>&1; then
	code() {
		local _ext_list="$HOME/.config/vscode-extensions.txt"
		case "$1" in
		save-ext)
			echo "Saving code extensions to $_ext_list..."
			command code --list-extensions > "$_ext_list"
			;;
		install-ext)
			echo "Installing code extensions from $_ext_list..."
			cat "$_ext_list" | xargs -L 1 command code --install-extension
			;;
		*)
			command code "$@"
			;;
		esac
	}
fi
