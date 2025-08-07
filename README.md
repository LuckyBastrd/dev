# dev

Monorepo containing my personal development environment setup.  
It includes dotfiles, provisioning, configurations, and full system automation.

---

## 📦 Repository Structure

```plaintext
dev/
├── dev-dotfiles/       # Dotfiles (chezmoi-managed)
├── dev-ansible/        # Ansible provisioning for Arch/macOS
├── dev-submodules/     # Miscellaneous configs, scripts, tools, etc.
├── dev-env             # Main entry point script
└── README.md
```

Each directory is its own Git repo (some are submodules), designed to work together as a complete setup.

---

## ⚠️ Symlink Warning

Some files in this monorepo are **symbolic links** pointing across directories.  
These symlinks rely on the full monorepo structure. Cloning only one repo may result in **broken links**.

---

## ✅ Recommended Usage

Clone and run (HTTPS):

```bash
git clone https://github.com/LuckyBastrd/dev.git && cd dev && ./dev-env
```

Or use SSH:

```bash
git clone git@github.com:LuckyBastrd/dev.git && cd dev && ./dev-env
```

The script automatically initializes submodules and sets up everything.

---

## 🚀 Setup

You can also run manually if already cloned:

```bash
./dev-env
```

This will:

- Run `run-ansible` to provision your system (Arch/macOS)
- Run `run-dotfiles` to apply and install your dotfiles with chezmoi
- Handle any additional setup via content in `dev-submodules`

---
