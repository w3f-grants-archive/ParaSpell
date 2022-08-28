.PHONY: install
install:
	rustup default nightly
	rustup target add wasm32-unknown-unknown
	parachain-launch generate paraspell-network-config.yml
	cd ./output && docker-compose up -d --build

.PHONY: initialize
initialize:
	cd .. && chmod 777 ./ParaSpell
	apt install curl npm
	apt-get update && apt-get upgrade
	npm install -g @open-web3/parachain-launch
	apt-get install -y git clang libssl-dev llvm libudev-dev cmake
	

.PHONY: initializemac
initializemac:
	cd .. && chmod 777 ./ParaSpell
	brew install curl node@16 git openssl make llvm protobuf python@3.9 
	npm install -g @open-web3/parachain-launch

.PHONY: rustup
rustup:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

.PHONY: launch
launch:
	cd ./output && docker-compose down -v && docker-compose up -d --build

.Phone: dockerLaunch
dockerLaunch:
	docker build -t paraspell . && docker run -it -p 8080:8080 --rm --name paraspell1 paraspell

