# π dev env

## Prerequisites
- Git installed
- Optional: generate SSH keys via [setup-ssh](env/private_dot_local/scripts/executable_setup-ssh) script,
  or download it via `curl` and make it executable:

  **1. Download the script**
  ```bash
  curl -L \
     -o setup-ssh \
     https://raw.githubusercontent.com/LuckyBastrd/dev/refs/heads/main/env/private_dot_local/scripts/executable_setup-ssh
  ```

  **2. Make it executable**
  ```bash
  chmod +x setup-ssh
  ```

  **3. Run the script**
  ```bash
  ./setup-ssh
  ```

## Installation

### Quick Setup
Clone via HTTP
```bash
mkdir -p ~/personal/dev && git clone https://github.com/LuckyBastrd/dev.git ~/personal/dev && cd ~/personal/dev/ && ./run-dev-env
```

Or clone via SSH
```bash
mkdir -p ~/personal/dev && git clone git@github.com:LuckyBastrd/dev.git ~/personal/dev && cd ~/personal/dev/ && ./run-dev-env
```

### Step-by-Step Setup
#### 1. Create the dev folder if it doesn't exist:
```bash
mkdir -p ~/personal/dev
```

#### 2. Clone the repository:
Clone via HTTP
```bash
git clone https://github.com/LuckyBastrd/dev.git ~/personal/dev
```

Or clone via SSH
```bash
git clone git@github.com:LuckyBastrd/dev.git ~/personal/dev
```

#### 3. Change into the dev folder:
```bash
cd ~/personal/dev
```

#### 4. Run the setup script:
```bash
./run-dev-env
```
