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
chezmoi apply --init --source "$(pwd)" --verbose
```

## Bitwarden-backed .env

`~/.env` is generated from Bitwarden by `chezmoi`.

Expected setup:

- Install the Bitwarden CLI: `bw`
- Log in to Bitwarden before running `chezmoi apply`
- Create a Bitwarden item named `chezmoi-shell-env`
- Add custom fields named `GITHUB_PAT` and `BRAVE_API_KEY`

Common bootstrap flow:

```sh
bw login
chezmoi apply --init --source "$(pwd)" --verbose
```

If `BW_SESSION` is not already set, chezmoi automatically runs `bw unlock --raw`
via `.chezmoi.toml.tmpl`, prompts for your master password, and continues the
apply.

## SSH config and keys

`~/.ssh/config` is managed by `chezmoi`.

The GitHub SSH key is restored from a Bitwarden item at apply time.

Other SSH identities referenced from `~/.ssh/config` remain machine-local until they are migrated the same way.

Expected setup:

- Create a Bitwarden item named `ssh-github`
- If you use Bitwarden's generated SSH key item, `chezmoi` reads `sshKey.privateKey` and `sshKey.publicKey` from that item
- In the Bitwarden UI, these are shown as `秘密鍵` and `公開鍵`
- If your Bitwarden UI is in English, the fallback field names are `Private Key` and `Public Key`

The generated files are:

- `~/.ssh/config`
- `~/.ssh/keys/github/id_rsa`
- `~/.ssh/keys/github/id_rsa.pub`

`chezmoi apply` also normalizes SSH permissions after writing these files.

### Add another SSH key later

1. Add a new `Host` entry to `home/dot_ssh/private_config`
2. Add a new source directory under `home/dot_ssh/keys/<name>/`
3. Create template files that fetch the private key and public key from the Bitwarden item data
4. Add the matching Bitwarden item data
5. Run `chezmoi apply`

## Bootstrap on another machine

Install `chezmoi`, initialize from this repository, log in to Bitwarden, then apply the managed files.

```sh
chezmoi init <repo-url>
bw login
chezmoi apply --init
```

`--init` regenerates the chezmoi config from `.chezmoi.toml.tmpl`, which enables
Bitwarden auto-unlock for the apply.
