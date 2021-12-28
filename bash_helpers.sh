#!/bin/bash

# some more ls aliases

#####################################
## aliases
#####################################

## ls aliases
alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -alFtrh'
alias lt='ls -trhl'
alias l.='ls -d .* -trhl'
alias l='ls -t'
alias lr='ls -tr'

## du aliases
alias du1='du -h --max-depth 1'
alias du2='du -h --max-depth 2'

alias rm~='rm -i ./*~'
alias cdl='cd $( lt |awk "END{print \$NF}" )'

alias grepr='grep -R * -e '

alias python="python3"

## ssh aliases
alias sshpi="ssh -l pi 192.168.1.202"

# command prompt format
PS1='[\[\e[1;31m\]@ \[\e[1;34\]m\w\[\e[m\]]\n>> '

#####################################
## functions
#####################################

# from: petar marinov, http:/geocities.com/h2428, this is public domain
cd_func ()
{
  local x2 the_new_dir adir index
  local -i cnt

  if [[ $1 ==  "--" ]]; then
	dirs -v
	return 0
  fi

  the_new_dir=$1
  [[ -z $1 ]] && the_new_dir=$HOME

  if [[ ${the_new_dir:0:1} == '-' ]]; then
	#
	# Extract dir N from dirs
	index=${the_new_dir:1}
	[[ -z $index ]] && index=1
	adir=$(dirs +$index)
	[[ -z $adir ]] && return 1
	the_new_dir=$adir
  fi

  #
  # '~' has to be substituted by ${HOME}
  [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"

  #
  # Now change to the new dir and add to the top of the stack
  pushd "${the_new_dir}" > /dev/null
  [[ $? -ne 0 ]] && return 1
  the_new_dir=$(pwd)

  #
  # Trim down everything beyond 11th entry
  popd -n +11 2>/dev/null 1>/dev/null
#
  # Remove any other occurrence of this dir, skipping the top of the stack
  for ((cnt=1; cnt <= 10; cnt++)); do
	x2=$(dirs +${cnt} 2>/dev/null)
	[[ $? -ne 0 ]] && return 0
	[[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
	if [[ "${x2}" == "${the_new_dir}" ]]; then
  	popd -n +$cnt 2>/dev/null 1>/dev/null
  	cnt=cnt-1
	fi
  done

  return 0
}

alias cd=cd_func

if [[ $BASH_VERSION > "2.05a" ]]; then
	# Alt+W shows the menu
	bind -x '"\eW":"cd --"'
# ctrl+w shows the menu
  	# bind -x "\"\C-w\":cd_func -- ;"
fi


# change directory counting from last of 'ls-rt' command output
function cdr() {
	# make an array of file names ordered in last modified time
	file_array=( $( ls -rt ) )

	# check for a commandline argument. If non is provided,
	# last file is the default.
	[[ -z "$1" ]] && file_num=1 || file_num=$1

	# get file_array length
	fa_len=${#file_array[@]}

	f1=${file_array[fa_len-$file_num]}

	# change dir
	cd $f1
}


# echo filename counting from last of 'ls-rt' command output
function f() {
	# make an array of file names ordered in last modified time
	file_array=( $( ls -rt ) )

	# check for commandline argument.If no argument is provided,
	# last file is the default.
	[[ -z "$1" ]] && file_num=1 || file_num=$1

	# get file_array length
	fa_len=${#file_array[@]}

	f1=${file_array[fa_len-$file_num]}

	# echo the file name
	echo $f1
}


# define a macro to print "`f `" in to terminal
if [[ $BASH_VERSION > "2.05a" ]]; then
	# Alt+F to print "`f `" in to terminal
	bind  '"\eF":"`f `"'
fi

# function for bc with scale of 4              
 function bc4() {
	bc -l <<< "scale=4; $1;" ;
}

#####################################
# Hot-key binds

# search history by matching sequence left to cursor
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
set show-all-if-ambiguous on
set completion-ignore-case on

#####################################
# to set command editor
export EDITOR=emacs

# set path
export PATH=/home/`whoami`/bin:/home/`whoami`/.local/bin:$PATH

# find example for selecting particular file types and eliminate directories
# find . -regex '.*\.\(cpp\|h\)' -print -o -name . -o -prune |xargs grep 'run' -n --color=auto

#####################################
# temporary aliases


#####################################
## Notes:
#####################################

## for WSL in windows:
## to GUI applications in ubuntu

# to start x-server>> in cmd-window
#F:\>cygwin64\bin\run.exe --quote /usr/bin/bash.exe -l -c "cd; exec /usr/bin/startxwin -- -listen tcp -nowgl"

# in WSL ubuntu terminal
#export DISPLAY=:0

# to fix dual boot time issue run following command once
# timedatectl set-local-rtc 1

