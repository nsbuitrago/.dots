# NSB's NixOS Configuration

## Hosts

- odinson (main workstation)

## Users

- nsb

## TODO

Note that for nvim and other dotfile configs I simply source them using home.file. I don't care
about using the Nix way to declare these configs since they are already made. There is literally
no point in rewriting these configs. Instead, they are just included in the home-manager dir
of this config and sourced. This way, they are easy to update and backup in this repo. I personally
think this is a much better method compared to using nix. For other configurations outside of these,
(e.g., firefox), the Nix way makes more sense.

- [x] add cuda support
- [x] add garbage collection for generations older than 7d
    -[x] fix problem with gc not being found (should be nix.gc)
- [x] setup variables for usernames and hostnames
- [ ] add modules for home-manager config
- [x] setup GitLab CI for building and testing new nix configurations
- [ ] add obsidian (setup electron from instable packages)
- [x] move nvim config to home manager
- [x] move zsh config to home manager
- [ ] setup wallpaper in config
- [ ] fix suspend bug (try adjusting nvidia power management config for this)
- [x] add python3 to system level packages
- [x] bug: kitty icon not available, not found from quick search in gnome
    - This seems to have fixed itself, however, sometimes kitty has trouble when launching

NSBuitrago: <nsb5@rice.edu>
