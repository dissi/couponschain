<template>
    <div class="container-fluid">
        <button class="btn btn-primary float-right mt-2" @click="reloadList">Actualiser</button>
        <h1 class="title">Liste  des coupons</h1>
        <div class="row">
            <div class="col-md-12 mb-4">
                <div class="clearfix"></div>

                <h2 v-show="!bcConnected">Pas de connexion à la blockchain: Patientez SVP.</h2>

                <h2 v-show="(isLoading && bcConnected)">Téléchargement...</h2>

                <table class="table table-striped" v-show="!isLoading">
                    <thead class="thead-info">
                        <tr>
                            <th>Num</th>
                            <th>Nom</th>
                            <th>Categorie Utilisateur</th>
                            <th>Addresse</th>
                            <th>Date Creation</th>
                            <th>Mise à jour</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr v-for="user in users">
                            <td>{{ user[0].toNumber() }}</td>
                            <td>{{ user[1] }}</td>
                            <td>{{ toAscii(user[2]) }}</td>
                            <td>{{ user[3] }}</td>
                            <td>{{ toDate( user[4].toNumber() ) }}</td>
                            <td>{{ toDate( user[5].toNumber() ) }}</td>
                        </tr>
                    </tbody>
                </table>
            </div>    
        </div>
    </div>
</template>

<script>
    // importing common function

import UsersContract from '../assets/Users.json';
    import mixin from '../libs/mixinViews';

    /**
     * List view component: this component shows list of the registered users
     * and their statuses.
     */
    export default {
        mixins: [mixin],

        data() {
            return {
                users: [], // array that stores all the registered users
                isLoading: true, // true when the user list is loading form the blockchain
                bcConnected: false, // blockchain is connected ()
                tmoConn: null, // contain the intervalID given by setInterval
            }
        },

        methods: {
            /**
             * Get the list of the registered users once the connection to the
             * blockchain is established.
             */
            getUserList() {
                if (this.blockchainIsConnected()) {
                    // it shows the loading message
                    this.isLoading = true;

                    // stopping the interval
                    clearInterval(this.tmoConn);

                    // getting all the users from the blockchain
                    this.getAllUsers(userProfile => {
                        this.isLoading = false;
                        this.users.push(userProfile);
                    })
                }
            },

            /**
             * It reloads the user list.
             */
            reloadList() {
                this.users = [];

                this.getUserList();
            },

			/**
			 * Get all users.
			 */
			getAllUsers(callback) {
                            // getting the total number of users stored in the blockchain
                            // calling the method totalUsers from the smart contract
                            window.bc.contract('Users').totalUsers((err, total) => {
                                    var tot = 0;
                                    if (total) tot = total.toNumber();

                                    if (tot > 0) {
                                        // getting the user one by one
                                        for (var i=1; i<=tot; i++) {
                                            window.bc.contract('Users').getUserById.call(i, (error, userProfile) => {
                                                callback(userProfile);
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
                this.getUserList();
            }, 1000);
        }
    }
</script>

<style>
</style>
