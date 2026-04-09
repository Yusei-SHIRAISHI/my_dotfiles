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

## Bitwarden-backed .env

`~/.env` is generated from Bitwarden by `chezmoi`.

Expected setup:

- Install the Bitwarden CLI: `bw`
- Log in and unlock it before running `chezmoi apply`
- Create a Bitwarden item named `chezmoi-shell-env`
- Add custom fields named `GITHUB_PAT` and `BRAVE_API_KEY`

Common bootstrap flow:

```sh
bw login
export BW_SESSION="$(bw unlock --raw)"
bw sync
chezmoi apply --source "$(pwd)" --verbose
```

## Bootstrap on another machine

Install `chezmoi`, initialize from this repository, log in to Bitwarden, then apply the managed files.

```sh
chezmoi init <repo-url>
bw login
export BW_SESSION="$(bw unlock --raw)"
bw sync
chezmoi apply
```
