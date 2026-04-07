# dotfiles

This repository is managed as a `chezmoi` source state.

## Layout

- `home/`: files managed under `$HOME`
- `.chezmoiroot`: tells `chezmoi` to read source state from `home/`

Examples:

- `home/dot_bashrc` -> `~/.bashrc`
- `home/dot_config/nvim/init.lua` -> `~/.config/nvim/init.lua`

## Apply locally

```sh
./install.sh
```

This is equivalent to:

```sh
chezmoi apply --source "$(pwd)" --verbose
```

## Bootstrap on another machine

Install `chezmoi`, then initialize from this repository and apply the managed files.

```sh
chezmoi init --apply <repo-url>
```
