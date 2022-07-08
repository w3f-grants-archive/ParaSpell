.PHONY: install
install:
	rustup default nightly
	rustup target add wasm32-unknown-unknown
	git clone https://github.com/paritytech/polkadot.git
	cd ./polkadot/ && git checkout release-v0.9.24 && cargo build --release
	git clone https://github.com/galacticcouncil/Basilisk-node.git
	cd ./Basilisk-node/ && make build
	git clone https://github.com/AcalaNetwork/Acala.git
	cd ./Acala/ && make init && make build-karura-internal-release
	git clone https://github.com/PureStake/moonbeam
	cd moonbeam && cargo build --release
	polkadot-launch Nacala-moonbeam-basilisk.json

.PHONY: initialize
initialize:
	cd .. && chmod 777 ./Polkachange
	apt install curl npm
	npm install -g polkadot-launch
	apt-get install -y git clang libssl-dev llvm libudev-dev
	
.PHONY: rustup
rustup:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

.PHONY: initializemac
initializemac:
	cd .. && chmod 777 ./Polkachange
	brew install curl node@16 git openssl make llvm protobuf python@3.9 
	npm install -g polkadot-launch

.PHONY: launch
launch:
	polkadot-launch acala-moonbeam-basilisk.json
	
