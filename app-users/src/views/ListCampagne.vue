<template>
    
    <div>
        <div class="jumbotron">
        Campagnes
        </div>
        <div class="row">
            <div class="col-md-9">
                <div class="clearfix"></div>
                
                <h2 class="alert alert-info">Liste des campagnes </h2>
                <h3 v-show="!bcConnected">Pas de connexion à la blockchain: Patientez SVP.</h3>

                <h3 v-show="(isLoading && bcConnected)">Téléchargement...</h3>
                <table class="table table-striped" v-show="!isLoading">
                    <thead class="thead-info">
                        <tr>
                            <th>Num</th>
                            <th>Titre de la campagne</th>
                            <th>Emetteur</th>
                            <th>Nombre de Coupons</th>
                            <th>Date Debut</th>
                            <th>Date Fin</th>
                            <th>Etat</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="campagne in campagnes">
                            <td>{{ campagne[0].toNumber() }}</td>
                            <td>{{ campagne[1] }}</td>
                            <td>{{ campagne[2] }}</td>
                            <td>{{ campagne[3].toNumber() }}</td>
                            <td>{{ toDate( campagne[4].toNumber() ) }}</td>
                            <td>{{ toDate( campagne[5].toNumber() ) }}</td>
                            <td>{{ campagne[6] }}</td>
                            <td> 
                                <router-link :to="{ name: 'GenererCoupon', params: {idCamp: campagne[0] }, query: {nombreCoupon: campagne[3] }}" tag="button" class="btn btn-warning" v-if="campagne[6]=='Emis'">Coupons</router-link>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="col-md-3">
                <div class="card">
                    <ul class="list-group list-group-flush">
                       <li class="list-group-item">Sous Menu</li>
                       <router-link tag="li" class="list-group-item" to="/registercampagne">
                            Ajouter une Campagne
                        </router-link>
                       <router-link tag="li" class="list-group-item" to="/listcampagne" >
                            Liste de tous les Campagnes
                        </router-link>
                       <router-link tag="li" class="list-group-item" to="/listcampagnenontraite" >
                            Campagnes non traitée
                        </router-link>
                       <router-link tag="li" class="list-group-item" to="/listcampagnetraite" >
                            Campagnes traitée
                        </router-link>
                    </ul>
                </div>
            </div>
        </div>
    </div>


</template>

<script>
    // importing common function

    import UsersContract from '../assets/Users.json';
    import mixin from '../libs/mixinViews';

    /**
     * List view component: this component shows list of the registered campagnes
     * and their statuses.
     */
    export default {
        mixins: [mixin],

        data() {
            return {
                campagnes: [], // array that stores all the registered campagnes
                isLoading: true, // true when the user list is loading form the blockchain
                bcConnected: false, // blockchain is connected ()
                tmoConn: null, // contain the intervalID given by setInterval
            }
        },

        methods: {
            /**
             * Get the list of the registered campagnes once the connection to the
             * blockchain is established.
             */
            getCampagneList() {
                if (this.blockchainIsConnected()) {
                    // it shows the loading message
                    this.isLoading = true;

                    // stopping the interval
                    clearInterval(this.tmoConn);

                    // getting all the campagnes from the blockchain
                    this.getAllCampagnes(campagneDetail => {
                        this.isLoading = false;
                        this.campagnes.push(campagneDetail);
                    })
                }
            },

            /**
             * It reloads the user list.
             */
            reloadList() {
                this.campagnes = [];

                this.getCampagneList();
            },

			/**
			 * Get all campagnes.
			 */
			getAllCampagnes(callback) {
                            // getting the total number of campagnes stored in the blockchain
                            // calling the method totalUsers from the smart contract
                            window.bc.contract('Users').totalCampagnes((err, total) => {
                                    var tot = 0;
                                    if (total) tot = total.toNumber();

                                    if (tot > 0) {
                                        // getting the user one by one
                                        for (var i=0; i<tot; i++) {
                                            window.bc.contract('Users').getEmetteurCampagneById.call(i, (error, campagneDetail) => {
                                                callback(campagneDetail);
                                            });
                                        } // end for
                                    } // end if
                            }); // end totalUsers call
			}

        }, // end methods

        created() {
            // it tries to get the user list from the blockchian once
            // the connection is established
            this.tmoConn = setInterval(() => {
                this.getCampagneList();
            }, 1000);
        }
    }
</script>

<style>

</style>
