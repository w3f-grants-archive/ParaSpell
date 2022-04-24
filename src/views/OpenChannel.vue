<template>
  <div class="home">
    <b-field class="textt" label="Select parachain 1">
    <b-select v-model="key" @input.native="para($event)" placeholder="Select parachain 1" required>
      <option v-for="(item) in items" :key="item">{{item}}</option>
    </b-select>
    </b-field>
    <b-field class="textt" label="Select parachain 2">
    <b-select v-model="keyy" @input.native="paraa($event)" placeholder="Select parachain 2" required>
      <option v-for="(item) in items" :key="item">{{item}}</option>
    </b-select>
    </b-field>
    <b-button class="buttonn"  type="is-primary" @click="openChannels">Open channel</b-button>
    <b-button class="buttonn"  tag="router-link" to="/home" type="is-link">Back to main menu</b-button>
  </div>
</template>
<script lang="ts">
  import { Keyring } from '@polkadot/api'
  import { ApiPromise, WsProvider } from '@polkadot/api'
  import { defineComponent } from '@vue/composition-api'

  export default defineComponent({
  
  data() {
    return {
      items: [] as Array<number>,
      key: 0 as number,
      keyy: 0 as number,
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
      },
      async paraa(value: any){
        this.keyy = value.target.value
      },
      async openChannels() {
        if(this.key == 0 || this.keyy == 0 || this.key == this.keyy) 
        {
          this.$notify('You have to select different parachains first!')
        }
        else 
        {
          //import keyring from "@polkadot/ui-keyring"
          const keyring = new Keyring({ type: 'sr25519' });
          const wsProvider = new WsProvider('ws://127.0.0.1:9944');
          const api = await ApiPromise.create({ provider: wsProvider });
          const bob = keyring.addFromUri('//Alice', { name: 'Alice default' });
          console.log(`${bob.meta.name}: has address ${bob.address}`);

          //Open HRMP channels
          const call = api.tx.parasSudoWrapper.sudoEstablishHrmpChannel(this.key,this.keyy,8,1000);
          const hrmp1 = await api.tx.sudo.sudo(call).signAndSend(bob, (result) => { console.log(result.toHuman()) });
          this.$notify('Opening channel 1 channel 2 will open in 6 seconds.')
          await new Promise(resolve => setTimeout(resolve, 6000));
          const call2 = api.tx.parasSudoWrapper.sudoEstablishHrmpChannel(this.keyy,this.key,8,1000);
          const hrmp2 = await api.tx.sudo.sudo(call2).signAndSend(bob, (result) => { console.log(result.toHuman()) });
          this.$notify('Opening channel 2.')
          await new Promise(resolve => setTimeout(resolve, 6000));
          this.$notify('Channels should be open now.')
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
