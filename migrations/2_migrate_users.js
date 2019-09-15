var Users = artifacts.require("./Users.sol");
var Produits = artifacts.require("./Produits.sol");

module.exports = function(deployer) {
    deployer.deploy(Users);
    deployer.deploy(Produits);
};
