<template>
  <div class="home">
    <b-button class="buttonn" @click="clickMe" type="is-danger" outlined>Login as Alice</b-button>
  
  </div>
</template>
<script lang="ts">
// Import
  import { Keyring } from '@polkadot/api'
  import { ApiPromise, WsProvider } from '@polkadot/api';
export default {
        methods: {
            async clickMe() {
//import keyring from "@polkadot/ui-keyring"
const keyring = new Keyring({ type: 'sr25519' });
    const wsProvider = new WsProvider('ws://127.0.0.1:9944');
    const api = await ApiPromise.create({ provider: wsProvider });
    const bob = keyring.addFromUri('//Alice', { name: 'Alice default' });
    console.log(`${bob.meta.name}: has address ${bob.address}`);

//TAKTO SI NAPISEM KTORY CHANNEL CHCEM OTVORIT
const call = api.tx.parasSudoWrapper.sudoEstablishHrmpChannel(2090,2000,8,1000);
const hrmp1 = await api.tx.sudo.sudo(call).signAndSend(bob, (result) => { console.log(result.toHuman()) });
//TAKTO SI VYBERIEM PARACHAINY KTORE BEZIA
//const parachain = await api.query.paras.parachains()
//Wconsole.log(parachain.toString())
//const hrmp = await api.query.hrmp.hrmpChannels([])
//console.log(hrmp)
            }
        }
    }

</script>
<style scoped>
.buttonn{
  margin-top: 20px;
  width: 800px;
}
</style>
