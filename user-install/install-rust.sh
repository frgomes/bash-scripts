#!/bin/bash

function install_rust {
  local tools=${TOOLS_HOME:=$HOME/tools}
  [[ ! -d $tools ]] && mkdir -p $tools

  [[ ! -d $tools/cargo ]] && mkdir -p $tools/cargo
  [[ ! -L ~/.cargo ]] && ln -s $tools/cargo ~/.cargo
  curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y \
    && hash -r \
      && rustup update
}

function install_rust_racer {
  rustup toolchain add nightly && \
    rustup default nightly && \
      rustup component add rust-src && \
        cargo install racer
}

install_rust && install_rust_racer
