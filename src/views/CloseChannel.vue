<template>
  <div id="app">
    <b-field style="margin-top:25%; margin-bottom: 8%;" class="textt" label="Currently there are following channels:"></b-field>
    <b-field class="paras" v-for="(channel) in channelsOpen" :key="channel">{{channel}}
      <b-button type=" is-danger" outlined style="margin-top:-10px; margin-left:10px" @click="closeChannels(channel)" pack="fas" icon-right="xmark"></b-button>
    </b-field>
  </div>
</template>
<script lang="ts">
  import { ApiPromise, WsProvider, Keyring } from '@polkadot/api'
  import { defineComponent } from '@vue/composition-api'
  import  * as closeChannel from "@paraspell/sdk"

  export default defineComponent({
  
    data() {
      return {
        senders: [] as Array<number>,   //Used in process of getting origin parachains from query
        recipients: [] as Array<number>,   //Used in process of getting destination parachains from query
        sendersstr: [] as Array<string>,   //Used in process of getting origin parachains from query
        recipientsstr: [] as Array<string>,   //Used in process of getting destination parachains from query
        channelss: [] as Array<string>,   //Used in process of getting origin & destination parachains from query
        channelsOpen: [] as Array<string>,    //Used to print open channels
      };
    },

    methods: {

      //Used to close channels from string returned when clicked close button
      // eslint-disable-next-line
      async closeChannels(channel: any) {

        var closingC = channel.split(": ")
        var closingCha = closingC[1].split(" =>")
        var paraID = 0
        var counter = 0

        //Constants used for connecting to RPC node & for specifying account that will create Close channel calls
        const keyring = new Keyring({ type: 'sr25519' });
        const wsProvider = new WsProvider('ws://127.0.0.1:9944');
        const api = await ApiPromise.create({ provider: wsProvider });
        const alice = keyring.addFromUri('//Alice', { name: 'Alice default' });

        //Here add your new node
        if(closingCha[0] == "Karura"){
          paraID = 2000
        }
        else if(closingCha[0] == "Pichiu"){
          paraID = 2001
        }
        else if(closingCha[0] == "Bifrost"){
          paraID = 3000
        }

        //API call to clean channels associated to specific parachain ID
        closeChannel.closeChannels.closeChannel(api,paraID,0,0).signAndSend(alice, ({status,txHash}) => 
        { 
          if(counter == 0) {
            this.$notify({ title: 'Request', text: `Channels for chosen parachain are currently being closed. Transaction hash is ${txHash.toHex()}`, duration: 10000,speed: 100})                    
            counter+=1
          }
          if (status.isFinalized) {
            this.$notify({ title: 'Success', text: 'Channels are successfuly closed. Refresh page in to see changes.', type: 'success', duration: 10000,speed: 100})
          }
        });
      },
    },

    mounted: async function () {
      const wsProvider = new WsProvider('ws://127.0.0.1:9944');
      const api = await ApiPromise.create({ provider: wsProvider });

      //Api call to query open Channels
      const channels = await api.query.hrmp.hrmpChannels.entries()
      
      //Process of extracting origin and destination nodes figuring in channels
      channels.forEach(([{ args: [era] }]) => {
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

        //Here add your new node
        if(newArr[0] == 2000)
          this.sendersstr.push("Karura")
        else if(newArr[0] == 2001)
          this.sendersstr.push("Pichiu")
        else if(newArr[0] == 3000)
          this.sendersstr.push("Bifrost")
        if(newArr[1] == 2000)
          this.recipientsstr.push("Karura")
        else if(newArr[1] == 2001)
          this.recipientsstr.push("Pichiu")
        else if(newArr[1] == 3000)
          this.recipientsstr.push("Bifrost")
      }

      for(let i=0;leng>i;i++)
      {
        var count = i+1
        
        this.channelsOpen.push("Channel " + count + ": " + this.sendersstr[i] + " => " + this.recipientsstr[i])
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
