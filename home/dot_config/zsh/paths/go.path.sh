#!/usr/bin/env bash

# Go workspace under the XDG data dir (was ~/go; keeps $HOME tidy). The Go
# toolchain itself comes from mise — here we only put GOPATH's bin (the
# destination for `go install`) on PATH. Single source of truth for GOPATH.
export GOPATH="$HOME/.local/share/go"
export PATH="$PATH:$GOPATH/bin"
