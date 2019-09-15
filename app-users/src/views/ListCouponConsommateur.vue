<template>

        <div>
            <div class="jumbotron">
            Coupons
            </div>
            <div class="row">
                <div class="col-md-9">
                    <div class="clearfix"></div>
                    <h1 class="alert alert-info text-center">Liste des coupons</h1>
                    <h2 v-show="!bcConnected">Pas de connexion à la blockchain: Patientez SVP.</h2>

                    <h2 v-show="(isLoading && bcConnected)">Téléchargement...</h2>
                    
                    <hr />
       <div class="row my-4">

          <div v-for="user in coupons" class="col-md-3" v-if="user[8]=='Emis'">
            <!-- Card Wider -->
            <div class="card card-cascade wider">

              <!-- Card image -->
              <div class="view view-cascade overlay">
           
                  <img :src="getImgUrl(user[0])" v-bind:alt="coupons" class="card-img-top">
                <a href="#!">
                  <div class="mask rgba-white-slight"></div>
                </a>
              </div>

              <!-- Card content -->
              <div id="step-3" class="card-body card-body-cascade text-center tour st-3" title="Step three" data-index="2">

                <!-- Label -->
                <h5 class="font-weight-bold deep-orange-lighter-hover mb-3"><i class="fas fa-utensils"></i> Economisez {{ user[3] }}</h5>
                <!-- Title -->
                <h4 class="font-weight-bold card-title">{{ user[2] }}</h4>
                <!-- Text -->
                <p class="card-text">Ce coupon du {{user[1]}} s'expire le {{ toDate( user[7].toNumber() ) }}</p>
                <!-- Button -->
                 
                <router-link tag="button" class="btn btn-info" :to="{ name: 'AcquerirCoupon', params: {idCoup: user[0] }}" v-if="user[8]=='Emis'">
                    Acquerir coupon
                </router-link>

              </div>

            </div>
            <!-- Card Wider -->
          </div>
        </div>
        <hr>


                </div> 
                
                <div class="col-md-3">
                    <div class="card">
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item">Sous Menu</li>
                            <router-link tag="li" class="list-group-item" to="/listcouponconsommateur">
                                 Liste de tous les coupons
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
            getImgUrl(pet) {
                var images = require.context('../assets/images', false, /\.jpg$/)
                return images('./' + pet + ".jpg")
            },
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
            }, 1000);
        }
    }
</script>

<style>
</style>
