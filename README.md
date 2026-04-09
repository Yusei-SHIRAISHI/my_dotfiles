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

## SSH config and keys

`~/.ssh/config` is managed by `chezmoi`.

The GitHub SSH key is restored from Bitwarden attachments at apply time.

Other SSH identities referenced from `~/.ssh/config` remain machine-local until they are migrated the same way.

Expected setup:

- Create a Bitwarden item named `ssh-github`
- Add attachments named `id_rsa` and `id_rsa.pub`

The generated files are:

- `~/.ssh/config`
- `~/.ssh/keys/github/id_rsa`
- `~/.ssh/keys/github/id_rsa.pub`

`chezmoi apply` also normalizes SSH permissions after writing these files.

### Add another SSH key later

1. Add a new `Host` entry to `home/dot_ssh/private_config`
2. Add a new source directory under `home/dot_ssh/keys/<name>/`
3. Create template files that fetch the private key and public key from Bitwarden attachments
4. Add the matching Bitwarden item and attachments
5. Run `chezmoi apply`

## Bootstrap on another machine

Install `chezmoi`, initialize from this repository, log in to Bitwarden, then apply the managed files.

```sh
chezmoi init <repo-url>
bw login
export BW_SESSION="$(bw unlock --raw)"
bw sync
chezmoi apply
```
