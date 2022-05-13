## Polkachange v1.0
**Sharing fungible tokens across Polkadot paraverse using Channels and XCM messages.**

## Prerequisites
### Git and Make
```
sudo apt install git make
```

## Initializing localhost setup:
### 1. Install dependencies 
```
sudo make initialize
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

