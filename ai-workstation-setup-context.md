You are configuring a freshly installed Fedora Workstation system into a secure, headless AI workstation accessible from a Windows client over SSH.

## OBJECTIVE

Build a fully functional AI node that:

* Uses secure SSH key-based access from a Windows machine
* Runs local LLMs (Ollama + llama.cpp)
* Supports agent-based automation
* Supports voice interaction
* Stores all AI data on a dedicated mounted drive
* Is stable, reproducible, and safe (no lockouts)

---

## SYSTEM CONTEXT

### Remote Client:

* Windows machine using OpenSSH (PowerShell)

### Target Machine:

* Fedora Workstation (fresh install)
* SSH already enabled
* User has sudo privileges
* Secondary NVMe exists for AI data

---

## CRITICAL SAFETY RULES

* DO NOT disable SSH password authentication until key-based login is confirmed working
* DO NOT reboot unless necessary
* DO NOT modify system boot configuration
* ALWAYS validate connectivity before making access changes

---

## EXECUTION PLAN

### 1. VERIFY NETWORK + SSH

* Confirm SSH is running:
  systemctl status sshd
* Confirm firewall allows SSH:
  firewall-cmd --list-services
* If missing, add:
  firewall-cmd --add-service=ssh --permanent
  firewall-cmd --reload

---

### 2. SET UP SSH KEY AUTH (WINDOWS CLIENT COMPATIBLE)

Assume user generated key on Windows already:

* Public key located at:
  C:\Users<user>.ssh\id_rsa.pub OR id_ed25519.pub

On Fedora:

* Ensure directory:
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh

* Append public key to:
  ~/.ssh/authorized_keys

* Set permissions:
  chmod 600 ~/.ssh/authorized_keys

---

### 3. VALIDATE SSH KEY LOGIN

* Instruct user to open a NEW Windows PowerShell session and run:
  ssh <username>@<fedora-ip>

* WAIT until user confirms passwordless login works

---

### 4. HARDEN SSH

ONLY AFTER CONFIRMATION:

Edit:
/etc/ssh/sshd_config

Set:
PasswordAuthentication no

Then:
systemctl restart sshd

---

### 5. SYSTEM PREP

* Update system:
  dnf update -y

* Install essentials:
  dnf install -y git curl wget htop btop tmux neovim gcc make cmake python3 python3-pip

---

### 6. STORAGE CONFIGURATION

* Detect secondary NVMe via:
  lsblk

* If unformatted:
  mkfs.ext4 /dev/<device>

* Mount:
  mkdir -p /mnt/ai
  mount /dev/<device> /mnt/ai

* Persist in /etc/fstab

* Create structure:
  /mnt/ai/models
  /mnt/ai/ollama
  /mnt/ai/llama
  /mnt/ai/qdrant
  /mnt/ai/docker
  /mnt/ai/logs

---

### 7. INSTALL OLLAMA

* Install Ollama

* Configure model storage path:
  export OLLAMA_MODELS=/mnt/ai/ollama

* Ensure service runs on boot

* Test:
  ollama run mistral

---

### 8. INSTALL LLAMA.CPP

* Clone repo

* Build with:

  * Vulkan support
  * CPU optimizations

* Install binary system-wide

* Validate with test model

---

### 9. GPU DETECTION + BACKEND

* Detect AMD GPU
* Attempt Vulkan backend first
* If ROCm unavailable or unstable → continue with Vulkan

---

### 10. VECTOR DATABASE

* Install Qdrant (Docker preferred)
* Store data in:
  /mnt/ai/qdrant
* Ensure persistence

---

### 11. VOICE STACK

Install:

* faster-whisper OR whisper.cpp
* Piper TTS

Validate:

* STT works from audio file
* TTS produces output audio

---

### 12. AGENT FRAMEWORK

* Install OpenClaw (or similar lightweight agent framework)
* Configure:

  * Uses local Ollama endpoint
  * Supports tool calling
  * Has filesystem + shell tools

---

### 13. TOOLING LAYER

Create structured tools:

* shell execution (restricted)
* file read/write
* system info
* optional: docker

---

### 14. SERVICE MANAGEMENT

Ensure on boot:

* Ollama
* Qdrant
* Agent runtime (if daemonized)

Use systemd where appropriate

---

### 15. LOGGING

Centralize logs in:
/mnt/ai/logs

---

### 16. OPTIONAL WEB UI

Attempt:
dnf install cockpit
systemctl enable --now cockpit.socket

If inaccessible:

* Check firewall
* Log issue
* DO NOT block setup

---

## FINAL OUTPUT

Provide:

* Summary of installed components
* Active services
* Storage layout
* Model readiness
* Any warnings or incomplete steps

---

## EXECUTION STYLE

* Proceed step-by-step
* Validate each step
* Be resilient to failure
* Prefer stability over experimentation

END TASK
