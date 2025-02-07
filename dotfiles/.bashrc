PS1_ORIG=$PS1 # original primary prompt value
PROMPT_COMMAND=__update_prompt # Func to be re-evaluated after each command is executed
__update_prompt() {
    local curr_exit="$?"
    local BRed='\[\e[0;91m\]'
    local RCol='\[\e[0m\]'
    PS1='\[\033[01;31m\]\h\[\033[00m\] \[\033[01;34m\]\w \$\[\033[00m\] '
    if [ "$curr_exit" != 0 ]; then
        PS1="[${BRed}$curr_exit${RCol}]$PS1"
    fi
}

source /root/.bash_aliases

PATH=$PATH:$mydir/myscripts
