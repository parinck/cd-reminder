function _cd_remind() {
    # https://linuxize.com/post/bash-check-if-file-exists/
    local CD_REMINDER_FILE=.cd-reminder
    if [ -f "$CD_REMINDER_FILE" ]; then
        echo "$(tput bold)$(tput setaf 2)💡cd-reminder:$(tput sgr0)";
        echo "--------------"
        cat $CD_REMINDER_FILE 1>&2;
    fi
}

# calls the builtin cd command, and then optionally cat's the .cd-reminder file
# in the directory if it exists
function reminder_z() {
    z "$@" && _cd_remind;
}

function reminder_cd() {
    builtin cd "$@" && _cd_remind;
}

# Either creates an empty .cd-reminder file, or if an argument is included
# then creates and appends to that file the first argument
new_reminder() {
    if [[ $# -eq 0 ]]; then
        touch .cd-reminder
    fi

    if [[ $# -gt 0 ]]; then
        echo $@ >> .cd-reminder
    fi
}

_insert_git_exclude() {
  echo ".cd-reminder" >> $(git config --global core.excludesfile)
}

git_exclude_cd_reminder() {
  if [[ -a $(git config --global core.excludesfile) ]]; then
    _insert_git_exclude
  else
    touch "$HOME/.gitignore-global"
    git config --global core.excludesfile "$HOME/.gitignore-global"
    _insert_git_exclude
  fi
}

alias cd=reminder_cd
alias z=reminder_z
