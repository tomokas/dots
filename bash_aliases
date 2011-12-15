alias gi="grep -iIrn"
alias ll="ls -l --group-directories-first"
alias c="clear"

alias ..="cd .."

alias syntax="git ls-files | grep py\$ | xargs py_compilefiles"
alias rmpycs="find . -regex '.*?pyc$' -exec rm '{}' \;"

alias gai="git add -i"
alias gap="git add -p"
alias gdc="git diff --cached"
alias gd="git diff"
alias gdw="git diff --word-diff"
alias gs="git status"
alias gl="git log --graph --all --pretty=format:'%Cred%h%Creset - %Cgreen(%cr)%Creset %s%C(yellow)%d%Creset' --abbrev-commit --date=relative"
function gcm() {
    git commit -m "$@"
}
alias gpr="git pull --rebase"
alias gpu="git push"
