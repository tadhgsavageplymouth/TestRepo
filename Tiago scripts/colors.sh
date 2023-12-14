#!/usr/bin/env bash

_RED=$(tput setaf 1)
_GREEN=$(tput setaf 2)
_YELLOW=$(tput setaf 3)
_BLUE=$(tput setaf 4)
_PURPLE=$(tput setaf 5)
_CYAN=$(tput setaf 6)
_PINK=$(tput setaf 13)
_RESET=$(tput sgr0)
_BOLD=$(tput bold)

function _getColor() {
  case $1 in
    red)    echo -en $_RED ;;
    green)  echo -en $_GREEN ;;
    yellow) echo -en $_YELLOW ;;
    blue)   echo -en $_BLUE ;;
    purple) echo -en $_PURPLE ;;
    cyan)   echo -en $_CYAN ;;
    pink)   echo -en $_PINK ;;
    bold)   echo -en $_BOLD ;;
  esac
}

function color() {
  color=$1 
  text=$2

  echo -e "$(_getColor $color)${text}${_RESET}"
}

