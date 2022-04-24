<template>
  <div id="app">
    <h1 class="name">Polkachange</h1>
    <p class="undername">Trade tokens on Polkadot paraverse.</p>
    <img class="mainLogo rotate" src="./assets/polkachange.svg" />
    <router-view/>
    <notifications/>
  </div>
</template>

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

  margin-top: 60px;
}

.mainLogo {
  display: block;
  margin-left: auto;
  margin-right: auto;
  width: 15%;
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
  font-size: 70px;
  margin-bottom: 1px;
  margin-top: 1px;
}
.undername {
  color: black;
  font-family: "Anybody", cursive;
  font-size: 20px;
  margin-bottom: 1px;
  margin-top: 10px;
}
.undertext {
  color: black;
  font-family: "Anybody", cursive;
  font-size: 20px;
  margin-bottom: 1px;
  margin-top: 25px;
}

</style>

