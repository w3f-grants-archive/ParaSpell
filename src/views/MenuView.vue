<template>
    <div>
        <b-button class="buttonn" tag="router-link" to="/openchannel" type="is-link">Open channels</b-button>
        <b-button class="buttonn" tag="router-link" to="/send" type="is-link">Send XCM transaction</b-button>
        <b-button class="buttonn" tag="router-link" to="/closechannel" type="is-link">Close channels</b-button>
        <b-button class="buttonn" tag="router-link" to="/" type="is-link">Sign out</b-button>
    </div>
</template>
<style scoped>

.buttonn {
  margin-top: 20px;
  display: block;
  margin-left: auto;
  margin-right: auto;
  width: 800px;
}
</style>
