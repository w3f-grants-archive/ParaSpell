## Polkachange v1.0
**Sharing fungible tokens across Polkadot paraverse using Channels and XCM messages.**

## Prerequisites
### Git and Make
#### Linux
```
sudo apt install git make
```
#### MacOs
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install make git
```

## Initializing localhost setup:
### 1. Install dependencies 

#### 1.1 Ubuntu
```
sudo make initialize
```
#### 1.2 MacOs
```
make initializemac
```

### 2. Install rust 
```
make rustup
```

### 3. Install polkadot, karura, basilisk and dependencies. After running **make initialize** command make sure to restart shell.
```
make install
```

### Relaunch network after it was put down.
```
make launch
```

## Running Polkachange application

### Installs dependencies and packages
```
npm install
```

### Compiles and hot-reloads for development
```
npm run serve
```

### Compiles and minifies for production
```
npm run build
```

### Lints and fixes files
```
npm run lint
```

