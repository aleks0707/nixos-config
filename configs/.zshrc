export GPG_TTY=$(tty)
gpg-connect-agent /bye
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
eval "$(direnv hook zsh)"