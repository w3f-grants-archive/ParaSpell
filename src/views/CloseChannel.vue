<template>
  <div id="app">
    <b-field style="margin-top:35%; margin-bottom: 8%;" class="textt" label="Currently there are following channels:"></b-field>
    <b-field class="paras" v-for="(channel) in channelsOpen" :key="channel">{{channel}}
      <b-button type=" is-danger" outlined style="margin-top:-10px; margin-left:10px" @click="closeChannels(channel)" label="Close"></b-button>
    </b-field>
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
      senders: [] as Array<number>,
      recipients: [] as Array<number>,
      sendersstr: [] as Array<string>,
      recipientsstr: [] as Array<string>,
      channelss: [] as Array<string>,
      channelsOpen: [] as Array<string>,
      key: 0 as number,
      };
    },
  methods: {
    async closeChannels(channel: any) {
      var closingC = channel.split(": ")
      var closingCha = closingC[1].split(" =>")
      var paraID = 0
      if(closingCha[0] == "Karura")
      {
        paraID = 2000
      }
      else if(closingCha[0] == "Basilisk")
      {
        paraID = 2090
      }
      this.$notify({ title: 'Request', text: 'Channels for chosen parachain are currently being closed.', duration: 4000,speed: 100})
      const keyring = new Keyring({ type: 'sr25519' });
      const wsProvider = new WsProvider('ws://127.0.0.1:9944');
      const api = await ApiPromise.create({ provider: wsProvider });
      const bob = keyring.addFromUri('//Alice', { name: 'Alice default' });
      const call2 = api.tx.hrmp.forceCleanHrmp(paraID,0,0);  
      const close = await api.tx.sudo.sudo(call2).signAndSend(bob, (result) => { console.log(result.toHuman()) });
      await new Promise(resolve => setTimeout(resolve, 4000));
      this.$notify({ title: 'Success', text: 'Your parachain of choice should have channels closed.', type: "success", duration: 10000,speed: 100})

    },
    async para(value: any){
        this.key=value.target.value
    },
  },
  mounted: async function () {
    const keyring = new Keyring({ type: 'sr25519' });
    const wsProvider = new WsProvider('ws://127.0.0.1:9944');
    const api = await ApiPromise.create({ provider: wsProvider });
    const bob = keyring.addFromUri('//Alice', { name: 'Alice default' });
    const channels = await api.query.hrmp.hrmpChannels.entries()
    channels.forEach(([{ args: [era, nominatorId] }, value]) => {
    this.channelss.push(JSON.stringify(era))    });
    const leng = this.channelss.length 
    for (let i=0; i<leng;i++)
    {
      var result = this.channelss[i]
      var res = []
      res = result.split('{"sender":').join(',').split(',"recipient":').join(',').split('}').join(',').split(',')
      res.shift()
      res.pop()
      const newArr = res.map((i) => Number(i));
      this.senders.push(newArr[0])
      this.recipients.push(newArr[1])
      if(newArr[0] == 2000)
        this.sendersstr.push("Karura")
      else if(newArr[0] == 2090)
        this.sendersstr.push("Basilisk")
      if(newArr[1] == 2000)
        this.recipientsstr.push("Karura")
      else if(newArr[1] == 2090)
        this.recipientsstr.push("Basilisk")


    }
    const parachain = await api.query.paras.parachains()
    const queryPara = JSON.stringify(parachain)
    const newParas = queryPara.split('[').join(',').split(']').join(',').split(',')
    const results = newParas.filter(element => {return element !== "";});
    const extractedParas = results.map((i) => Number(i));
    for (let i=0;extractedParas.length>i; i++)
    {
      this.items.push(extractedParas[i])
    }
    for(let i=0;leng>i;i++)
    {
      var count = i+1
      
      this.channelsOpen.push("Channel " + count + ": " + this.sendersstr[i] + " => " + this.recipientsstr[i])
    }
  },
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

.textt{
  color: black;
  font-family: "Anybody", cursive;
  font-size: 30px;
}
.paras{
  display: block;
  margin-bottom: 30px;
}
</style>
