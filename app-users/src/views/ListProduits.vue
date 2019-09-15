<template>
    <div class="container-fluid">
        <button class="btn btn-primary float-right mt-2" @click="reloadList">Actualiser</button>
        <h1 class="title">Liste des Produits</h1>
        <div class="row">
            <div class="col-md-12 mb-4">
                <div class="clearfix"></div>

                <h2 v-show="!bcConnected">Pas de connexion à la blockchain: Patientez SVP.</h2>

                <h2 v-show="(isLoading && bcConnected)">Téléchargement...{{ ttproduit }}</h2>

                <table class="table table-striped" v-show="!isLoading">
                    <thead class="thead-info">
                        <tr>
                            <th>Num</th>
                            <th>Titre</th>
                            <th>Categorie</th>
                            <th>Description</th>
                            <th>Prix</th>
                            <th>Devise</th>
                            <th>Createur</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="produit in produits">
                            <td>{{ produit[0].toNumber() }}</td>
                            <td>{{ produit[1] }}</td>
                            <td>{{ produit[2] }}</td>
                            <td>{{ produit[3].toNumber() }}</td>
                            <td>{{ produit[4] }}</td>
                            <td>{{ produit[5] }}</td>
                        </tr>
                    </tbody>
                </table>
            </div>    
        </div>
    </div>
</template>

<script>
    // importing common function

    import ProduitsContract from '../assets/Produits.json'; 
    import UsersContract from '../assets/Users.json'; 
    import mixin from '../libs/mixinViews';

    /**
     * List view component: this component shows list of the registered produits
     * and their statuses.
     */
    export default {
        mixins: [mixin],

        data() {
            return {
                ttproduit:0,
                produits: [], // array that stores all the registered produits
                isLoading: true, // true when the user list is loading form the blockchain
                bcConnected: false, // blockchain is connected ()
                tmoConn: null, // contain the intervalID given by setInterval
            }
        },

        methods: {
            /**
             * Get the list of the registered produits once the connection to the
             * blockchain is established.
             */
            getProduitList() {
                if (this.blockchainIsConnected()) {
                    // it shows the loading message
                    this.isLoading = true;

                    // stopping the interval
                    clearInterval(this.tmoConn);

                    // getting all the produits from the blockchain
                    this.getAllProduits(produitDetail => {
                        this.isLoading = false;
                        this.produits.push(produitDetail);
                    })
                }
            },

            /**
             * It reloads the user list.
             */
            reloadList() {
                this.produits = [];

                this.getProduitList();
            },

            /**
             * Get all produits.
             */
            getAllProduits(callback) {
                // getting the total number of produits stored in the blockchain
                // calling the method totalProduits from the smart contract

                window.bc.contract(ProduitsContract).totalProduits((err, total) => {
                    var tot = 0;

                    if (total) tot=total.toNumber();
                    this.ttproduit=tot;
                    if (tot > 0) {
                        // getting the user one by one
                        for (var i=1; i<=tot; i++) {
                            window.bc.contract(ProduitsContract).getProduitById.call(i, (error, produitDetail) => {
                                    callback(produitDetail);
                            });
                        } // end for
                    } // end if
                }); // end totalProduits call

            }

        }, // end methods
        
        created() {
            // it tries to get the user list from the blockchian once
            // the connection is established
            this.tmoConn = setInterval(() => {
                this.getProduitList();
            }, 1000);
        }
    }
</script>

<style>
</style>
