

<template>
  <div id="app">
    <b-navbar style="margin-bottom: 5%;">
        <template #start>
            <img class="mainLogo rotate" src="./assets/polkachange.svg" />
              <h1 style="margin-right: 2%;" class="name first" >Polkachange</h1>

            <b-navbar-item class="top" tag="router-link" to="/home" type="is-link">
                Home
            </b-navbar-item>
            <b-navbar-dropdown class="top" label="Channels" >
                <b-navbar-item tag="router-link" to="/openchannel" type="is-link">
                    Open channels
                </b-navbar-item>
                <b-navbar-item tag="router-link" to="/closechannel" type="is-link">
                    Close channels
                </b-navbar-item>
            </b-navbar-dropdown>
            <b-navbar-dropdown class="top" label="Teleport">
                <b-navbar-item tag="router-link" to="/relaytopara" type="is-link">
                    From relay chain
                </b-navbar-item>
                <b-navbar-item tag="router-link" to="/paratorelay" type="is-link">
                    To relay chain
                </b-navbar-item>
            </b-navbar-dropdown>
            <b-navbar-item style="margin-right: 13%;" class="top"  tag="router-link" to="/paratopara" type="is-link">
                Transfer
            </b-navbar-item>  
            <b-navbar-dropdown hoverable arrowless boxed class="top" style= "border-style: solid; color: #7a56d5; border-radius: 5px;" label="Log in as" >
                <b-navbar-item @click.native="loginn('Alice')">
                    Alice
                </b-navbar-item>
                <b-navbar-item @click.native="loginn('Bob')">
                    Bob
                </b-navbar-item>
                <b-navbar-item @click.native="loginn('Charlie')">
                    Charlie
                </b-navbar-item>
                <b-navbar-item @click.native="loginn('Dave')">
                    Dave
                </b-navbar-item>
                <b-navbar-item @click.native="loginn('Eve')">
                    Eve
                </b-navbar-item>
                <b-navbar-item @click.native="loginn('Ferdie')">
                    Ferdie
                </b-navbar-item>
            </b-navbar-dropdown>
        </template>
    </b-navbar>
    <router-view/>
    <notifications/>
    </div>
</template>

<script lang="ts">
  import { defineComponent } from '@vue/composition-api'
  import '@polkadot/api-augment';
  import useStore from "vuex";
import store from './store';
  export default defineComponent({
  name: "LoginData",
  data() {
    return {
        login: "" as string,
      };
    },

    methods:{
    async loginn(value: any){
      this.login=value
      store.commit('saveAccount', this.login)
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

