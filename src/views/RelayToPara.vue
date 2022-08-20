<template>
  <div id="app">
    
    <div class="box" style="margin-top: 25%;  font-family: 'Anybody', cursive;">
      You are logged in as {{$store.state.account}}.
    </div>
    
    <b-field class="textt" label-position="inside" label="Select destination parachain">
      <b-select expanded v-model="key" placeholder="Select parachain 1" required>
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
    
    <b-button class="buttonn" pack="fas" icon-right="file-import" expanded  type="is-primary" @click="sendXCM($store.state.account)">Send transaction</b-button>
  
  </div>
</template>

<script lang="ts">
  import { Keyring } from '@polkadot/api'
  import { ApiPromise, WsProvider } from '@polkadot/api'
  import { defineComponent } from '@vue/composition-api'
  import '@polkadot/api-augment';
  import { decodeAddress } from '@polkadot/util-crypto'
  import { web3FromAddress } from "@polkadot/extension-dapp"

  export default defineComponent({
    name: "RelayToPara",

    data() {
      return {
        items: [] as Array<string>,   //Stores Parachains connected to Relay chain
        key: "" as string,   //Selected destination parachain
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
        if (extractedParas[i] == 2090)
          this.items.push("Basilisk")
        else if(extractedParas[i]== 2000)
          this.items.push("Karura")
        else if(extractedParas[i]== 1000)
          this.items.push("Moonbeam")
      }

      //Currencies we can transfer in
      this.currencies.push("UNIT")
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
        if(this.key == "") 
        {
          this.$notify({ title: 'Error', text: 'You need to select parachain first.', type: 'error', duration: 3000,speed: 100})
        }
        else 
        {
          if(this.addr=="" )
          {
            this.$notify({ title: 'Error', text: 'You need to input recipient first.', type: 'error', duration: 3000,speed: 100})
          }
          else{
            if(this.amount<1000000000000)
            {
                this.$notify({ title: 'Error', text: 'Specified amount is less than required {1000000000000}.', type: 'error', duration: 3000,speed: 100})
            }
            else{
              var destPara = 0
              if(this.key == "Karura")
              {
                destPara= 2000
              } 
              else if(this.key == "Basilisk")
              {
                destPara=2090
              }
              else if(this.key == "Moonbeam")
              {
                destPara=1000
              }
              if(address == "none")
              {
                this.$notify({ text: 'You need to login first.',type: 'error', duration: 5000,speed: 100})
              }
              else{
                const keyring = new Keyring({ type: 'sr25519' });
                const wsProvider = new WsProvider('ws://127.0.0.1:9944');
                const api = await ApiPromise.create({ provider: wsProvider });
                var account = ""

                //If we have prefunded account login
                if(address == "Alice" || address == "Bob" || address == "Charlie" || address== "Dave" || address == "Eve" || address == "Ferdie")
                {
                  account = "//"+address
                  if(destPara ==2000 || destPara == 2090){

                    //API call for XCM transfer from Relay chain to Basilisk or Acala
                    api.tx.xcmPallet
                      .reserveTransferAssets(
                        {
                          V1: {
                            parents: 0,
                            interior: {
                              X1: {
                                Parachain: destPara
                              }
                            }
                          }
                        },
                        {
                          V1: {
                            parents: 0,
                            interior: {
                              X1: {
                                AccountId32: {
                                  network: "Any",
                                  id: api
                                    .createType("AccountId32", decodeAddress(this.addr))
                                    .toHex()
                                }
                              }
                            }
                          }
                        },
                        {
                          V1: [
                            {
                              id: {
                                Concrete: {
                                  parents: 0,
                                  interior: "Here"
                                }
                              },
                              fun: {
                                Fungible: this.amount
                              }
                            }
                          ]
                        },
                        0
                      )
                      .signAndSend(keyring.createFromUri(account), (result) => {
                        console.log(result);
                      });

                    
                    this.$notify({ text: 'Your transfer is now processsing, refresh this page in few seconds to see changes.', duration: 10000,speed: 100})
                  }
                  else if(destPara==1000){
                    
                    //API call for XCM transfer from Relay chain to Moonbeam
                    api.tx.xcmPallet
                      .reserveTransferAssets(
                        {
                          V1: {
                            parents: 0,
                            interior: {
                              X1: {
                                Parachain: destPara
                              }
                            }
                          }
                        },
                        {
                          V1: {
                            parents: 0,
                            interior: {
                              X1: {
                                AccountKey20: {
                                  network: "Any",
                                  key: this.addr
                                }
                              }
                            }
                          }
                        },
                        {
                          V1: [
                            {
                              id: {
                                Concrete: {
                                  parents: 0,
                                  interior: "Here"
                                }
                              },
                              fun: {
                                Fungible: this.amount
                              }
                            }
                          ]
                        },
                        0
                      )
                      .signAndSend(keyring.createFromUri(account), (result) => {
                        console.log(result);
                      });

                    this.$notify({ text: 'Your transfer is now processsing, refresh this page in few seconds to see changes.', duration: 10000,speed: 100})
                  }
                }

                //If injected wallet is logged in
                else
                {
                  const injector = await web3FromAddress(address); // finds an injector for an address
                  console.log(`polakdotSigner ===> injector: `,injector);

                  if(destPara ==2000 || destPara == 2090){

                    //API call for XCM transfer From Relay chain to Basilisk or Acala /w injected wallet
                    api.tx.xcmPallet
                      .reserveTransferAssets(
                        {
                          V1: {
                            parents: 0,
                            interior: {
                              X1: {
                                Parachain: destPara
                              }
                            }
                          }
                        },
                        {
                          V1: {
                            parents: 0,
                            interior: {
                              X1: {
                                AccountId32: {
                                  network: "Any",
                                  id: api
                                    .createType("AccountId32", decodeAddress(this.addr))
                                    .toHex()
                                }
                              }
                            }
                          }
                        },
                        {
                          V1: [
                            {
                              id: {
                                Concrete: {
                                  parents: 0,
                                  interior: "Here"
                                }
                              },
                              fun: {
                                Fungible: this.amount
                              }
                            }
                          ]
                        },
                        0
                      )
                      .signAndSend(address, { signer: injector.signer }, ({ status, txHash }) => {
                        console.log(`Transaction hash is ${txHash.toHex()}`);
                        if (status.isFinalized) {
                          console.log(`Transaction finalized at blockHash ${status.asFinalized}`);
                        }
                      });


                    this.$notify({ text: 'Your transfer is now processsing, refresh this page in few seconds to see changes.', duration: 10000,speed: 100})
                  }
                  else if(destPara==1000){
                    
                    //API call for XCM transfer from Relay chain to Moonbeam /w injected wallet
                    api.tx.xcmPallet
                      .reserveTransferAssets(
                        {
                          V1: {
                            parents: 0,
                            interior: {
                              X1: {
                                Parachain: destPara
                              }
                            }
                          }
                        },
                        {
                          V1: {
                            parents: 0,
                            interior: {
                              X1: {
                                AccountKey20: {
                                  network: "Any",
                                  key: this.addr
                                }
                              }
                            }
                          }
                        },
                        {
                          V1: [
                            {
                              id: {
                                Concrete: {
                                  parents: 0,
                                  interior: "Here"
                                }
                              },
                              fun: {
                                Fungible: this.amount
                              }
                            }
                          ]
                        },
                        0
                      )
                      .signAndSend(address, { signer: injector.signer }, (result) => {
                        console.log(result);
                      });

                    
                    this.$notify({ text: 'Your transfer is now processsing, refresh this page in few seconds to see changes.', duration: 10000,speed: 100})
                  }
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

  select {
    width: 150px;
    margin: 10px;
  }
  select:focus {
    min-width: 150px;
    width: auto;
  }
  .textt{
    color: black;
    font-family: "Anybody", cursive;
    font-size: 30px;
    margin-bottom: 20px;
  }
</style>
