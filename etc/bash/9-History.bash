# /etc/bash/bashrc.d/9-History.bash
HISTSIZE=86000
HISTFILESIZE=500000
HISTORY_IGNORE="(ls|pwd|exit)"
PROMPT_COMMAND+=('history -a')
