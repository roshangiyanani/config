# source this file from your .zshrc
# Can be done writing:
# source [THIS_DIR]/set_prompt.zsh
# to the ~/.zshrc file.
# last command failed
PROMPT="%(?.✅.❌) %F{green}%n%f@%F{yellow}%m%f:%F{cyan}%1/%f%# "
RPROMPT="%*"
