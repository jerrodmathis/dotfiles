# path to oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"

# cache
ZSH_CACHE_DIR="$HOME/.cache/ohmyzsh"
ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"

# plugins
plugins=(git keychain zsh-syntax-highlighting)

zstyle :omz:plugins:keychain agents ssh
zstyle :omz:plugins:keychain identities id_ed25519
zstyle :omz:plugins:keychain options --quiet

source $ZSH/oh-my-zsh.sh

### Environment Variables ###
export NODE_AUTH_TOKEN=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
export GH_TOKEN=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
export HOST_UID_GID=$(id -u):$(id -g)

### Gemini CLI ###
export GOOGLE_CLOUD_PROJECT=is-gemini-cli

# aliases
alias ofe="cd $HOME/code/work/odin-ui/packages/web-app"
alias dae="cd $HOME/code/work/daedalus"
alias k="kubectl"
alias vim="nvim"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

eval "$(starship init zsh)"

