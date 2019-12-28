#!/bin/bash

function install_rust_binaries {
  local tools=${TOOLS_HOME:=$HOME/tools}
  [[ ! -d $tools ]] && mkdir -p $tools
  [[ ! -d $tools/cargo ]] && mkdir -p $tools/cargo
  [[ ! -L ~/.cargo ]] && ln -s $tools/cargo ~/.cargo

  curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y \
    && rustup update stable \
      && rustup component add rust-src \
        && source ${HOME}/.cargo/env && hash -r

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cp ${HOME}/.cargo/env ~/.bashrc-scripts/installed/400-rust.sh
}

function install_rust_database {
  cargo install diesel_cli --force --no-default-features --features postgres \
    && cargo install --force diesel_cli_ext
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
  __install_rust_cargo_addons | xargs echo | xargs cargo install --force
}

function install_rust_web {
  rustup target add wasm32-unknown-emscripten \
    && rustup target add wasm32-unknown-emscripten \
      && rustup target add wasm32-unknown-unknown \
        && cargo install --force cargo-wasi cargo-web wasm-bindgen-cli wasm-pack
}

function install_rust_rls {
  rustup component add rls rust-analysis rust-src
}

function install_rust_docset {
  cargo install --force cargo-docset
}

function install_rust {
  install_rust_binaries && install_rust_database && install_rust_cargo_addons && install_rust_web && install_rust_rls && install_rust_docset
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced: list all functions"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  fgrep "function " $self | fgrep -v "function __" | cut -d' ' -f2 | head -n -2
else
  # echo "Script is a subshell: execute last function"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  cmd=$(fgrep "function " $self | cut -d' ' -f2 | head -n -2 | tail -1)
  $cmd $*
fi
