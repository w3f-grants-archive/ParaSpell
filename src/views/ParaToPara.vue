<template>
  <div id="app">

    <div class="box" style="margin-top: 25%;  font-family: 'Anybody', cursive;">
      You are logged in as {{$store.state.account}}.
    </div>

    <b-field class="textt" label-position="inside" label="Select origin parachain">
      <b-select v-model="key" expanded  placeholder="Select parachain 1" required>
        <option v-for="(item) in items" :key="item">{{item}}</option>
      </b-select>
    </b-field>

    <b-field class="textt" label-position="inside" label="Select destination parachain">
      <b-select v-model="keyy" expanded placeholder="Select parachain 2" required>
        <option v-for="(item) in items" :key="item">{{item}}</option>
      </b-select>
    </b-field>

    <b-field class="textt" label-position="inside" label="Input recipient address">
      <b-input expanded @input.native="addrs($event)" v-model="addr"></b-input>
    </b-field>

    <b-field class="textt" label-position="inside" label="Select currency">
      <b-select expanded v-model="currency" @input.native="asignCur($event)" placeholder="Select currency" required>
        <option v-for="(currency) in currencies" :key="currency">{{currency}}</option>
      </b-select>
    </b-field>

    <b-field class="textt" label-position="inside" label="Input currency amount">
      <b-input expanded @input.native="unit($event)" v-model="amount"></b-input>
    </b-field>

    <b-button class="buttonn" expanded  type="is-primary" label="Send transaction" pack="fas" icon-right="file-import" @click="sendXCM($store.state.account)"/>

  </div>
</template>

