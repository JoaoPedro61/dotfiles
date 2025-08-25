#################
### ZSH Funcs ###
#################
if [ -d $HOME/.zsh_functions ]; then
  fpath=($HOME/.zsh_functions $fpath)
fi

#################
### Rust Lang ###
#################
if [ -d $HOME/.cargo ]; then
  . "$HOME/.cargo/env"
fi

#################
### asdf ########
#################
if [ -d $HOME/.asdf ]; then
  . "$HOME/.asdf/asdf.sh"
  fpath=(${ASDF_DIR}/completions $fpath)

  if [ -d $HOME/.asdf/plugins/golang ]; then
    . $HOME/.asdf/plugins/golang/set-env.zsh
  fi
fi

#################
### NVIM ########
#################
if [ -d $HOME/.nvim ]; then
  export PATH="$PATH:$HOME/.nvim/bin"
fi

#################
### Alacritty ###
#################
if [ -f $HOME/.zsh_functions/_alacritty ]; then
  # Do nothing
fi

alias tm="tmux attach || tmux"
