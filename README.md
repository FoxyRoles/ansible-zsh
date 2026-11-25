# sunfoxcz.zsh

An Ansible role that installs Zsh, Starship, Zinit, and fzf and sets `/usr/bin/zsh` as root's login shell.

## Requirements

- Ansible Core 2.15 or later, with fact gathering enabled.
- Debian (Bookworm or Trixie) or Ubuntu (Jammy, Noble, or Resolute) on `amd64` or `arm64`.
- Root privileges and access to APT repositories and GitHub from the managed host.

## Installation

Save this as `requirements.yml`:

```yaml
roles:
  - name: sunfoxcz.zsh
    src: https://github.com/FoxyRoles/ansible-zsh.git
    scm: git
    version: master
```

Install the role next to your playbook:

```sh
ansible-galaxy role install -r requirements.yml --roles-path ./roles
```

## Usage

```yaml
- name: Configure Zsh
  hosts: servers
  become: true
  roles:
    - sunfoxcz.zsh
```

## Configuration

The role loads `/etc/zsh/zshrc.local` from `/etc/zsh/zshrc`. The local file initializes Zinit and fzf and sets `STARSHIP_CONFIG` to `/etc/starship/starship.toml`, which contains the Agnoster-like prompt.

Zinit loads `zsh-autosuggestions`, `zsh-syntax-highlighting`, and `zsh-completions`, plus the Oh My Zsh `sudo`, `extract`, and `command-not-found` snippets. It downloads them into each user's Zinit data directory on their first interactive Zsh startup.

New accounts inherit `.zshrc` and `.zshenv` from `/etc/skel`. The former defines `grep`, `ls`, `ll`, and `la` aliases. The latter skips Ubuntu's early `compinit` call so Zinit can initialize completions after loading the plugins. Existing Ubuntu users who want the same behavior can set `skip_global_compinit=1` in their own `~/.zshenv`.

## Variables

Set these in inventory or play variables to override the release defaults:

| Variable | Default | Purpose |
| --- | --- | --- |
| `zsh_starship_version` | `1.24.2` | Starship release to install. |
| `zsh_starship_sha256` | See [role defaults](defaults/main.yml) | Starship archive SHA-256 checksums keyed by `x86_64` and `aarch64`. |
| `zsh_fzf_version` | `0.68.0` | fzf release to install. |
| `zsh_fzf_sha256` | See [role defaults](defaults/main.yml) | fzf archive SHA-256 checksums keyed by `x86_64` and `aarch64`. |

When overriding a version, also supply the matching archive checksum for each target architecture. The role uses these values when installing a missing binary and reuses executables already present at `/usr/local/bin/starship` and `/usr/local/share/fzf/bin/fzf`.
