
<div align="center">

# 🔄 UpdateAll

**One command to update all package managers, dependencies, and system tools on your machine.**

[![GitHub stars](https://img.shields.io/github/stars/Amine-Genin/UpdateAll?style=for-the-badge&logo=github)](https://github.com/Amine-Genin/UpdateAll/stargazers)
[![GitHub last commit](https://img.shields.io/github/last-commit/Amine-Genin/UpdateAll?style=for-the-badge)](https://github.com/Amine-Genin/UpdateAll/commits/main)
[![GitHub issues](https://img.shields.io/github/issues/Amine-Genin/UpdateAll?style=for-the-badge)](https://github.com/Amine-Genin/UpdateAll/issues)
[![License](https://img.shields.io/github/license/Amine-Genin/UpdateAll?style=for-the-badge)](LICENSE)

*Stop wasting time manually updating Homebrew, npm, pip, apt, and system packages one by one.*

[Quick Start](#-quick-start) • [Features](#-features) • [Supported Tools](#-supported-package-managers--tools) • [Contributing](#-contributing)

</div>

---

## ⚡ Why UpdateAll?

Keeping your developer environment up-to-date is usually tedious and repetitive. You end up running `brew update`, `npm update -g`, `pip list --outdated...`, and several other package updates manually across different terminal sessions.

**UpdateAll** consolidates your maintenance workflow into a single command that automatically detects your environment and safely updates all your system tools in one go.

### 🌟 Key Features

- 🎯 **Smart Auto-Detection:** Automatically identifies installed package managers (Brew, APT, Pacman, NPM, Pip, Cargo, Flatpak, Snap, etc.) and updates only what you use.
- ⚡ **Zero Setup Friction:** Clone, execute, and your system is fully updated.
- ⏱️ **Time Saver:** Replaces multi-step maintenance routines with a single command.
- 🛡️ **Clean & Safe Execution:** Runs sequential checks and logs progress clearly so you know exactly what was updated.

---

## 🚀 Quick Start

Get your system completely updated in less than a minute:

```bash
# 1. Clone the repository
git clone [https://github.com/Amine-Genin/UpdateAll.git](https://github.com/Amine-Genin/UpdateAll.git)

# 2. Move into the project directory
cd UpdateAll

# 3. Make the script executable
chmod +x updateall.sh

# 4. Run UpdateAll
./updateall.sh

```

---

## 💡 Run From Anywhere (Global Shortcut)

To run `updateall` from any directory at any time, create a symbolic link in your system path:

```bash
sudo ln -s "$(pwd)/updateall.sh" /usr/local/bin/updateall

```

Now you can keep your machine current anytime simply by typing:

```bash
updateall

```

---

## 📦 Supported Package Managers & Tools

| Category | Tools Supported |
| --- | --- |
| **System Package Managers** | `apt`, `pacman`, `dnf`, `brew`, `flatpak`, `snap` |
| **Developer Ecosystems** | `npm`, `pnpm`, `yarn`, `pip` / `pip3`, `cargo` (Rust), `gem` |
| **App Managers** | `mas` (Mac App Store CLI), `winget` (Windows) |

*(Feel free to submit a PR if your favorite package manager isn't listed yet!)*

---

## 🤝 Contributing

Contributions make the open-source community an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**!

1. **Fork** the Project
2. Create your Feature Branch (`git checkout -b feature/AwesomeUpdate`)
3. **Commit** your Changes (`git commit -m 'Add support for X package manager'`)
4. **Push** to the Branch (`git push origin feature/AwesomeUpdate`)
5. Open a **Pull Request**

---

## ⭐ Support the Project

If **UpdateAll** saves you time and keeps your workstation running smoothly:

* Give this repository a **Star** ⭐️
* Share it with fellow developers 🚀
* Report any issues or request new package manager integrations 💬

---

Made with ❤️ by [Amine-Genin](https://www.google.com/search?q=https://github.com/Amine-Genin)

© 2026 UpdateAll Project
