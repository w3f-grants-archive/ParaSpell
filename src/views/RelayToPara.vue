<template>
  <div class="home">
    <b-field class="textt" label="Select parachain you wish to transfer to">
    <b-select v-model="key" @input.native="para($event)" placeholder="Select parachain 1" required>
      <option v-for="(item) in items" :key="item">{{item}}</option>
    </b-select>
    </b-field>
    <b-field class="textt" label="Select account you wish to transfer tokens to">
    <b-select v-model="recipient" @input.native="address($event)" placeholder="Select address" required>
      <option v-for="(account) in accounts" :key="account.account_id">{{account.account_id}} Balance: {{account.unitbalance}}</option>
    </b-select>
    </b-field>
    <b-field class="textt" label="Input UNIT amount (Minimum 1000000000000)">
        <b-input style="margin-right:auto; margin-left:auto; width: 800px" @input.native="unit($event)" v-model="amount"></b-input>
    </b-field>
    <b-button class="buttonn"  type="is-primary" @click="sendXCM">Send transaction</b-button>
    <b-button class="buttonn"  tag="router-link" to="/send" type="is-link">Back to send menu</b-button>
  </div>
</template>
<script lang="ts">
  import { Keyring } from '@polkadot/api'
  import { ApiPromise, WsProvider } from '@polkadot/api'
  import { defineComponent } from '@vue/composition-api'
  import { encodeAddress } from '@polkadot/util-crypto'
    import '@polkadot/api-augment';

  export default defineComponent({
  
  data() {
    return {
      items: [] as Array<number>,
      key: 0 as number,
      amount: 0 as number,
      accounts: [] as Array<any>,
      recipient: "" as string,
      };
    },

  mounted: async function () {
    const keyring = new Keyring({ type: 'sr25519' });
    const wsProvider = new WsProvider('ws://127.0.0.1:9944');
    const api = await ApiPromise.create({ provider: wsProvider });
    const bob = keyring.addFromUri('//Alice', { name: 'Alice default' });
    //console.log(`${bob.meta.name}: has address ${bob.address}`);
    const parachain = await api.query.paras.parachains()
    const queryPara = JSON.stringify(parachain)
    const newParas = queryPara.split('[').join(',').split(']').join(',').split(',')
    const results = newParas.filter(element => {return element !== "";});
    const extractedParas = results.map((i) => Number(i));
    for (let i=0;extractedParas.length>i; i++)
    {
      this.items.push(extractedParas[i])
    }
    },

    methods: {
        async para(value: any){
            this.key=value.target.value
            this.accounts = []
            var unitbalance=""
            const keyring = new Keyring({ type: 'sr25519' });

                // our default dev addresses with hard derivation
                // (no mnemonic, defaulted to known)
            var accs = []
            accs.push(keyring.createFromUri('//Alice').address);
            accs.push(keyring.createFromUri('//Bob').address);
            accs.push(keyring.createFromUri('//Charlie').address);
            accs.push(keyring.createFromUri('//Dave').address);
            accs.push(keyring.createFromUri('//Eve').address);
            accs.push(keyring.createFromUri('//Ferdie').address);
            if(this.key == 2090){
                const keyring = new Keyring({ type: 'sr25519' });
                const wsProvider = new WsProvider('ws://127.0.0.1:9988');
                const api = await ApiPromise.create({ provider: wsProvider });
                for (let acc = 0; acc < accs.length; acc++) {
                    let account_id = accs[acc]
                    const balance = await api.query.tokens.accounts(account_id, 3)
                    unitbalance = JSON.stringify(balance)
                    this.accounts.push({ account_id,unitbalance});
                }
            }
            if(this.key == 2000){
                const wsProvider = new WsProvider('ws://127.0.0.1:9999');
                const api = await ApiPromise.create({ provider: wsProvider });
                for (let acc = 0; acc < accs.length; acc++) {
                    let account_id = accs[acc]
                    const balance = await api.query.tokens.accounts(account_id, {Token: "KSM"})
                    unitbalance = JSON.stringify(balance)
                    this.accounts.push({ account_id,unitbalance});
                }
            }
    },
        async address(value: any){
        this.recipient=value.target.value
      },
      async unit(value: any){
        this.amount=value.target.value
      },
      async sendXCM() {
        if(this.key == 0) 
        {
          this.$notify({ title: 'Error', text: 'You need to select parachain first.', type: 'error', duration: 3000,speed: 100})

        }
        else 
        {
            if(this.recipient=="")
            {
                this.$notify({ title: 'Error', text: 'You need to select recipient first.', type: 'error', duration: 3000,speed: 100})
            }
            else{
                if(this.amount<1000000000000)
                {
                    this.$notify({ title: 'Error', text: 'Specified amount is less than required {1000000000000}.', type: 'error', duration: 3000,speed: 100})
                }
                else{
                        const keyring = new Keyring({ type: 'sr25519' });
                        var accs = []
                        accs.push(keyring.createFromUri('//Alice'));
                        accs.push(keyring.createFromUri('//Bob'));
                        accs.push(keyring.createFromUri('//Charlie'));
                        accs.push(keyring.createFromUri('//Dave'));
                        accs.push(keyring.createFromUri('//Eve'));
                        accs.push(keyring.createFromUri('//Ferdie'));
                        const wsProvider = new WsProvider('ws://127.0.0.1:9944');
                        const api = await ApiPromise.create({ provider: wsProvider });
                        const recipientAddr = this.recipient.split(" Balance:")
                        const finalKeyring=[]
                        for(let acc = 0; acc< accs.length;acc++)
                        {
                          if(accs[acc].address == recipientAddr[0])
                          {
                            finalKeyring.push(accs[acc])
                          }
                        }
                        console.log(finalKeyring[0].address)
                        const call = api.tx.xcmPallet.reserveTransferAssets({V1: { parents:0, interior:{ X1: {Parachain: this.key}}}}, 
                        {V1:{parents:0,interior:{X1:{AccountId32: {network: "Any", id: "bXmPf7DcVmFuHEmzH3UX8t6AUkfNQW8pnTeXGhFhqbfngjAak"}}}}},
                        {V1: [{id: {Concrete: {parents:0, interior: "Here"}}, fun:{ Fungible: this.amount}}]},0).signAndSend(keyring.createFromUri('//Alice'), (result) => { console.log(result) })
                        this.$notify({ text: 'Your transfer is now processsing, refresh this page in few seconds to see changes.', duration: 10000,speed: 100})

                }
            }
        }
      }
    }
  })

</script>
<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Anybody:wght@300&family=BIZ+UDGothic&family=Pacifico&display=swap");
.buttonn{
  margin-top: 20px;
  margin-left: auto;
  margin-right: auto;
  width: 800px;
  display: block;
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
