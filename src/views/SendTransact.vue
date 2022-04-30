<template>
    <div>
        <b-button class="buttonn" tag="router-link" to="/relaytopara" type="is-link">XCM transfer from relay chain to parachain</b-button>
        <b-button class="buttonn" tag="router-link" to="/paratorelay" type="is-link">XCM transfer from parachain to relay chain</b-button>
        <b-button class="buttonn" tag="router-link" to="/paratopara" type="is-link">XCM transfer from one parachain to another parachain</b-button>
        <b-button class="buttonn" tag="router-link" to="/menu" type="is-link">Back to main menu</b-button>
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
