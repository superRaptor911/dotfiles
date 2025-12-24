# Set custom bin path
# set -gx PATH $PATH /home/raptor/program/bin
set -gx npm_config_prefix $HOME/.local
set -gx ANDROID_HOME $HOME/Android/Sdk
set -gx ANDROID_SDK_ROOT $HOME/Android/Sdk/
set -gx PATH $PATH $ANDROID_SDK_ROOT/platform-tools
set -gx PATH $PATH $ANDROID_SDK_ROOT/emulator
set -gx BROWSER /usr/bin/brave
set -gx DESH_NPM_TOKEN gldt-SKYj2AB12t_j5zxdV4uy

set EDITOR nvim

alias vim="nvim"
alias lf="lfrun"
alias react="cd ~/program/react/"
setxkbmap -option caps:escape
# source /usr/share/nvm/init-nvm.sh
zoxide init fish | source
alias cd="z"
alias neofetch="fastfetch"

thefuck --alias | source
