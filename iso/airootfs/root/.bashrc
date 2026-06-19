# Firmus Linux root .bashrc
alias update='firmus-update'
alias rollback='firmus-rollback'
alias status='firmus-status'
alias rebuild='firmus-initramfs'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias vi='nvim'
alias vim='nvim'

export EDITOR=nvim
export VISUAL=nvim
export PAGER=less

PS1='\[\e[1;36m\][firmus\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]]\[\e[1;36m\]\$\[\e[0m\] '
