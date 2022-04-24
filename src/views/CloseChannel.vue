<template>
  <div class="home">
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
    const channels = await api.query.hrmp.hrmpChannels()
    console.log(channels)
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
</style>
