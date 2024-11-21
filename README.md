# dotfiles

My collection of dotfiles, scripts and configurations.

Setup for installing via `stow`, expects to be cloned to `~/github/dotfiles`.

```bash
stow */
```

## package notes

### bat

Requires building bat cache after running `stow`

```bash
bat cache --build
```
