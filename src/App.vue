<template>
  <div id="app">
    <b-navbar style="margin-bottom: 5%;">
      <template #start>
        <img style="width: 300x; height: 90px; margin-right: 5%; " src="./assets/paraspellLogo.png" />
        <b-navbar-item style="margin-right: 5%;" class="top" tag="router-link" to="/home" type="is-link">Home</b-navbar-item>

        <b-navbar-dropdown style="margin-right: 5%;" class="top" label="Channels" >
          <b-navbar-item tag="router-link" to="/openchannel" type="is-link">Open channels</b-navbar-item>
          <b-navbar-item tag="router-link" to="/closechannel" type="is-link">Close channels</b-navbar-item>
        </b-navbar-dropdown>
          
        <b-navbar-dropdown style="margin-right: 5%;" class="top" label="Teleport">
          <b-navbar-item tag="router-link" to="/relaytopara" type="is-link">From relay chain</b-navbar-item>
          <b-navbar-item tag="router-link" to="/paratorelay" type="is-link">To relay chain</b-navbar-item>
          <b-navbar-item  tag="router-link" to="/paratopara" type="is-link">Para to Para</b-navbar-item>  
        </b-navbar-dropdown>
        
          <b-navbar-item style="margin-right: 13%;" class="top"  tag="router-link" to="/xyk" type="is-link">XYK</b-navbar-item>  

        <b-navbar-dropdown hoverable arrowless boxed class="top" style= "border-style: solid; color: #7a56d5; border-radius: 5px;" label="Log in with" >Pick option you wish to log in with.
          <b-navbar-item @click="isCardModalActive = true"><b-icon style="margin-right:5px;" size="is-small" pack="fas" icon="wallet" custom-class="fa-bounce"></b-icon>My wallet</b-navbar-item>
          <b-navbar-item @click.native="loginn('Alice')"><b-icon style="margin-right:5px" size="is-small" pack="fas" icon="clipboard-user"></b-icon>Alice</b-navbar-item>
          <b-navbar-item @click.native="loginn('Bob')"><b-icon style="margin-right:5px" size="is-small" pack="fas" icon="clipboard-user"></b-icon>Bob</b-navbar-item>
          <b-navbar-item @click.native="loginn('Charlie')"><b-icon style="margin-right:5px" size="is-small" pack="fas" icon="clipboard-user"></b-icon>Charlie</b-navbar-item>
          <b-navbar-item @click.native="loginn('Dave')"><b-icon style="margin-right:5px" size="is-small" pack="fas" icon="clipboard-user"></b-icon>Dave</b-navbar-item>
          <b-navbar-item @click.native="loginn('Eve')"><b-icon style="margin-right:5px" size="is-small" pack="fas" icon="clipboard-user"></b-icon>Eve</b-navbar-item>
          <b-navbar-item @click.native="loginn('Ferdie')"> <b-icon style="margin-right:5px" size="is-small" pack="fas" icon="clipboard-user"></b-icon>Ferdie</b-navbar-item>
        </b-navbar-dropdown>
      </template>
    </b-navbar>
    <b-modal v-model="isCardModalActive" :width="640" scroll="keep">
      <b-message 
        title="Info" 
        type="is-info" 
        aria-close-label="Close message">Select account you wish to login with and then close this popup by clicking anywhere around these boxes.
      </b-message>
      <b-select placeholder="Select account" expanded style="text-align: center;" @input.native="accountLogin($event)" required>
        <option v-for="(dropdown, index) in dropdown" :key="index">{{dropdown}}</option>
      </b-select>
    </b-modal>
    <router-view/>
    <notifications/>
  </div>
</template>

<script>
  import { web3Accounts, web3Enable } from "@polkadot/extension-dapp"
  import { defineComponent } from '@vue/composition-api'
  import '@polkadot/api-augment';
  import store from './store';

  export default defineComponent({
    data() {
      return {
        login: "",   //Currently logged account
        accounts: [],  //List of names - To be also used on Log in button
        addresses: [], //List of addresses
        injected: [],  //Collected injected wallets
        dropdown: [],  //Dropdown of names & addresses
        isCardModalActive: false   //Used to determine whether wallet login popup is or is not active
      };
    },
    mounted: async function () {
      //Connect injected wallets that are available
      const extensions = await web3Enable("PolkadotJS")
      if(extensions.length == 0) {
        this.$notify({ title: 'Error', text: 'You do not have PolkadotJS extension make sure to install one if you want to use your wallet.', type: 'error', duration: 8000,speed: 100})
        return
      }

      //Collect injected wallets
      this.injected = await web3Accounts()


      //Used to extract address and name from injected wallet login
      for (let i=0 ;i<this.injected.length; i++){
        this.accounts.push(JSON.stringify(this.injected[i]["meta"]["name"]))
        this.addresses.push(JSON.stringify(this.injected[i]["address"]))
        this.dropdown.push(this.accounts[i] + this.addresses[i])
      }
    },
    methods:{

      //Used to save logged account for XCM screens
      async loginn(value){
        this.login=value
        store.commit('saveAccount', this.login)
      },  

      async accountLogin(value){
        var accSplit = value.target.value.split('"')
        this.loginn(accSplit[3])

      },
    }
  })
</script>

<style lang="scss">
  @import url("https://fonts.googleapis.com/css2?family=Pacifico&display=swap");
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
  .mainLogo {
    width: 4%;
  }
  .rotate {
    animation: rotation 50s infinite linear;
  }
  @keyframes rotation {
    from {
      transform: rotate(0deg);
    }
    to {
      transform: rotate(359deg);
    }
  }
  .name {
    color: #e6007a;
    font-family: "Pacifico", cursive;
    font-size: 40px;
  }
  .undername {
    color: black;
    font-family: "Anybody", cursive;
    font-size: 14px;

  }
  .undertext {
    color: black;
    font-family: "Anybody", cursive;
    font-size: 20px;
    margin-bottom: 1px;
    margin-top: 25px;
  }
  .together {
    display:block
  }
  .flex__container {
    display: flex;
    flex-direction: column;
  }
  .top {
    margin-top: 8px;
  }
</style>

