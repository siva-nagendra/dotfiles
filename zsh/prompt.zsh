autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] )); then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ '{print $NF}')
}

git_prompt_info () {
  branch=$($git rev-parse --abbrev-ref HEAD 2>/dev/null) || return
  echo $branch
}

git_dirty() {
  if ! $git status -s &> /dev/null; then
    echo ""
  else
    if [[ -z $($git status --porcelain) ]]; then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

# This assumes that you always have an origin named `origin`, and that you only
# care about one specific origin. If this is not the case, you might want to use
# `$git cherry -v @{upstream}` instead.
need_push () {
  if [ $($git rev-parse --is-inside-work-tree 2>/dev/null) ]; then
    number=$($git cherry -v origin/$(git symbolic-ref --short HEAD) 2>/dev/null | wc -l | bc)

    if [[ $number == 0 ]]; then
      echo " "
    else
      echo " with %{$fg_bold[magenta]%}$number unpushed%{$reset_color%}"
    fi
  fi
}

# Full path and time
directory_name() {
  echo "%{$fg_bold[blue]%}%~%{$reset_color%}"
}

current_time() {
  echo "%{$fg_bold[grey]%}%*%{$reset_color%}"
}

# Update the prompt
export PROMPT=$'$(current_time) $(directory_name) $(git_dirty)$(need_push)\n› '
