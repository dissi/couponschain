<template>
    <div>
        <top-menu></top-menu>

        <h1 class="title" v-show="!bcConnected && !bcConnectionError">
            Connexion...
        </h1>

        <div class="p-4" v-show="bcConnected && !bcConnectionError">
            <router-view></router-view>
        </div>

        <div v-show="bcConnectionError" class="m-4 alert alert-danger">
            <h2 class="pb-4">Erreur de connexion à la blockchain!</h2>

            <p v-if="errorConnectionMessage">
                <b>{{ errorConnectionMessage }}</b>
            </p>

            <p v-show="bcSmartContractAddressError">
                <b>Il semble que l'adresse du smart contract is erronné!</b>
            </p>

            <hr>

            <p>Autre sources des erreurs:</p>
            <ul>
                <li>La blockchain est entrain de tourner.</li>
                <li>The port in your settings (file: <b>libs/mixinViews.js</b>) match with the blockchain configuration.</li>
                <li>The compiled smart contract <b>app-users/src/assets/Users.json</b> is equal to <b>build/Users.json</b>.</li>
            </ul>
        </div>
    </div>
</template>

<script>
// importing common function
import mixin from './libs/mixinViews';
import TopMenu from './components/TopMenu';

export default {
    components: { TopMenu },
    mixins: [mixin],

    name: 'App'
};
</script>

<style>
    h1.title {
        margin-top: 50px;
        padding-bottom: 10px;
        border-bottom: 1px solid #CCC;
    }
    .gallery {
-webkit-column-count: 4;
-moz-column-count: 4;
column-count: 4;
-webkit-column-width: 33%;
-moz-column-width: 33%;
column-width: 33%; }
.gallery .pics {
-webkit-transition: all 350ms ease;
transition: all 350ms ease; }
.gallery .animation {
-webkit-transform: scale(1);
-ms-transform: scale(1);
transform: scale(1); }

</style>