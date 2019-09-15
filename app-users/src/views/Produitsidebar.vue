<template>
	<div class="container-fluid">
  <div class="row">
    <nav class="col-md-2 d-none d-md-block bg-light sidebar">
      <div class="sidebar-sticky">
        <ul class="nav flex-column">
          <li class="nav-item">
            <a class="nav-link active" href="#">
              <span data-feather="home"></span>
              Dashboard <span class="sr-only">(current)</span>
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="#">
              <span data-feather="file"></span>
              Orders
            </a>
          </li>
         
        </ul>

        
      </div>
    </nav>

    <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
      <h2>Section title</h2>
      <div class="row">
    <div class="col-md-4 order-md-2 mb-4">
      <h4 class="d-flex justify-content-between align-items-center mb-3">
        <span class="text-muted">Your cart</span>
        <span class="badge badge-secondary badge-pill">3</span>
      </h4>
      <ul class="list-group mb-3">
        <li class="list-group-item d-flex justify-content-between lh-condensed">
          <div>
            <h6 class="my-0">Product name</h6>
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
        <li class="list-group-item d-flex justify-content-between lh-condensed">
          <div>
            <h6 class="my-0">Third item</h6>
            <small class="text-muted">Brief description</small>
          </div>
          <span class="text-muted">$5</span>
        </li>
        <li class="list-group-item d-flex justify-content-between bg-light">
          <div class="text-success">
            <h6 class="my-0">Promo code</h6>
            <small>EXAMPLECODE</small>
          </div>
          <span class="text-success">-$5</span>
        </li>
        <li class="list-group-item d-flex justify-content-between">
          <span>Total (USD)</span>
          <strong>$20</strong>
        </li>
      </ul>

      <form class="card p-2">
        <div class="input-group">
          <input type="text" class="form-control" placeholder="Promo code">
          <div class="input-group-append">
            <button type="submit" class="btn btn-secondary">Redeem</button>
          </div>
        </div>
      </form>
    </div>
    <div class="col-md-8 order-md-1">
      <h4 class="mb-3">Billing address</h4>
      <form class="needs-validation" novalidate>
        <div class="row">
          <div class="col-md-6 mb-3">
            <label for="firstName">First name</label>
            <input type="text" class="form-control" id="firstName" placeholder="" value="" required>
            <div class="invalid-feedback">
              Valid first name is required.
            </div>
          </div>
          <div class="col-md-6 mb-3">
            <label for="lastName">Last name</label>
            <input type="text" class="form-control" id="lastName" placeholder="" value="" required>
            <div class="invalid-feedback">
              Valid last name is required.
            </div>
          </div>
        </div>

        <div class="mb-3">
          <label for="username">Username</label>
          <div class="input-group">
            <div class="input-group-prepend">
              <span class="input-group-text">@</span>
            </div>
            <input type="text" class="form-control" id="username" placeholder="Username" required>
            <div class="invalid-feedback" style="width: 100%;">
              Your username is required.
            </div>
          </div>
        </div>

        <div class="mb-3">
          <label for="email">Email <span class="text-muted">(Optional)</span></label>
          <input type="email" class="form-control" id="email" placeholder="you@example.com">
          <div class="invalid-feedback">
            Please enter a valid email address for shipping updates.
          </div>
        </div>

        <div class="mb-3">
          <label for="address">Address</label>
          <input type="text" class="form-control" id="address" placeholder="1234 Main St" required>
          <div class="invalid-feedback">
            Please enter your shipping address.
          </div>
        </div>

        <div class="mb-3">
          <label for="address2">Address 2 <span class="text-muted">(Optional)</span></label>
          <input type="text" class="form-control" id="address2" placeholder="Apartment or suite">
        </div>

        <div class="row">
          <div class="col-md-5 mb-3">
            <label for="country">Country</label>
            <select class="custom-select d-block w-100" id="country" required>
              <option value="">Choose...</option>
              <option>United States</option>
            </select>
            <div class="invalid-feedback">
              Please select a valid country.
            </div>
          </div>
          <div class="col-md-4 mb-3">
            <label for="state">State</label>
            <select class="custom-select d-block w-100" id="state" required>
              <option value="">Choose...</option>
              <option>California</option>
            </select>
            <div class="invalid-feedback">
              Please provide a valid state.
            </div>
          </div>
          <div class="col-md-3 mb-3">
            <label for="zip">Zip</label>
            <input type="text" class="form-control" id="zip" placeholder="" required>
            <div class="invalid-feedback">
              Zip code required.
            </div>
          </div>
        </div>
        <hr class="mb-4">
        <div class="custom-control custom-checkbox">
          <input type="checkbox" class="custom-control-input" id="same-address">
          <label class="custom-control-label" for="same-address">Shipping address is the same as my billing address</label>
        </div>
        <div class="custom-control custom-checkbox">
          <input type="checkbox" class="custom-control-input" id="save-info">
          <label class="custom-control-label" for="save-info">Save this information for next time</label>
        </div>
        <hr class="mb-4">

        <h4 class="mb-3">Payment</h4>

        <div class="d-block my-3">
          <div class="custom-control custom-radio">
            <input id="credit" name="paymentMethod" type="radio" class="custom-control-input" checked required>
            <label class="custom-control-label" for="credit">Credit card</label>
          </div>
          <div class="custom-control custom-radio">
            <input id="debit" name="paymentMethod" type="radio" class="custom-control-input" required>
            <label class="custom-control-label" for="debit">Debit card</label>
          </div>
          <div class="custom-control custom-radio">
            <input id="paypal" name="paymentMethod" type="radio" class="custom-control-input" required>
            <label class="custom-control-label" for="paypal">PayPal</label>
          </div>
        </div>
        <div class="row">
          <div class="col-md-6 mb-3">
            <label for="cc-name">Name on card</label>
            <input type="text" class="form-control" id="cc-name" placeholder="" required>
            <small class="text-muted">Full name as displayed on card</small>
            <div class="invalid-feedback">
              Name on card is required
            </div>
          </div>
          <div class="col-md-6 mb-3">
            <label for="cc-number">Credit card number</label>
            <input type="text" class="form-control" id="cc-number" placeholder="" required>
            <div class="invalid-feedback">
              Credit card number is required
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-md-3 mb-3">
            <label for="cc-expiration">Expiration</label>
            <input type="text" class="form-control" id="cc-expiration" placeholder="" required>
            <div class="invalid-feedback">
              Expiration date required
            </div>
          </div>
          <div class="col-md-3 mb-3">
            <label for="cc-cvv">CVV</label>
            <input type="text" class="form-control" id="cc-cvv" placeholder="" required>
            <div class="invalid-feedback">
              Security code required
            </div>
          </div>
        </div>
        <hr class="mb-4">
        <button class="btn btn-primary btn-lg btn-block" type="submit">Continue to checkout</button>
      </form>
    </div>
  </div>
    </main>
  </div>
