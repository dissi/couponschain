<template>
    <div class="container-fluid espace-top">
 
        <h2>Section title</h2>
        <div class="row">
            <div class="col-md-4 order-md-2 mb-4">
                <h4 class="d-flex justify-content-between align-items-center mb-3">
                  <span class="text-muted">Sous Menu</span>
                </h4>
                <ul class="list-group mb-3">
                    <li class="list-group-item d-flex justify-content-between lh-condensed">
                      <div>
                        <h6 class="my-0">Listes</h6>
                        <small class="text-muted">Brief description</small>
                      </div>
                      <span class="text-muted">$12</span>
                    </li>
                    <li class="list-group-item d-flex justify-content-between lh-condensed">
                      <div>
                        <h6 class="my-0">Second product</h6>
                        <small class="text-muted">Brief description</small>
                      </div>
                      <span class="text-muted">$8</span>
                    </li>

                </ul>
            </div>
            <div class="col-md-8 order-md-1">
                <h2 class="mb-3">Ajouter un Produit</h2>
                <hr class="mb-4">
                <strong v-show="submitting">Traitement..{{userAddressAccount}}..{{totalarticle}}. </strong>

                <strong  class="text-danger"></strong>

                <div v-show="errorStr" class="alert alert-danger mt-3" role="alert">
                    {{ errorStr }}
                    <br>
                    <small>Check the browser console for more details.</small>
                </div>

                <div v-show="successMessage" class="alert alert-success mt-3" role="alert">
                    <strong>Produit enregistré!</strong>

                </div>
           

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="nomproduit">Nom du produit</label>
                        <input type="text" class="form-control" id="titre" placeholder="" value="" required  v-model="newTitre">
                        <div class="invalid-feedback">
                          Valid first name is required.
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="lastName">Categorie</label>
                        <input type="text" class="form-control" id="categorie" placeholder="" value="" required v-model="newCategorie">
                        <div class="invalid-feedback">
                          Valid last name is required.
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                  <label for="username">Description</label>

                    <input type="text" class="form-control" id="username" placeholder="Username" required v-model="newDescription">
                    <div class="invalid-feedback" style="width: 100%;">
                      Your username is required.
                    </div>

                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="country">Devise</label>
                        <select class="custom-select d-block w-100" id="country" required v-model="newDevise">
                          <option value="">CHoix...</option>
                          <option value="CFA">CFA</option>
                          <option value="DOLLAR">DOLLAR</option>
                          <option value="EURO">EURO</option>
                          <option value="VND">VND</option>
                        </select>
                        <div class="invalid-feedback">
                          Please select a valid country.
                        </div>
                    </div>

                    <div class="col-md-6 mb-3">
                      <label for="zip">Prix</label>
                      <input type="text" class="form-control" id="zip" placeholder="Prix" required v-model="newPrix">
                      <div class="invalid-feedback">
                        Zip code required.
                      </div>
                    </div>
                </div>
                <hr class="mb-4">
                <button class="btn btn-primary btn-lg btn-block" :disabled="disableSubmit" @click="performSubmit">Enregistrer</button>
                
            </div>
        </div>
   
    </div>

</template>

<script>
    // importing common function

import ProduitsContract from '../assets/Produits.json';  
import UsersContract from '../assets/Users.json';
    import mixin from '../libs/mixinViews';

    export default {
        mixins: [mixin],

    	data() {
    		return {
    			newTitre: '', // variable binded with the input field: titre
    			newCategorie: '', // variable binded with the input field: categorie
                        newDescription: '', // variable binded with the input field: categorie
                        newDevise: '', // variable binded with the input field: devise
                        newPrix: 0, // variable binded with the input field: prix
                        
                        userAddressAccount:'0x0',
                        totalarticle:0,
                        submitting: false, // true once the submit button is pressed
                        successMessage: false, // true when the user has been registered successfully

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
                    !this.newTitre.length ||
                    !this.newCategorie.length ||
                    !this.newDescription.length ||
                    !this.newDevise.length ||
                    !this.newPrix.length ||
                    this.submitting ||
                    !this.blockchainIsConnected()
                );
            }
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
                .then(address => this.performProduitRegistration(address));
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
             * function registerProduit.
             *
             * @param {string} address
             * @return {void}
             */
            performProduitRegistration(address) {
                window.bc.contract(ProduitsContract).registerProduit(
                    this.newTitre,
                    this.newCategorie,
                    this.newDescription,
                    this.newDevise,
                    this.newPrix,
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
                            this.redirectWhenBlockMined();
                        }
                    }
                )
            },

            /**
             * Check if the user visitng this page is registered: if the user is already
             * registered he will be redirected to the Profile page.
             *
             * @return {void}
             */
      

            /**
             * Once the user submitted his registration this funciton checks every 1000 ms
			 * if the registration is successfully. Once the user is registered he will be
			 * redirected to the profile page.
             *
             * NOTE: in order to check if the user has been registered successfully the
             * function has to check several time because the block can take several
             * minutes to be mined (depending on the the blockchain you are using).
             *
             * @return {void}
             */
            redirectWhenBlockMined() {
                this.tmoReg = setInterval(() => {
                    if (this.blockchainIsConnected()) {
                        this.isRegistered()
                        .then(res => {
                            if (res) {
                                // stopping the setInterval
                                clearInterval(this.tmoReg);

								// redirecting the user to the profile page
                                //this.$router.push("");
                            }
                        })
                        .catch(error => this.showErrorMessage(error));
                    }
                }, 1000);
            }
        }
    }
</script>

