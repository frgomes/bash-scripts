#!/bin/bash

function install_rust_binaries {
  local tools=${TOOLS_HOME:=$HOME/tools}
  [[ ! -d $tools ]] && mkdir -p $tools
  [[ ! -d $tools/cargo ]] && mkdir -p $tools/cargo
  [[ ! -L ~/.cargo ]] && ln -s $tools/cargo ~/.cargo

  curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y \
    && source ${HOME}/.cargo/env && hash -r \
      && rustup default stable && rustup update \
        && rustup component add rust-src
  
  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cp ${HOME}/.cargo/env ~/.bashrc-scripts/installed/400-rust.sh
}

function __install_rust_cargo_addons {
cat << EOD
cargo-watch
cargo-edit
cargo-tree
cargo-udeps
cargo-audit
EOD
}

function install_rust_cargo_addons {
  source ~/.bashrc-scripts/installed/400-rust.sh
  __install_rust_cargo_addons | xargs echo | xargs cargo install --force
}

function install_rust_web {
  source ~/.bashrc-scripts/installed/400-rust.sh
  rustup target add wasm32-unknown-emscripten \
    && rustup target add wasm32-unknown-emscripten \
      && rustup target add wasm32-unknown-unknown
}

function __install_rust_web_addons {
cat <<EOD
cargo-wasi
cargo-web
wasm-bindgen-cli
wasm-pack
EOD
}

function install_rust_web_addons {
  source ~/.bashrc-scripts/installed/400-rust.sh
  __install_rust_web_addons || xargs cargo install --force
}

function install_rust_language_server {
  source ~/.bashrc-scripts/installed/400-rust.sh
  rustup component add rls rust-analysis rust-src
}

function install_latex_language_server {
  source ~/.bashrc-scripts/installed/400-rust.sh
  cargo install --force --git https://github.com/latex-lsp/texlab.git
}

function install_rust_docset {
  source ~/.bashrc-scripts/installed/400-rust.sh
  cargo install --force cargo-docset
}

function install_rust {
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1 | while read cmd ;do
    $cmd $*
  done
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced: list all functions"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  grep -E "^function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -1
else
  # echo "Script is a subshell: execute last function"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  cmd=$(grep -E "^function " $self | cut -d' ' -f2 | tail -1)
  $cmd $*
fi