<script lang="ts">
  import { ApiPromise, WsProvider, Keyring } from '@polkadot/api'
  import { defineComponent } from '@vue/composition-api' 
  import { web3FromAddress } from "@polkadot/extension-dapp"
  import '@polkadot/api-augment';
  import { Builder } from '@paraspell/sdk'

  export default defineComponent({
  
    data() {
      return {
        items: [] as Array<string>,   //Stores Parachains connected to Relay chain
        key: "" as string,   //Selected origin parachain
        keyy: "" as string,   //Selected destination parachain
        addr: "" as string,   //Recipient address is stored here
        amount: 0 as number,   //Required amount to be transfered is stored here
        currency: "" as string,   //Selected currency is stored here
        currencies: [] as Array<string>,   //Currently available currencies
      };
    },

    mounted: async function () {
      const wsProvider = new WsProvider('ws://127.0.0.1:9944');
      const api = await ApiPromise.create({ provider: wsProvider });

      //API call to query Parachains connected to Relay chain
      const parachain = await api.query.paras.parachains()

      const queryPara = JSON.stringify(parachain)
      const newParas = queryPara.split('[').join(',').split(']').join(',').split(',')
      const results = newParas.filter(element => {return element !== "";});
      const extractedParas = results.map((i) => Number(i));

      for (let i=0;extractedParas.length>i; i++)
      {

        //Here add your new node
        if (extractedParas[i] == 2001)
          this.items.push("Bifrost")
        else if(extractedParas[i] == 2000)
          this.items.push("Karura")
        else if(extractedParas[i] == 2102)
          this.items.push("Pichiu")
      }

      //Currencies we can transfer in
      this.currencies.push("KSM")
    },

    methods: {

      //Used to store recipient address
      // eslint-disable-next-line 
      async addrs(value: any){
        this.addr=value.target.value
      },

      //Used to store selected currency
      // eslint-disable-next-line 
      async asignCur(value: any){
        this.currency=value.target.value
      },

      //Used to store user required transfer amount
      // eslint-disable-next-line 
      async unit(value: any){
        this.amount=value.target.value
      },

      //Used to create XCM transfer
      async sendXCM(address: string) {
        if(this.key == "" || this.keyy=="" || this.key==this.keyy ) 
        {
          this.$notify({ title: 'Error', text: 'You probably did not asign parachains correctly.', type: 'error', duration: 3000,speed: 100})
        }
        else 
        {
          if(this.addr=="")
          {
            this.$notify({ title: 'Error', text: 'You need to input recipient first.', type: 'error', duration: 3000,speed: 100})
          }
          else{
            if(this.amount<1000000000000)
            {
              this.$notify({ title: 'Error', text: 'Specified amount is less than required {1000000000000}.', type: 'error', duration: 3000,speed: 100})
            }
            else{
              const keyring = new Keyring({ type: 'sr25519' });

              // eslint-disable-next-line 
              var para:any
              var counter = 0
              
              //Here add your new node
              if(this.keyy == "Bifrost")
                para = "BifrostKusama"
              else if (this.keyy == "Karura")
                para = "Karura"
              else if(this.keyy == "Pichiu")
                para = "Pichiu"

              //If we have prefunded account login
              if(address == "Alice" || address == "Bob" || address == "Charlie" || address== "Dave" || address == "Eve" || address == "Ferdie"){      
                var account = "//"+address 

                if(this.key == "Bifrost"){

                  const wsProvider = new WsProvider('ws://127.0.0.1:9995');
                  const api = await ApiPromise.create({ provider: wsProvider });
                    
                  //API call for XCM transfer from Bifrost to destination Parachain            
                  let promise = Builder(api).from("BifrostKusama").to(para).currency(this.currency).currencyId(0).amount(this.amount).address(this.addr).build()
                  promise.signAndSend(keyring.createFromUri(account), ({ status, txHash }) => {
                    if(counter == 0){    
                      this.$notify({ text: `Transaction hash is ${txHash.toHex()}`, duration: 10000,speed: 100})
                      counter++
                    }
                    if (status.isFinalized) {
                      this.$notify({ text: `Transaction finalized at blockHash ${status.asFinalized}`,type: 'success', duration: 10000,speed: 100})
                    }
                  });
                }

                else if(this.key == "Karura"){
                  const wsProvider = new WsProvider('ws://127.0.0.1:9999');
                  const api = await ApiPromise.create({ provider: wsProvider });
                    
                  //API call for XCM transfer from Acala to destination Parachain                  
                  let promise = Builder(api).from("Karura").to(para).currency(this.currency).currencyId(0).amount(this.amount).address(this.addr).build()
                  promise.signAndSend(keyring.createFromUri(account), ({ status, txHash }) => {
                    if(counter == 0){    
                      this.$notify({ text: `Transaction hash is ${txHash.toHex()}`, duration: 10000,speed: 100})
                      counter++
                    }
                    if (status.isFinalized) {
                      this.$notify({ text: `Transaction finalized at blockHash ${status.asFinalized}`,type: 'success', duration: 10000,speed: 100})
                    }
                  });
                }      
                               
                else if(this.key == "Pichiu"){
                  
                  const wsProvider = new WsProvider('ws://127.0.0.1:9991');
                  const api = await ApiPromise.create({ provider: wsProvider });
                    
                  //API call for XCM transfer from Pichiu to destination Parachain                  
                  let promise = Builder(api).from("Pichiu").to(para).currency(this.currency).currencyId(0).amount(this.amount).address(this.addr).build()
                  promise.signAndSend(keyring.createFromUri(account), ({ status, txHash }) => {
                    if(counter == 0){    
                      this.$notify({ text: `Transaction hash is ${txHash.toHex()}`, duration: 10000,speed: 100})
                      counter++
                    }
                    if (status.isFinalized) {
                      this.$notify({ text: `Transaction finalized at blockHash ${status.asFinalized}`,type: 'success', duration: 10000,speed: 100})
                    }
                  });
                }                     
              }

              //If injected wallet is logged in
              else{

                const injector = await web3FromAddress(address); 

                if(this.key == "Bifrost"){

                const wsProvider = new WsProvider('ws://127.0.0.1:9995');
                const api = await ApiPromise.create({ provider: wsProvider });

                //API call for XCM transfer from Bifrost to destination Parachain /w injected wallet
                let promise = Builder(api).from("BifrostKusama").to(para).currency(this.currency).currencyId(0).amount(this.amount).address(this.addr).build()
                promise.signAndSend(address, { signer: injector.signer },  ({ status, txHash }) => {
                  if(counter == 0){    
                      this.$notify({ text: `Transaction hash is ${txHash.toHex()}`, duration: 10000,speed: 100})
                      counter++
                    }
                    if (status.isFinalized) {
                      this.$notify({ text: `Transaction finalized at blockHash ${status.asFinalized}`,type: 'success',duration: 10000,speed: 100})
                    }
                });
              }
              else if(this.key == "Karura"){

                const wsProvider = new WsProvider('ws://127.0.0.1:9999');
                const api = await ApiPromise.create({ provider: wsProvider });
                  
                //API call for XCM transfer from Acala to destination Parachain /w injected wallet
                let promise = Builder(api).from("Karura").to(para).currency(this.currency).currencyId(0).amount(this.amount).address(this.addr).build()
                promise.signAndSend(address, { signer: injector.signer },  ({ status, txHash }) => {
                  if(counter == 0){    
                      this.$notify({ text: `Transaction hash is ${txHash.toHex()}`, duration: 10000,speed: 100})
                      counter++
                    }
                    if (status.isFinalized) {
                      this.$notify({ text: `Transaction finalized at blockHash ${status.asFinalized}`,type: 'success', duration: 10000,speed: 100})
                    }
                  });
                }  

              else if(this.key == "Pichiu"){

                const wsProvider = new WsProvider('ws://127.0.0.1:9991');
                const api = await ApiPromise.create({ provider: wsProvider });
                  
                //API call for XCM transfer from Pichiu to destination Parachain /w injected wallet
                let promise = Builder(api).from("Pichiu").to(para).currency(this.currency).currencyId(0).amount(this.amount).address(this.addr).build()
                promise.signAndSend(address, { signer: injector.signer },  ({ status, txHash }) => {
                  if(counter == 0){    
                      this.$notify({ text: `Transaction hash is ${txHash.toHex()}`, duration: 10000,speed: 100})
                      counter++
                    }
                    if (status.isFinalized) {
                      this.$notify({ text: `Transaction finalized at blockHash ${status.asFinalized}`, type: 'success',duration: 10000,speed: 100})
                    }
                  });
                } 
              }
            }
          }
        }
      }
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
