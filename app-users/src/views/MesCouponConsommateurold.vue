<template>

        <div>
            <div class="jumbotron">
            Coupons
            </div>
            <div class="row">
                <div class="col-md-9">
                    <div class="clearfix"></div>
                    <h1 class="alert alert-info">Mes coupons</h1>
                    <h2 v-show="!bcConnected">Pas de connexion à la blockchain: Patientez SVP.</h2>

                    <h2 v-show="(isLoading && bcConnected)">Téléchargement...</h2>

                    <table class="table table-striped" v-show="!isLoading">
                        <thead class="thead-info">
                            <tr>
                                <th>Num</th>
                                <th>Emetteur</th>
                                <th>Titre</th>
                                <th>Valeur</th>
                                <th>Etat</th>
                                <th>Date Debut</th>
                                <th>Date Fin</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="user in coupons" v-if="userAddressAccount==user[5]">
                                <td>{{ user[0].toNumber() }}</td>
                                <td>{{ user[4] }}</td>
                                <td>{{ user[2] }}</td>
                                <td>{{ user[3] }}</td>
                                <td>{{ user[8] }}</td>
                                <td>{{ toDate( user[6].toNumber() ) }}</td>
                                <td>{{ toDate( user[7].toNumber() ) }}</td>
                                <td>
                                    
                                    <router-link tag="button" class="btn btn-info" :to="{ name: 'TransfererCoupon', params: {idCoup: user[0] }}" v-if="user[8]=='Acquis'">
                                        Transferer coupon
                                    </router-link>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div> 
                
                <div class="col-md-3">
                    <div class="card">
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item">Sous Menu</li>
                            <router-link tag="li" class="list-group-item" to="/listcouponconsommateur">
                                 Liste de tous les coupons
                             </router-link>
                            <router-link tag="li" class="list-group-item" to="/mescouponconsommateur" >
                                  Mes coupons
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
     * List view component: this component shows list of the registered coupons
     * and their statuses.
     */
    export default {
        mixins: [mixin],

        data() {
            return {
                coupons: [], // array that stores all the registered coupons
                isLoading: true, // true when the user list is loading form the blockchain
                bcConnected: false, // blockchain is connected ()
                tmoConn: null, // contain the intervalID given by setInterval
                userAddressAccount: '0x0', // address of the user
                
            }
        },

        methods: {
            /**
             * Get the list of the registered coupons once the connection to the
             * blockchain is established.
             */
            getCouponList() {
                if (this.blockchainIsConnected()) {
                    // it shows the loading message
                    this.isLoading = true;

                    // stopping the interval
                    clearInterval(this.tmoConn);

                    // getting all the coupons from the blockchain
                    this.getAllCoupons(couponDetail => {
                        this.isLoading = false;
                        this.coupons.push(couponDetail);
                    })
                }
            },
            getInfoBc() {
                window.bc.loadInfo().then(info => {
                    this.userAddressAccount = info.mainAccount;
                });
            },

            /**
             * It reloads the user list.
             */
            reloadList() {
                this.coupons = [];

                this.getCouponList();
            },

			/**
			 * Get all coupons.
			 */
			getAllCoupons(callback) {
                            // getting the total number of coupons stored in the blockchain
                            // calling the method totalUsers from the smart contract
                            window.bc.contract('Users').totalCoupons((err, total) => {
                                    var tot = 0;
                                    if (total) tot = total.toNumber();

                                    if (tot > 0) {
                                        // getting the user one by one
                                        for (var i=0; i<tot; i++) {
                                            window.bc.contract('Users').getCouponById.call(i, (error, couponDetail) => {
                                                callback(couponDetail);
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
                this.getCouponList();
                this.getInfoBc();
            }, 1000);
        }
    }
</script>

<style>
</style>
