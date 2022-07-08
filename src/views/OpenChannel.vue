<template>
  <div id="app">
    <b-field style="margin-top:25%" label-position="inside" class="textt" label="Select parachain 1">
      <b-select placeholder="Parachain 1" expanded style="text-align: center;" v-model="key" @input.native="para($event)" required>
        <option v-for="(item) in items" :key="item">{{item}}</option>
      </b-select>
    </b-field>
    <b-field label-position="inside" class="textt" label="Select parachain 2">
      <b-select placeholder="Parachain 2" expanded style="text-align: center;" v-model="keyy" @input.native="paraa($event)" required>
        <option v-for="(item) in items" :key="item">{{item}}</option>
      </b-select>
    </b-field>
    <b-button expanded class="buttonn"  type="is-primary" @click="openChannels">Open channel</b-button>
  </div>
</template>
<script lang="ts">
  import { Keyring } from '@polkadot/api'
  import { ApiPromise, WsProvider } from '@polkadot/api'
  import { defineComponent } from '@vue/composition-api'

  export default defineComponent({
  
  data() {
    return {
      items: [] as Array<string>,
      key: "" as string,
      keyy: "" as string,
      };
    },

  mounted: async function () {
    const keyring = new Keyring({ type: 'sr25519' });
    const wsProvider = new WsProvider('ws://127.0.0.1:9944');
    const api = await ApiPromise.create({ provider: wsProvider });
    const bob = keyring.addFromUri('//Alice', { name: 'Alice default' });
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
  },

  methods: {
    async para(value: any){
      this.key=value.target.value
    },
    async paraa(value: any){
      this.keyy = value.target.value
    },
    async openChannels() {

      if(this.key == "" || this.keyy == "" || this.key == this.keyy) 
      {
        this.$notify({ title: 'Error', text: 'You need to select different parachains.', type: 'error', duration: 3000,speed: 100})

      }
      else 
      {
        
        const keyring = new Keyring({ type: 'sr25519' });
        const wsProvider = new WsProvider('ws://127.0.0.1:9944');
        const api = await ApiPromise.create({ provider: wsProvider });
        const bob = keyring.addFromUri('//Alice', { name: 'Alice default' });
        console.log(`${bob.meta.name}: has address ${bob.address}`);
        var para1 = 0
        var para2 = 0
        //Open HRMP channels
        if(this.key == "Karura")
        para1=2000
        else if(this.key == "Basilisk")
        para1=2090
        else if(this.key == "Moonbeam")
        para1=1000

        if(this.keyy == "Karura")
        para2=2000
        else if(this.keyy == "Basilisk")
        para2=2090
        else if(this.keyy == "Moonbeam")
        para2=1000

        const call = api.tx.parasSudoWrapper.sudoEstablishHrmpChannel(para1,para2,8,1000);
        const hrmp1 = await api.tx.sudo.sudo(call).signAndSend(bob, (result) => { console.log(result.toHuman()) });
        this.$notify({ title: 'Opening channel 1', text: 'Channel 2 will open in 10 seconds.', duration: 10000,speed: 100})
        await new Promise(resolve => setTimeout(resolve, 10000));
        const call2 = api.tx.parasSudoWrapper.sudoEstablishHrmpChannel(para2,para1,8,1000);
        const hrmp2 = await api.tx.sudo.sudo(call2).signAndSend(bob, (result) => { console.log(result.toHuman()) });
        this.$notify({ title: 'Opening channel 2', text: 'This will take 10 seconds', duration: 10000,speed: 100})
        await new Promise(resolve => setTimeout(resolve, 10000));
        this.$notify({ title: 'Success', text: 'Channels should be open within minute from now.', type: 'success', duration: 10000,speed: 100})
      }
    }
  }
})

</script>
<style scoped>
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

@import url("https://fonts.googleapis.com/css2?family=Anybody:wght@300&family=BIZ+UDGothic&family=Pacifico&display=swap");

.textt{
  color: black;
  font-family: "Anybody", cursive;
  font-size: 30px;
  margin-bottom: 20px;
}
</style>
