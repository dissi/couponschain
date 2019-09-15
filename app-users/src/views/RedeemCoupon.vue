<template>
    <div>
       <div class="jumbotron">
        Coupons
        </div>
        <div class="row">
            <div class="col-md-9">
                <h1 class="alert alert-info">Recuperer le coupon</h1>
                <div class="form-group">
                    <label for="description">Coupon Identifiant</label>
                    <input class="form-control" readonly="readonly" type="text" v-model="couponId">
                </div>
               
          
                <button  v-show="!successMessage" class="btn btn-primary" :disabled="disableSubmit" @click="performSubmit">recuperer ce coupon </button>
                <strong v-show="submitting">Traitement...</strong>

                <strong  class="text-danger"></strong>

                <div v-show="errorStr" class="alert alert-danger mt-3" role="alert">
                    {{ errorStr }}
                    <br>
                    <small>Check the browser console for more details.</small>
                </div>

                <div v-show="successMessage" class="alert alert-success mt-3" role="alert">
                    <strong>Vous avez recuperer ce coupon!</strong>
                    
                </div>
            </div>
            <div class="col-md-3">
                <div class="card">
                    <ul class="list-group list-group-flush">
                      <li class="list-group-item">Sous Menu</li>

                        <router-link tag="li" class="list-group-item" to="/listcoupon">
                           Liste de tous mes coupons generes
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

    export default {
        mixins: [mixin],

    	data() {
    		return {
    			couponId:'',
                submitting: false, // true once the submit button is pressed
                successMessage: false, // true when the user has been registered successfully
                
                idCoup:'0',
               
                tmoConn: null, // contain the intervalID given by setInterval
                tmoReg: null, // contain the intervalID given by setInterval
                errorStr: null, // it shows the error message
    		}
    	},

    	computed: {
            /**
             * It disables the submit button when the the name or userStatus are not filled
             * or the submit button is pressed or the connection with the blockchin is
             * not established.
             */
            disableSubmit() {
                return (
                   
                    this.submitting ||
                    !this.blockchainIsConnected()
                );
            }
        },
        props: ['idCoup'],
        mounted(){
                              
            this.idCoup = this.$route.params.idCoup;
            this.couponId = this.$route.params.idCoup;
        },

        

        methods: {
            
            /**
             * Perform the registration of the user when the submit button is pressed.
             *
             * @return {void}
             */
        	performSubmit() {
                this.submitting = true;
                this.errorStr = null;
                this.successMessage = false;

                window.bc.getMainAccount()
                .then(address => this.performCouponRegistration(address));
        	},

            /**
             * Show the form error.
             *
             * @param {object} err
             * @return {void}
             */
            showErrorMessage(err) {
                console.error(err);

                this.errorStr = null;

                if (err) this.errorStr = err.toString();

                if (! this.errorStr) this.errorStr = 'Error occurred!';
            },

          

            /**
             * Perform the user registration cannling the smart contract
             * function registerCoupon.
             *
             * @param {string} address
             * @return {void}
             */
            performCouponRegistration(address) {
               
                    window.bc.contract('Users').redeem(
                        this.couponId,
                        {
                            from: address,
                            gas: 800000
                        },
                        (err, txHash) => {
                            this.submitting = false;

                            if (err) {
                                this.showErrorMessage(err);
                            }
                            else {
                                this.successMessage = true;

                                // it emits a global event in order to update the top menu bar
                                Event.$emit('userregistered', txHash);

                                // the transaction was submitted and the user will be redirected to the
                                // profile page once the block will be mined
                                //this.redirectWhenBlockMined();
                            }
                        }
                    )
                
            }

            
        }
       
    }
</script>
