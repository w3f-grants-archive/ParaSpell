.PHONY: install
install:
	rustup default nightly
	rustup target add wasm32-unknown-unknown
	cd ./polkadot/ && git checkout release-v0.9.19 && cargo build --release
	git clone https://github.com/galacticcouncil/Basilisk-node.git
	cd ./Basilisk-node/ && make build
	git clone https://github.com/AcalaNetwork/Acala.git
	cd ./Acala/ && make init && make build-karura-internal-release
	cd ./Basilisk-node/rococo-local/ && polkadot-launch basilisk-karura.json
.PHONY: initialize
initialize:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	npm install -g polkadot-launch
	apt-get install -y git clang curl libssl-dev llvm libudev-dev
	
