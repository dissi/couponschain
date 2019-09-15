<template>

    <nav class="navbar navbar-expand-lg fixed-top navbar-dark bg-primary">
          <a class="navbar-brand" href="#">COUPON- CHAIN</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarText" aria-controls="navbarText" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse" id="navbarText">
   <span class="navbar-text">
   La chaine est 
     <strong :class="connectedClass">
                    {{ bcConnected ? 'Connectée' : 'Pas connectée' }}
                </strong>
    </span>
        <ul class="navbar-nav">
            <router-link tag="li" class="nav-item"  to="/" exact>
                <a class="nav-link">Utilisateurs</a>
            </router-link>

           
            <router-link tag="li" class="nav-item" to="/register" exact v-show="userIsDistributeur">
                 <a class="nav-link">Distributeurs</a>
            </router-link>
             <router-link tag="li" class="nav-item" to="/registercampagne" exact v-show="userIsEmetteur">
                 <a class="nav-link">Campagnes</a>
            </router-link>
            <router-link tag="li" class="nav-item" to="/listcoupon" exact v-show="userIsEmetteur">
                 <a class="nav-link" >Coupons</a>
            </router-link>
            <router-link tag="li" class="nav-item" to="/listcoupon" exact v-show="userIsDistributeur">
                 <a class="nav-link" >Coupons</a>
            </router-link>
            <router-link tag="li" class="nav-item" to="/listcouponconsommateur" exact v-show="userIsConsommateur">
                 <a class="nav-link" >Coupons</a>
            </router-link>
            <router-link tag="li" class="nav-item" to="/mescouponconsommateur"  exact v-show="userIsConsommateur" >
                <a class="nav-link" > Mes Coupons</a> 
            </router-link>
            <router-link tag="li" class="nav-item" to="/listcouponconsommateur" exact v-show="ListProduits">
                 <a class="nav-link" >Coupons</a>
            </router-link>
            
            
        </ul>
         <router-link tag="div" class="navbar-nav" to="/profile" exact v-show="userIsRegistered">
                <a class="nav-item nav-link">Profile</a>
            </router-link>

            <router-link tag="div" class="navbar-nav" to="/register" exact v-show="!userIsRegistered">
                <a class="nav-link"><strong>S'enregistrer</strong></a>
            </router-link>
       </div>
    </nav>
</template>

<script>
    // importing common function
    import mixin from '../libs/mixinViews';

    export default {
        mixins: [mixin],

        data() {
            return {
                tmoConn: null, // contain the intervalID given by setInterval
                tmoReg: null, // contain the intervalID given by setInterval
                connectedClass: 'text-danger', // bootstrap class for the connection status (red when not connected, green when connected)
                userIsRegistered: false, // true when the user that is visiting the page is registered
                userIsEmetteur: false, // true when the user that is visiting the page is emetteur
                userIsDistributeur: false, // true when the user that is visiting the page is distributeur
                userIsConsommateur: false, // true when the user that is visiting the page is emetteur
            }
        },

        methods: {
            /**
             * It checks if the visiting user is regitered calling every 500ms the function isRegistered
             * from the smart contract until the connection with the smart contract is established.
             */
            checkUserIsRegistered() {
                this.tmoConn = setInterval(() => {
                    // checking first if the connection with the blockchain is established
                    if (this.blockchainIsConnected()) {
                        // stopping the setInterval
                        clearInterval(this.tmoConn);

                        // showing the connected message on the top bar and setting the class too
                        this.connectedClass = 'text-success';

                        this.isRegistered()
                        .then(res => this.userIsRegistered = res)
                        .catch(error => console.log(error));
                        this.getTypeEmet();
                        this.getTypeDist();
                        this.getTypeConsom();
                    }
                }, 500);
            },

            getTypeEmet() {
                window.bc.getMainAccount().then(account => {
                    window.bc.contract('Users').CheckIsEmetteur.call({ from: account },
                        (error, valeur) => {
                            if (valeur) {
                                this.userIsEmetteur =valeur;
                            }

                            this.setErrorMessage(error);
                        }
                    );
                });
            },



            getTypeDist() {
                window.bc.getMainAccount().then(account => {
                    window.bc.contract('Users').CheckIsDistributeur.call({ from: account },
                        (error, valeur) => {
                            if (valeur) {
                                this.userIsDistributeur =valeur;
                            }

                            this.setErrorMessage(error);
                        }
                    );
                });
            },
            getTypeConsom() {
                window.bc.getMainAccount().then(account => {
                    window.bc.contract('Users').CheckIsConsommateur.call({ from: account },
                        (error, valeur) => {
                            if (valeur) {
                                this.userIsConsommateur =valeur;
                            }

                            this.setErrorMessage(error);
                        }
                    );
                });
            },
            /**
             * Check if the user is registered calling the function of the smart contract isRegistered.
             * This function is used when the user is signing up.
             * The difference with the previous function is:
             *      - the function checkUserIsRegistered tries to check if the user is registered
             *        until the connection with the blockchain is established.
             *      - the function checkUntilUserIsRegistered tries to check if the user is registered
             *        until the user is registered.
             *
             * NOTE: in order to check if the user has been registered successfully the function has to check
             * several time because the block can take several minutes in order to be mined (depending on the
             * configuration of the blockchain you are using).
             */
            checkUntilUserIsRegistered() {
                this.tmoReg = setInterval(() => {
                    if (this.blockchainIsConnected()) {
                        this.isRegistered()
                        .then((error, res) => {
                            if (res) {
                                // stopping the setInterval
                                clearInterval(this.tmoReg);

                                this.userIsRegistered = res;
                                this.getTypeDist();
                                this.getTypeEmet();
                                this.getTypeConsom();
                                
                            }
                        })
                        .catch(error => console.log(error));
                    }
                }, 1000);
            }
        },

        created() {
            // when the event userregistered is fired (from the view Register.vue)
            // it runs the function checkUntilUserIsRegistered
            Event.$on('userregistered', this.checkUntilUserIsRegistered);

            this.checkUserIsRegistered();
        }
    }
</script>

<style>

</style>
