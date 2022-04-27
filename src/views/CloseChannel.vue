<template>
  <div class="home">
    <b-field class="textt" label="Currently there are following channels:"></b-field>
    <b-field class="paras" v-for="(channel) in channelsOpen" :key="channel">{{channel}}</b-field>
      <b-field class="textt" label="Select parachain you wish to close channels for.">
      <b-select v-model="key" @input.native="para($event)" placeholder="Select parachain 2" required>
      <option v-for="(item) in items" :key="item">{{item}}</option>
      </b-select>
      </b-field>
      <b-button class="buttonn"  type="is-primary" @click="closeChannels">Close parachain channels</b-button>
      <b-button class="buttonn"  tag="router-link" to="/menu" type="is-link">Back to main menu</b-button>
  
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
      channelss: [] as Array<string>,
      channelsOpen: [] as Array<string>,
      key: 0 as number,
      };
    },
  methods: {
    async closeChannels() {
      if(this.key != 0){
        var invalid = 1
        for (let i=0;i<this.senders.length;i++)
        {
          if(this.key == this.senders[i])
          {
            invalid = 0
          }
        }
        if(invalid == 0){
            this.$notify({ title: 'Request', text: 'Channels for chosen parachain are currently being closed.', duration: 4000,speed: 100})
            const keyring = new Keyring({ type: 'sr25519' });
            const wsProvider = new WsProvider('ws://127.0.0.1:9944');
            const api = await ApiPromise.create({ provider: wsProvider });
            const bob = keyring.addFromUri('//Alice', { name: 'Alice default' });
            const call2 = api.tx.hrmp.forceCleanHrmp(this.key,0,0);  
            const close = await api.tx.sudo.sudo(call2).signAndSend(bob, (result) => { console.log(result.toHuman()) });
            await new Promise(resolve => setTimeout(resolve, 4000));
            this.$notify({ title: 'Success', text: 'Your parachain of choice should have channels closed.', type: "success", duration: 10000,speed: 100})

        }
        else{
          this.$notify({ title: 'Error', text: 'There are no channels for this parachain currently open.', type:'error', duration: 4000,speed: 100})
        }
      }
      else{
        this.$notify({ title: 'Error', text: 'You have not chosen parachain you wish to close channels for.', type: "error", duration: 10000,speed: 100})
      }

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
        //console.log(`${bob.meta.name}: has address ${bob.address}`);
        const channels = await api.query.hrmp.hrmpChannels.entries()
        channels.forEach(([{ args: [era, nominatorId] }, value]) => {
        this.channelss.push(JSON.stringify(era))    });
        const leng = this.channelss.length 
        for (let i=0; i<leng;i++)
        {
            var result = this.channelss[i]
            var res = []
            //this.channelss.shift();
            res = result.split('{"sender":').join(',').split(',"recipient":').join(',').split('}').join(',').split(',')
            res.shift()
            res.pop()
            const newArr = res.map((i) => Number(i));
            this.senders.push(newArr[0])
            this.recipients.push(newArr[1])

        }
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
        for(let i=0;leng>i;i++)
        {
          var count = i+1
          this.channelsOpen.push("Channel " + count + " - Parachain 1: " + this.senders[i] + " Parachain 2: " + this.recipients[i])
        }
        //console.log(this.channelss)
    //const queryPara = JSON.stringify(parachain)
    //const newParas = queryPara.split('[').join(',').split(']').join(',').split(',')
    //const results = newParas.filter(element => {return element !== "";});
    //const extractedParas = results.map((i) => Number(i));
    //for (let i=0;extractedParas.length>i; i++)
    //{
    //  this.items.push(extractedParas[i])
    //}
    },
  })
  
</script>
<style scoped>
.buttonn{
  margin-top: 20px;
  margin-left: auto;
  margin-right: auto;
  width: 800px;
  display: block;
}
.textt{
  color: black;
  font-family: "Anybody", cursive;
  font-size: 30px;
}
.paras{
  display: block;
  margin-bottom: 10px;
}
</style>
