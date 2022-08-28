

## ParaSpell - XCM & XCMP Developer UI tool
![Header](https://raw.githubusercontent.com/dudo50/ParaSpell/main/img/HeaderImg.png)

[1. Introduction](#1-introduction)<br />
[2. Overview](#2-overview)<br />
[3. Installation](#3-installation)<br />
&nbsp;&nbsp;[3.1 Prerequisites](#31-prerequisites)<br />
&nbsp;&nbsp;[3.2 Dependencies](#32-dependencies)<br />
&nbsp;&nbsp;[3.3 Network install, compilation & start](#33-network-install-compilation--start)<br />
&nbsp;&nbsp;[3.4 Application install & launch](#34-application-install--launch)<br />
[4. Wiki](#4-wiki)<br />
[5. Project achievements](#5-project-achievements)<br />

# 1. Introduction
ParaSpell is XCM & XCMP related tool built to save developers time when interacting with the network. It is no longer necessary to search for correct XCM pallets, fill lengthy XCM messages with all the required details or go through research on launching network. Developers can use ParaSpell to download/install/start necessary nodes with a single command, execute XCM transactions from a user-friendly UI, or open & close HRMP channels between nodes in the launched network from a user-friendly UI.

# 2. Overview
ParaSpell main advantages can be summarized in the following list:
- ParaSpell is a platform that allows developers to use specific XCM & XCMP related tasks from a user-friendly interface. 
- ParaSpell focuses on ease of use, broad scale of use cases, and bringing XCM & XCMP utilization & documentation closer to developers. 
- ParaSpell guarantees to be a completely decentralized, open-source platform that does not collect any user data. 

One of the ParaSpell main goals is to reduce the time necessary to create XCM calls or open HRMP channels.

[
![Opening channel screen](https://raw.githubusercontent.com/dudo50/Polkachange/main/img/comparisonImg.jpg)
](https://raw.githubusercontent.com/dudo50/Polkachange/main/img/comparisonImg.jpg)

As we can see in the figure above, the amount of details the user has to fill to transfer the XCM message is drastically reduced. As an example, users do not need to specify a specific route from origin to destination chain. These details are filled for them. 

Another goal of ParaSpell is having network installation, compilation & startup done as simply as possible. This is achieved by makefile that groups commands into fewer much more intuitive commands and by network startup configuration file. Together, these two files take care of the network side, and adding new nodes into these files is intuitive.  Starting the application is also very simple and done by one command. Communication between application and network is made possible with Polkadot API libraries.

ParaSpell focuses mainly on substrate developers. Added value comes from being user friendly SDK for simplifying development by saving time necessary to install & launch network, open HRMP channels or create XCM transfers between nodes available in network.

Overall ParaSpell is all about developer experience.

# 3. Installation
Complete guide for project installation and launch.
## 3.1 Prerequisites
Prerequisites required for cloning repository, work with Makefile and Network.
- DOCKER, you can install it from this link [Docker](https://docs.docker.com/get-docker/)

#### Linux
```
sudo apt install git make
```
#### MacOs
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install make git
```
## 3.2 Dependencies:
Depedencies necessary for network compilation & startup
#### Linux
```
sudo make initialize
```
#### MacOs
```
make initializemac
(Make sure you have sufficient permissions for usage of npm commands)
```

#### Install rust (Linux & MacOS) - Restart shell after this install 
```
make rustup
```

## 3.3 Network install, compilation & start 
```
make install
```

#### Relaunch network after it was put down.
```
make launch
```

## 3.4 Application install & launch
### Start application in docker container
```
make dockerLaunch
```
### Start application manually
#### Install dependencies & packages
```
npm install
```

#### Starts application for development
```
npm run serve
```

#### Compiles and minifies for production
```
npm run build
```

# 4. Wiki
If you are looking for more indepth explanation of XCM, HRMP, Query calls ParaSpell uses or you want to add new currencies/nodes to ParaSpell/Network check out our Wiki - [ParaSpell✨ Wiki 📚️](https://github.com/dudo50/ParaSpell/wiki)

# 5. Project achievements
Project achievements in chronological order ⌛️.

- 📙 Article about project created & presented on international conference ICECET2022 held in Prague (450 out of 1000+ articles accepted) [Link to conference physical program - Article 862 ](http://www.icecet.com/program_P.pdf) Link to IEEE publication - TBA
- 🥈 2nd Prize, Build a XCM related Tool for Moonbeam - Polkadot North America Hackaton [Hackaton entry](https://devpost.com/software/polkachange-cross-blockchain-transfer-tool)
- 🥉 3rd Prize, EVM+ DApp for aUSD yield - Polkadot North America Hackaton [Hackaton entry](https://devpost.com/software/polkachange-cross-blockchain-transfer-tool)
