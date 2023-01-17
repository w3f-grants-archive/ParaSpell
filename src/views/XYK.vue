<template>
    <div id="app">
      
      <img src="../assets/bsx.svg">

      <div class="box" style="margin-top: 5%;  font-family: 'Anybody', cursive;">
      You are logged in as {{$store.state.account}}.
    </div>

      
      <b-field class="textt" label-position="inside" label="Select XYK action you wish to perform">
        <b-select expanded v-model="key" placeholder="Select XYK action you wish to perform" required>
          <option v-for="(item) in items" :key="item">{{item}}</option>
        </b-select>
      </b-field>
      
      <div v-if="key=='Add liquidity'">
        <b-field class="textt" label-position="inside" label="Input assetID A">
          <b-input expanded @input.native="astA($event)" v-model="assetA"></b-input>
        </b-field>
        <b-field class="textt" label-position="inside" label="Input assetID B">
          <b-input expanded @input.native="astB($event)" v-model="assetB"></b-input>
        </b-field>
        <b-field class="textt" label-position="inside" label="Input amount of asset A">
          <b-input expanded @input.native="amtA($event)" v-model="amountA"></b-input>
        </b-field>
        <b-field class="textt" label-position="inside" label="Input max limit of asset B">
          <b-input expanded @input.native="amtMxB($event)" v-model="amountBMaxLimit"></b-input>
        </b-field>
        <b-button class="buttonn" expanded  type="is-primary" label="Send transaction" pack="fas" icon-right="file-import" @click="addLiquidity($store.state.account)"/>

      </div>

      <div v-if="key=='Remove liquidity'">
        <b-field class="textt" label-position="inside" label="Input assetID A">
          <b-input expanded @input.native="astA($event)" v-model="assetA"></b-input>
        </b-field>
        <b-field class="textt" label-position="inside" label="Input assetID B">
          <b-input expanded @input.native="astB($event)" v-model="assetB"></b-input>
        </b-field>
        <b-field class="textt" label-position="inside" label="How much luquidity amount you wish to remove">
          <b-input expanded @input.native="lqdtyAmt($event)" v-model="liquidityAmount"></b-input>
        </b-field>
        <b-button class="buttonn" expanded  type="is-primary" label="Send transaction" pack="fas" icon-right="file-import" @click="removeLiquidity($store.state.account)"/>
      </div>

      <div v-if="key=='Create pool'">
        <b-field class="textt" label-position="inside" label="Input assetID A">
          <b-input expanded @input.native="astA($event)" v-model="assetA"></b-input>
        </b-field>
        <b-field class="textt" label-position="inside" label="Input amount of assetID A">
          <b-input expanded @input.native="amtA($event)" v-model="amountA"></b-input>
        </b-field>
        <b-field class="textt" label-position="inside" label="Input assetID B">
          <b-input expanded @input.native="astB($event)" v-model="assetB"></b-input>
        </b-field>
        <b-field class="textt" label-position="inside" label="Input amount of assetID B">
          <b-input expanded @input.native="amtB($event)" v-model="amountB"></b-input>
        </b-field>
        <b-button class="buttonn" expanded  type="is-primary" label="Send transaction" pack="fas" icon-right="file-import" @click="createPool($store.state.account)"/>
      </div>

      <div v-if="key=='Buy'">
        <b-field class="textt" label-position="inside" label="Input assetID of asset you Buy">
          <b-input expanded @input.native="astOut($event)" v-model="assetOut"></b-input>
        </b-field>
        <b-field class="textt" label-position="inside" label="Input assetID of asset you Sell">
          <b-input expanded @input.native="astIn($event)" v-model="assetIn"></b-input>
        </b-field>
        <b-field class="textt" label-position="inside" label="Input amouunt of asset you buy">
          <b-input expanded @input.native="amt($event)" v-model="amount"></b-input>
        </b-field>
        <b-field class="textt" label-position="inside" label="Input max limit of asset you want to give">
          <b-input expanded @input.native="mxLmt($event)" v-model="maxLimit"></b-input>
        </b-field>
        <b-field class="textt" label-position="inside" label="Do you want to apply discount if possible?">
          <b-switch v-model="discount"></b-switch>
        </b-field>
        <b-button class="buttonn" expanded  type="is-primary" label="Send transaction" pack="fas" icon-right="file-import" @click="buy($store.state.account)"/>
      </div>

      <div v-if="key=='Sell'">
        <b-field class="textt" label-position="inside" label="Input assetID you sell">
          <b-input expanded @input.native="astIn($event)" v-model="assetIn"></b-input>
        </b-field>
        <b-field class="textt" label-position="inside" label="Input assetID you want to buy">
          <b-input expanded @input.native="astOut($event)" v-model="assetOut"></b-input>
        </b-field>
        <b-field class="textt" label-position="inside" label="Input amount">
          <b-input expanded @input.native="amt($event)" v-model="amount"></b-input>
        </b-field>
        <b-field class="textt" label-position="inside" label="Input max limit of asset you want to provide">
          <b-input expanded @input.native="mxLmt($event)" v-model="maxLimit"></b-input>
        </b-field>
        <b-field class="textt" label-position="inside" label="Do you want to apply discount if possible?">
          <b-switch v-model="discount"></b-switch>
        </b-field>
        <b-button class="buttonn" expanded  type="is-primary" label="Send transaction" pack="fas" icon-right="file-import" @click="sell($store.state.account)"/>
      </div>

    </div>
  </template>
  
  <script lang="ts">
    import { ApiPromise, WsProvider, Keyring } from '@polkadot/api'
    import { defineComponent } from '@vue/composition-api'
    import '@polkadot/api-augment';
    import { web3FromAddress } from "@polkadot/extension-dapp"
    import { Builder } from '@paraspell/sdk'
  
    export default defineComponent({
      name: "RelayToPara",
  
      data() {
        return {
          items: [] as Array<string>,   //Stores Parachains connected to Relay chain
          key: "" as string,   //Selected XYK action
          assetIn: -1, //Stores asset that is traded in 
          assetOut: -1, //Stores asset that is traded out
          amount: -1, //Stores amount of asset that is traded in
          maxLimit: -1, //Stores maximum amount of asset that can be traded
          discount: false, //Stores if discount is applied
          assetA: -1, //Stores asset A
          assetB: -1, //Stores asset B
          amountA: -1, //Stores amount of asset A
          amountB: -1, //Stores amount of asset B
          amountBMaxLimit: -1, //Stores maximum amount of asset B that can be traded
          liquidityAmount: -1, //Stores amount of liquidity
        };
      },
  
      mounted: async function () {
        this.items.push("Add liquidity")
        this.items.push("Remove liquidity")
        this.items.push("Create pool")
        this.items.push("Buy")
        this.items.push("Sell")

      },
      methods:{
        
        //Stores asset that is traded in
        // eslint-disable-next-line 
        astIn: function (event: any) {
          this.assetIn = event.target.value
        },

        //Stores asset that is traded out
        // eslint-disable-next-line 
        astOut: function (event: any) {
          this.assetOut = event.target.value
        },

        //Stores amount of asset that is traded in
        // eslint-disable-next-line 
        amt: function (event: any) {
          this.amount = event.target.value
        },

        //Stores maximum amount of asset that can be traded
        // eslint-disable-next-line 
        mxLmt: function (event: any) {
          this.maxLimit = event.target.value
        },

        //Stores asset A
        // eslint-disable-next-line 
        astA: function (event: any) {
          this.assetA = event.target.value
        },

        //Stores asset B
        // eslint-disable-next-line 
        astB: function (event: any) {
          this.assetB = event.target.value
        },

        //Stores amount of asset A
        // eslint-disable-next-line 
        amtA: function (event: any) {
          this.amountA = event.target.value
        },

        //Stores amount of asset B
        // eslint-disable-next-line 
        amtB: function (event: any) {
          this.amountB = event.target.value
        },

        //Stores maximum amount of asset B that can be traded
        // eslint-disable-next-line 
        amtBMaxLmt: function (event: any) {
          this.amountBMaxLimit = event.target.value
        },

        //Stores amount of liquidity
        // eslint-disable-next-line 
        lqdtyAmt: function (event: any) {
          this.liquidityAmount = event.target.value
        },

        //Stores amoun
        // eslint-disable-next-line 
        amtMxB: function (event: any) {
          this.amountBMaxLimit = event.target.value
        },


        async buy(address: string){
          //We check if all details for call are assigned
          if(this.assetIn == -1 || this.assetOut == -1 || this.amount == -1 || this.maxLimit == -1){
            this.$notify({ title: 'Error', text: 'Please fill all the details.', type: 'error', duration: 3000,speed: 100})
            return
          }

          //create api and connect to Basilisk
          const wsProvider = new WsProvider('ws://127.0.0.1:9988');
          const api = await ApiPromise.create({ provider: wsProvider });

          //create keyring
          const keyring = new Keyring({ type: 'sr25519' });

          // eslint-disable-next-line 
          let discounted:any 
          if(this.discount == true){
            discounted = "Yes"
          }
          else{
            discounted = "No"
          }

          //We have prebuilt account login
          if(address == "Alice" || address == "Bob" || address == "Charlie" || address== "Dave" || address == "Eve" || address == "Ferdie"){      
                var account = "//"+address     
                Builder(api)
                .buy()
                .assetOut(this.assetOut)
                .assetIn(this.assetIn)
                .amount(this.amount)
                .maxLimit(this.maxLimit)
                .discount(discounted)
                .build()
                .signAndSend(keyring.createFromUri(account), ({ status }) => {
                  if (status.isInBlock) {
                    console.log(`Successful buy with hash ${status.asInBlock}`);
                  } else {
                    console.log(`Current status: ${status.type}`);
                  }
                });
          }
          //We have custom account login
          else{
            const injector = await web3FromAddress(address);
            Builder(api)
            .buy()
            .assetOut(this.assetOut)
            .assetIn(this.assetIn)
            .amount(this.amount)
            .maxLimit(this.maxLimit)
            .discount(discounted)
            .build()
            .signAndSend(address, { signer: injector.signer }, ({ status }) => {
              if (status.isInBlock) {
                console.log(`Successful buy with hash ${status.asInBlock}`);
              } else {
                console.log(`Current status: ${status.type}`);
              }
            });
          }
        },
        async sell(address: string){
          //We check if all details for call are assigned
          if(this.assetIn == -1 || this.assetOut == -1 || this.amount == -1 || this.maxLimit == -1){
            this.$notify({ title: 'Error', text: 'Please fill all the details.', type: 'error', duration: 3000,speed: 100})
            return
          }

          //create api and connect to Basilisk
          const wsProvider = new WsProvider('ws://127.0.0.1:9988');
          const api = await ApiPromise.create({ provider: wsProvider });

          //create keyring
          const keyring = new Keyring({ type: 'sr25519' });
          
          // eslint-disable-next-line 
          let discounted:any 
          if(this.discount == true){
            discounted = "Yes"
          }
          else{
            discounted = "No"
          }

          //We have prebuilt account login
          if(address == "Alice" || address == "Bob" || address == "Charlie" || address== "Dave" || address == "Eve" || address == "Ferdie"){      
                var account = "//"+address   
                Builder(api)
                .sell()
                .assetIn(this.assetIn)
                .assetOut(this.assetOut)
                .amount(this.amount)
                .maxLimit(this.maxLimit)
                .discount(discounted)
                .build()
                .signAndSend(keyring.createFromUri(account), ({ status }) => {
                  if (status.isInBlock) {
                    console.log(`Successful sell with hash ${status.asInBlock}`);
                  } else {
                    console.log(`Current status: ${status.type}`);
                  }
                });
              }
          //We have custom account login
          else{
            const injector = await web3FromAddress(address);
            Builder(api)
            .sell()
            .assetIn(this.assetIn)
            .assetOut(this.assetOut)
            .amount(this.amount)
            .maxLimit(this.maxLimit)
            .discount(discounted)
            .build()
            .signAndSend(address, { signer: injector.signer }, ({ status }) => {
              if (status.isInBlock) {
                console.log(`Successful sell with hash ${status.asInBlock}`);
              } else {
                console.log(`Current status: ${status.type}`);
              }
            });
          }
        },
        async createPool(address: string){
          //We check if all details for call are assigned
          if(this.assetA == -1 || this.assetB == -1 || this.amountA == -1 || this.amountB == -1){
            this.$notify({ title: 'Error', text: 'Please fill all the details.', type: 'error', duration: 3000,speed: 100})
            return
          }

          const wsProvider = new WsProvider('ws://127.0.0.1:9988');
          const api = await ApiPromise.create({ provider: wsProvider });

          //create keyring
          const keyring = new Keyring({ type: 'sr25519' });

          //We have prebuilt account login
          if(address == "Alice" || address == "Bob" || address == "Charlie" || address== "Dave" || address == "Eve" || address == "Ferdie"){      
                var account = "//"+address 
                Builder(api)
                .createPool()
                .assetA(this.assetA)
                .amountA(this.amountA)
                .assetB(this.assetB)
                .amountB(this.amountB)
                .build()             
                .signAndSend(keyring.createFromUri(account), ({ status }) => {
                  if (status.isInBlock) {
                    console.log(`Successful create pool with hash ${status.asInBlock}`);
                  } else {
                    console.log(`Current status: ${status.type}`);
                  }
                });
              }
          //We have custom account login
          else{
            const injector = await web3FromAddress(address);
            Builder(api)
            .createPool()
            .assetA(this.assetA)
            .amountA(this.amountA)
            .assetB(this.assetB)
            .amountB(this.amountB)
            .build()             
            .signAndSend(address, { signer: injector.signer }, ({ status }) => {
              if (status.isInBlock) {
                console.log(`Successful create pool with hash ${status.asInBlock}`);
              } else {
                console.log(`Current status: ${status.type}`);
              }
            });
          }
        },
        async addLiquidity(address: string){
          //We check if all details for call are assigned
          if(this.assetA == -1 || this.assetB == -1 || this.amountA == -1 || this.amountB == -1){
            this.$notify({ title: 'Error', text: 'Please fill all the details.', type: 'error', duration: 3000,speed: 100})
            return
          }

          const wsProvider = new WsProvider('ws://127.0.0.1:9988');
          const api = await ApiPromise.create({ provider: wsProvider });

          //create keyring
          const keyring = new Keyring({ type: 'sr25519' });

          //We have prebuilt account login
          if(address == "Alice" || address == "Bob" || address == "Charlie" || address== "Dave" || address == "Eve" || address == "Ferdie"){      
                var account = "//"+address 
                Builder(api)
                .addLiquidity()
                .assetA(this.assetA)
                .assetB(this.assetB)
                .amountA(this.amountA)
                .amountBMaxLimit(this.amountBMaxLimit)
                .build()
                .signAndSend(keyring.createFromUri(account), ({ status }) => {
                  if (status.isInBlock) {
                    console.log(`Successful add liquidity with hash ${status.asInBlock}`);
                  } else {
                    console.log(`Current status: ${status.type}`);
                  }
                }
              );  
            }
          //We have custom account login
          else{
            const injector = await web3FromAddress(address);
            Builder(api)
            .addLiquidity()
            .assetA(this.assetA)
            .assetB(this.assetB)
            .amountA(this.amountA)
            .amountBMaxLimit(this.amountBMaxLimit)
            .build()
            .signAndSend(address, { signer: injector.signer }, ({ status }) => {
              if (status.isInBlock) {
                console.log(`Successful add liquidity with hash ${status.asInBlock}`);
              } else {
                console.log(`Current status: ${status.type}`);
              }
            }
          );  
          }
        },
        async removeLiquidity(address: string){
          //We check if all details for call are assigned
          if(this.assetA == -1 || this.assetB == -1 || this.liquidityAmount == -1){
            this.$notify({ title: 'Error', text: 'Please fill all the details.', type: 'error', duration: 3000,speed: 100})
            return
          }

          const wsProvider = new WsProvider('ws://127.0.0.1:9988');
          const api = await ApiPromise.create({ provider: wsProvider });

          //create keyring
          const keyring = new Keyring({ type: 'sr25519' });

          //We have prebuilt account login
          if(address == "Alice" || address == "Bob" || address == "Charlie" || address== "Dave" || address == "Eve" || address == "Ferdie"){      
                var account = "//"+address 
                Builder(api)
                .removeLiquidity()
                .assetA(this.assetA)
                .assetB(this.assetB)
                .liquidityAmount(this.liquidityAmount)
                .build()
                .signAndSend(keyring.createFromUri(account), ({ status }) => {
                  if (status.isInBlock) {
                    console.log(`Successful remove liquidity with hash ${status.asInBlock}`);
                  } else {
                    console.log(`Current status: ${status.type}`);
                  }
                });
              }
          //We have custom account login
          else{
            const injector = await web3FromAddress(address);
            Builder(api)
            .removeLiquidity()
            .assetA(this.assetA)
            .assetB(this.assetB)
            .liquidityAmount(this.liquidityAmount)
            .build()
            .signAndSend(address, { signer: injector.signer }, ({ status }) => {
              if (status.isInBlock) {
                console.log(`Successful remove liquidity with hash ${status.asInBlock}`);
              } else {
                console.log(`Current status: ${status.type}`);
              }
            });
          }
        },
        }
    })
  </script>
  
  <style scoped>
    @import url("https://fonts.googleapis.com/css2?family=Anybody:wght@300&family=BIZ+UDGothic&family=Pacifico&display=swap");
  
    #app {
      font-family: Avenir, Helvetica, Arial, sans-serif;
      -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale;
      text-align: center;
      color: #2c3e50;
      background-color: white;
      margin-top: 20px;
      margin-left: 20%;
      margin-right: 20%;
    }
    .textt{
      color: black;
      font-family: "Anybody", cursive;
      font-size: 30px;
      margin-bottom: 20px;
    }
  </style>
  