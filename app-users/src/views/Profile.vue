<template>
    <div>
        <div class="jumbotron">
        Utilisateurs
        </div>

        <div class="row">
            <div class="col-md-3">
                <h3>Votre profile</h3><hr>

                <h4>
                    Votre Identifiant: {{ userId }}
                </h4>

                <div class="form-group">
                    <label for="description">Nom</label>
                    {{ userName }}
                    <input class="form-control" placeholder="Enter your name" type="text" v-model="userName">
                </div>

                <div class="form-group">
                    <label for="description">Categorie</label>
                    <input class="form-control" placeholder="Update your status" type="text" v-model="userStatus">
                </div>

               
            </div>

            <div class="col-md-3">
                <h3>Info</h3><hr>

                <p>
                    <strong>Address</strong>: {{ userAddressAccount }}
                </p>
                <p>
                    <strong>Balance</strong>: {{ balance }} ETH
                </p>
                <h3>Info</h3><hr>
                 <p>
                    <strong>Emetteur</strong>: {{ vraiemet }}
                </p>
                <p>
                    <strong>Distributeur</strong>: {{ vraidisb }} 
                </p>
                <p>
                    <strong>Consommateur</strong>: {{ vraiconsom }} 
                </p>
            </div>
        </div>

        <div class="row" v-show="errorMessage">
            <div class="col-md-6">
                <div class="alert alert-danger mt-4">
                    {{ errorMessage }}
                </div>
            </div>
        </div>

    </div>
</template>

<script>
    // importing common function
    import mixin from '../libs/mixinViews';


    /**
     * Profile view component: this component shows the user profile.
     * In this page the user can update his own profile and he can
     * view other details like his wallet address and balance.
     */
    export default {
        mixins: [mixin],

        data() {
            return {
                userName: '', // variable binded with the name's input field
                userStatus: '', // varialbe binded to the status's input filed
                userId: 0, // user ID from the blockchain

                userAddressAccount: '0x0', // address of the user
                balance: 0, // balance of the user
                
                vraiemet:false, // test si cest emetteur
                vraidisb:false, // test si cest dist
                vraiconsom:false, // test si cest dist

                tmoConn: null, // contain the intervalID given by setInterval

                submitting: false, // true when the submit is pressed
                successSave: false, // it show the success message
                errorMessage: null, // it shows the error message
            }
        },

        computed: {
            /**
             * It disables the submit button when the the userName or userStatus are not filled
             * or the submit button is pressed or the connection with the blockchin is
             * not established.
             */
            disableSubmit() {
                return (
                    !this.userName.length ||
                    !this.userStatus.length ||
                    this.submitting ||
                    !this.blockchainIsConnected()
                );
            }
        },

        methods: {
            /**
             * Get the profile details of the user.
             * This methos calls the smart contract function getOwnProfile
             * and it returns the user details where:
             *      userDet[0] => uint     user ID
             *      userDet[1] => string   user's name
             *      userDet[2] => bytes32  user's status
             *
             * @return {void}
             */
            getProfile() {
                window.bc.getMainAccount().then(account => {
                    window.bc.contract('Users').getOwnProfile.call({ from: account },
                        (error, userDet) => {
                            if (userDet) {
                                this.userId = userDet[0].toNumber();
                                this.userName = userDet[1];
                                // userDet[2] is bytes32 format so it has to be trasformed to stirng
                                this.userStatus = this.toAscii(userDet[2]);
                            }

                            this.setErrorMessage(error);
                        }
                    );
                });
            },



            getTypeEmet() {
                window.bc.getMainAccount().then(account => {
                    window.bc.contract('Users').CheckIsEmetteur.call({ from: account },
                        (error, valeur) => {
                            if (valeur) {
                                this.vraiemet =valeur;
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
                                this.vraidisb =valeur;
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
                                this.vraiconsom =valeur;
                            }

                            this.setErrorMessage(error);
                        }
                    );
                });
            },
            /**
             * Set the error message showing the alert.
             *
             * @param {object} error
             * @return {void}
             */
            setErrorMessage(error) {
                this.errorMessage = null;

                if (error) {
                    console.error(error);

                    this.errorMessage = error.toString();

                    if (! this.errorMessage.length) this.errorMessage = 'Error occurred!';
                }
            },

            /**
             * Updates the user's details when the button is pressed.
             *
             * @return {void}
             */
            performSubmit() {
                this.submitting = true;
                this.errorMessage = null;
                this.successSave = false;

                // calling the method updateUser from the smart contract
                window.bc.getMainAccount('Users')
                .then(account => {
                    window.bc.contract().updateUser(
                        this.userName,
                        this.userStatus,
                        {
                            from: account,
                            gas: 800000
                        },
                        (err, txHash) => this.handleSubmitResult(err, txHash)
                    )
                })
                .catch(error => this.setErrorMessage(error));
            },

            /**
             * Handle the result of the response of updateUser.
             *
             * @param {object} err
             * @param {string} txHash
             * @return {void}
             */
            handleSubmitResult(error, txHash) {
                this.submitting = false;

                if (error) {
                    this.setErrorMessage(error);
                } else if (txHash) {
                    this.successSave = true;
                }
            },

            /**
             * It loads the general info (address and balance of the user).
             *
             * @return {void}
             */
            getInfoBc() {
                window.bc.loadInfo().then(info => {
                    this.userAddressAccount = info.mainAccount;

                    this.balance = window.bc.weiToEther( info.balance );
                });
            },

            /**
             * It loads the user information once connected to the blockchian.
             *
             * @return {void}
             */
            checkConnectionAndLoad() {
                if (this.blockchainIsConnected()) {
                    // stopping the interval
                    clearInterval(this.tmoConn);

                    this.loadEverything();
                }
            },

            /**
             * Load the user's info: user name, status and general info.
             *
             * @return {void}
             */
            loadEverything() {
                // checking if the user is registered
                this.isRegistered()
                .then(res => {
                    // if the user is registered it will load the profile page
                    if (res) {
                        this.getProfile();
                        this.getInfoBc();
                        this.getTypeDist();
                        this.getTypeEmet();
                        this.getTypeConsom();
                    }

                    // if the user not registered the user will be redirected to the Register page
                    else this.$router.push("register");
                })
                .catch(error => {
                    console.error(error);
                    this.$router.push("register");
                });
            }
        },

        created() {
            // it will call the function checkConnectionAndLoad every 500ms
            // until the connection to the blockchain is enstablished
            this.tmoConn = setInterval(() => {
                this.checkConnectionAndLoad();
            }, 500);
        }
    }
</script>
