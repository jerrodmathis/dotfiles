# Path to my dotfiles
export DOTFILES="$HOME/.dotfiles"

# path to oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

# plugins
plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

eval "$(starship init zsh)"

