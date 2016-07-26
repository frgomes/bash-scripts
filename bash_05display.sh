#!/bin/sh

function xrandr_home {
  xrandr --output CRT1 --mode 1680x1050 --pos 0x0 --rotate normal --output DFP2 --mode 1920x1200 --pos 1680x0 --rotate normal --output DFP1 --off
}
