#!/bin/bash

[[ ! -d /opt/developer/cargo ]] && mkdir -p /opt/developer/cargo
[[ ! -L ~/.cargo ]] && ln -s /opt/developer/cargo ~/.cargo
curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y
