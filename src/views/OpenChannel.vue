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
    <b-button expanded pack="fas" icon-right="code-compare" class="buttonn"  type="is-primary" @click="openChannels">Open channel</b-button>
  </div>
</template>

<script lang="ts">
  import { ApiPromise, WsProvider, Keyring } from '@polkadot/api'
  import { defineComponent } from '@vue/composition-api'
  import { Builder } from '@paraspell/sdk'

  export default defineComponent({
  
    data() {
      return {
        items: [] as Array<string>,
        key: "" as string,
        keyy: "" as string,
      };
    },

    mounted: async function () {
      const wsProvider = new WsProvider('ws://127.0.0.1:9944');
      const api = await ApiPromise.create({ provider: wsProvider });

      //Call to query parachains connected to Relay chain
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
        else if(extractedParas[i]== 2000)
          this.items.push("Karura")
        else if(extractedParas[i]== 2102)
          this.items.push("Pichiu")
      }
    },

    methods: {

      //Used to save selected parachain 1
      // eslint-disable-next-line
      async para(value: any){
        this.key=value.target.value
      },

      //Used to save selected parachain 2
      // eslint-disable-next-line 
      async paraa(value: any){
        this.keyy = value.target.value
      },

      //Used to open HRMP channels
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
          const alice = keyring.addFromUri('//Alice', { name: 'Alice default' });

          var para1:any
          var para2:any
          var counter = 0
          var counter2 = 0

          //Here add your new node
          if(this.key == "Karura")
            para1= "Karura"
          else if(this.key == "Pichiu")
            para1=  "Pichiu"
          else if(this.key == "Bifrost")
            para1="BifrostKusama"

          if(this.keyy == "Karura")
            para2= "Karura"
          else if(this.keyy == "Pichiu")
            para2= "Pichiu"
          else if(this.keyy == "Bifrost")
            para2= "BifrostKusama"

          //API call used to open first HRMP channel
           Builder(api).from(para1).to(para2).openChannel().maxSize(8).maxMessageSize(1000).build().signAndSend(alice, ({status,txHash}) => 
          {
            if(counter == 0){     
              this.$notify({ title: 'Opening channel 1', text:`You will get notified about channel status soon. Transaction hash ${txHash.toHex()}`, duration: 12000,speed: 100})
              counter+=1
            }
            if(status.isFinalized) {
              this.$notify({ title: 'Success', text: 'Channel1 is open, it might take a few seconds to appear in close channel screen.', type: 'success', duration: 10000,speed: 100})
            } 
          });

          await new Promise(resolve => setTimeout(resolve, 10000));

          //API call used to open second HRMP channel
          Builder(api).from(para2).to(para1).openChannel().maxSize(8).maxMessageSize(1000).build().signAndSend(alice, ({status,txHash}) => 
          {    
            if(counter2 == 0) {
              this.$notify({ title: 'Opening channel 2', text:`You will get notified about channel status soon. Transaction hash ${txHash.toHex()}`, duration: 12000,speed: 100})
              counter2+=1
            }
            if (status.isFinalized) {
              this.$notify({ title: 'Success', text: 'Channel2 is open, it might take a few seconds to appear in close channel screen.', type: 'success', duration: 10000,speed: 100})
            } 
          });
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
