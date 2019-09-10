#!/bin/bash

function install_rust_binaries {
  local tools=${TOOLS_HOME:=$HOME/tools}
  [[ ! -d $tools ]] && mkdir -p $tools

  [[ ! -d $tools/cargo ]] && mkdir -p $tools/cargo
  [[ ! -L ~/.cargo ]] && ln -s $tools/cargo ~/.cargo
  curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y \
    && source ${HOME}/.cargo/env && hash -r \
      && rustup update \
        && rustup component add rust-src

  [[ ! -d ~/.bashrc-scripts/installed ]] && mkdir -p ~/.bashrc-scripts/installed
  cp ${HOME}/.cargo/env ~/.bashrc-scripts/installed/400-rust.sh
}

function install_rust_racer {
  rustup toolchain add nightly \
    && cargo +nightly install --force racer
}

function install_rust_database {
  cargo install --force diesel_cli --no-default-features --features postgres \
    && cargo install --force diesel_cli_ext
}

function install_rust_web {
  cargo install --force cargo-web
}

function install_rust_docset {
  cargo install --force cargo-docset
}

function install_rust {
  install_rust_binaries && install_rust_database && install_rust_web && install_rust_docset
}


if [ $_ != $0 ] ;then
  # echo "Script is being sourced"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  fgrep "function " $self | cut -d' ' -f2 | head -n -2
else
  # echo "Script is a subshell"
  self=$(readlink -f "${BASH_SOURCE[0]}"); dir=$(dirname $self)
  # echo $dir
  # echo $self
  cmd=$(fgrep "function " $self | cut -d' ' -f2 | head -n -2 | tail -1)
  # echo $cmd
  $cmd $*
fi
