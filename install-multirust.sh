#!/bin/bash

curl -sSf https://static.rust-lang.org/rustup.sh | sh -s -- --uninstall
curl -sf https://raw.githubusercontent.com/brson/multirust/master/blastoff.sh | sh
multirust show-default
