<template>
        <b-field style="margin-top:25%"  class="textt" label="Please wait while application is setting up for first time."></b-field>
</template>

<script lang="ts">
  import { Keyring } from '@polkadot/api'
  import { ApiPromise, WsProvider } from '@polkadot/api'
  import { defineComponent } from '@vue/composition-api'

export default defineComponent({
  mounted: async function () {

    //We register currency
    const keyring = new Keyring({ type: 'sr25519' });
    //basilisk
    const wsProvider = new WsProvider('ws://127.0.0.1:9989');
    const api = await ApiPromise.create({ provider: wsProvider });
    //acala
    const wsProvider2 = new WsProvider('ws://127.0.0.1:9988');
    const api2 = await ApiPromise.create({ provider: wsProvider2 });

    const bob = keyring.addFromUri('//Alice', { name: 'Alice default' });
    const quer = await api.query.assetRegistry.assetIds.entries()
    const query = await api2.query.assetRegistry.assetMetadatas.entries()

    if(quer.length<4 && query.length<1){
      //register asset Basilisk
      const call = api.tx.assetRegistry.register("UNIT","Token",0);
      const result = await api.tx.sudo.sudo(call).signAndSend(bob, (result) => { console.log(result.toHuman()) });
      //register asset Acala
      const call2 = api2.tx.assetRegistry.registerForeignAsset({V1: {parents:1,interior: "Here"}},{name: "UNIT", symbol: "UNIT", decimals: 12, minimalbalance: 0});
      const result2 = await api2.tx.sudo.sudo(call2).signAndSend(bob, (result) => { console.log(result.toHuman()) });

      this.$notify({ title: 'Loading', text: 'Application is loading and setting up for first time. Please wait, this process takes minute.', duration: 12000,speed: 100})
      await new Promise(resolve => setTimeout(resolve, 30000));
      
      //set asset location Basilisk
      const call3 = api.tx.assetRegistry.setLocation(3,{parents: 1, interior: "Here"});
      const result3 = await api.tx.sudo.sudo(call3).signAndSend(bob, (result) => { console.log(result.toHuman()) });
      await new Promise(resolve => setTimeout(resolve, 30000));
    }
    setTimeout( () => this.$router.push({ path: '/home'}));
  }
})
</script>
<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@200&display=swap');
.textt{
  color: black;
  font-family: 'Poppins', sans-serif;
  font-size: 30px;
  margin-top: 30px;
}
</style>