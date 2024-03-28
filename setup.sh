
# some initial setup commands
sudo tailscale --ssh up

# clone and setup dotfiles
cd ~/.config
gh repo clone nsbuitrago/.dots
cd .dots
stow .


