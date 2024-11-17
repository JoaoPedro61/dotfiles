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
  . "$HOME/.asdf/completions/asdf.bash"

  if [ -d $HOME/.asdf/plugins/golang ]; then
    . $HOME/.asdf/plugins/golang/set-env.bash
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
if [ -f $HOME/.bash_completion/alacritty ]; then
  source $HOME/.bash_completion/alacritty
fi
