# Set custom bin path
set -gx PATH $PATH /home/raptor/program/bin
set -gx npm_config_prefix $HOME/.local
set -gx ANDROID_HOME $HOME/Android/Sdk

set server1 34.67.194.167
set EDITOR nvim

# Setupup powerline
powerline-daemon -q
set POWERLINE_BASH_CONTINUATION 1
set POWERLINE_BASH_SELECT 1
. /usr/share/powerline/bindings/fish/powerline-setup.fish
powerline-setup

# Init ssh agent
eval (ssh-agent -c) > ~/temp/temp.txt


alias vim="nvim"
alias lf="lfrun"
alias react="cd ~/program/react/"
