export GPG_TTY=$(tty)
echo UPDATESTARTUPTTY | gpg-connect-agent /bye
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
eval "$(direnv hook zsh)"