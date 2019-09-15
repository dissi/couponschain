pragma solidity ^0.5.0;
contract Produits {
   
     struct unProduit {
        uint uuid;
        string categorie;
        string titre;
        string description;
        uint256 prix;
        string devise;
        address user;
    }
    unProduit[] public listeProduits;
    
    //event apres enregistrement d'un produit
    event newProduitAdd(uint id);
    
    //event apres modification d'un produit
    event produitUpdated(uint id);
    
     //event apres suppression d'un produit
    event supprimerProduit(uint id);
    
    constructor() public
    {
        
        // receive 0, that's why in the first position (with index 0) must be initialized
        addUnProduit("", "","",0,"",address(0x0));

        // Some dummy data
        addUnProduit("tcatoff", "tirtrr", "descriopptttoo",1,"USD",address(0x222222222222));
        addUnProduit("zertysdf", "sdfghfffffffffffff", "dsfdfsdsfds",112,"USD",address(0x222222222222));
        addUnProduit("aaaaaaaaaaaaaaa", "aaaababababababa", "dsfdfsdsfds",112,"USD",address(0x222222222222));
        addUnProduit("bbbbbbbbbb", "cbcbcbcbcbcbcbcb", "dsfdfsdsfds",112,"FCFA",address(0x222222222222));
        addUnProduit("cccccccccc", "cdcdcdcdcdcdcdcdcdcd", "dsfdfsdsfds",112,"Dollars",address(0x222222222222));
        
    }
    
    function registerProduit(string memory  _newCategorie,string memory _newTitre, string memory _newDescription,uint256 _newPrix,string memory _newDevise) public
    returns(uint)
    {
    	return addUnProduit(_newCategorie, _newTitre, _newDescription,_newPrix,_newDevise,msg.sender);
    }

    function getProduitById(uint _id) public view returns (
        uint,
        string memory,
        string memory,
        string memory,
        uint,
        string memory,
        address
    ){

        unProduit memory p = listeProduits[_id];
        return (p.uuid, p.titre,p.categorie, p.description, p.prix, p.devise,p.user);
    }

    //This is simply more for convenience than not
    function getItemPrice(uint id) public view returns (uint256) {
        return listeProduits[id].prix;
    }

    function addUnProduit (
        string memory  _newCategorie,
        string memory _newTitre,
        string memory _newDescription,
        uint256 _newPrix,
        string memory _newDevise,
        address _wAddresse
    )  private  returns (uint) {

        uint newid=listeProduits.length++;
        //Add to listeProduits
        listeProduits[newid] = unProduit({
            uuid:newid,
            categorie:_newCategorie, 
            titre:_newTitre, 
            description:_newDescription,
            prix:_newPrix, 
            devise:_newDevise,
            user:_wAddresse
        });
        emit newProduitAdd(newid);
       
        return newid;
    }


    function updateUnProduit (
        uint id,
        uint _uuid,
        string memory  _categorie,
        string memory _titre,
        string memory _description,
        uint256 _prix,
        string memory _devise
    ) public returns (bool) {

        listeProduits[id] = unProduit({
            uuid:_uuid,
            categorie:_categorie, 
            titre:_titre, 
            description:_description,
            prix:_prix, 
            devise:_devise,
            user:msg.sender});
            emit produitUpdated(id);
        return true;
    }


    function deleteUnproduit(uint id) public returns (bool) {
        //require((id>0) || (id<=listeProduits.length));
        //Delete produit identified by ID
        delete listeProduits[id];
        emit supprimerProduit(id);
        return true;
    }

    /**
     * Return the number of total registered users.
     */
    function totalProduits() public view returns (uint)
    {
        // NOTE: the total registered user is length-1 because the user with
        // index 0 is empty check the contructor: addUser(address(0x0), "", "");
        return listeProduits.length - 1;
    }
    

}