</div>
</template>

<script>
    // importing common function
    import mixin from '../libs/mixinViews';

    export default {
        mixins: [mixin],

    	data() {
    		return {
    			userName: '', // variable binded with the input field: name
    			userStatus: '', // variable binded with the input field: status
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
                    !this.userName.length ||
                    !this.userStatus.length ||
                    this.submitting ||
                    !this.blockchainIsConnected()
                );
            }
        },

        created() {
            // it checks every 500ms if the user is registered until the connection is established
            this.redirectIfUserRegistered();
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
                .then(address => this.performUserRegistration(address));
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
             * function registerUser.
             *
             * @param {string} address
             * @return {void}
             */
            performUserRegistration(address) {
                window.bc.contract().registerUser(
                    this.userName,
                    this.userStatus,
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
            redirectIfUserRegistered() {
                this.tmoConn = setInterval(() => {
                    // checking first the connection
                    if (this.blockchainIsConnected()) {
                        // stopping the interval
                        clearInterval(this.tmoConn);

                        // calling the smart contract
                        this.isRegistered().then(res => {
                            if (res) {
                                // redirecting to the profile page
                                //this.$router.push("profile");
                            }
                        });
                    }
                }, 500);
            },

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
                                this.$router.push("profile");
                            }
                        })
                        .catch(error => this.showErrorMessage(error));
                    }
                }, 1000);
            }
        }
    }
</script>

