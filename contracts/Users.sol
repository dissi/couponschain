pragma solidity ^0.5.0;
contract Users {
    
    
    struct User {
        string name;
        bytes32 status;
        address walletAddress;
        uint createdAt;
        uint updatedAt;
    }
    
    struct Campagne {
        string name;
        address campagneEmetteur;
        uint nombre;
        uint datedebutAt;
        uint datefinAt;
        string etatCampagne;
    }
    struct Coupon {
        uint idCampagne;
        address couponEmetteur;
        address proprietaire;
        uint valeur;
        string titre;
        uint datedebutAt;
        uint datefinAt;
        string etatCoupon;
    }
    
    

    // it maps the user's wallet address with the user ID
    mapping (address => uint) public usersIds;

    // Array of User that holds the list of users and their details
    User[] public users;
    User[] public emetteurs;
    User[] public distributeurs;
    User[] public consommateurs;
    Campagne[] public lesCampagnes;
    Coupon[] public lesCoupons;
    
    mapping (address => bool) public isEmetteurs;
    mapping (address => bool) public isDistributeur;
    mapping (address => bool) public isConsommateur;
    
    mapping(uint=>address) public isEmetteurCampagne;
    mapping(uint=>address) public isDistributeurCampagne;
    //mapping(address=>uint) public isMyCoupon; // determiner les mes coupons
    mapping(uint=>address) public isProprietraireCoupon; //
    mapping(uint=>address) public isEmetteurCoupon; //
    mapping(uint=>bool) public campagneGenerer;
    // event fired when an user is registered
    event newUserRegistered(uint id);

    // event fired when the user updates his status or name
    event userUpdateEvent(uint id);



    // Modifier: check if the caller of the smart contract is registered
    modifier checkSenderIsRegistered {
    	require(isRegistered());
    	_;
    }
    
    // Modifier: check if the caller of the smart contract is registered
    modifier checkSenderIsEmetteur {
    	require(CheckIsEmetteur());
    	_;
    }
    
    // Modifier: check if the caller of the smart contract is registered
    modifier checkSenderIsDistributeur {
    	require(CheckIsDistributeur());
    	_;
    }
      // Modifier: check if the caller of the smart contract is registered
    modifier checkSenderIsConsommateur {
    	require(CheckIsConsommateur());
    	_;
    }

    /**
     * Constructor function
     */
    constructor() public
    {
        addUser(address(0x0), "", "");

        addUser(address(0x33333213333333), "Leo Brown", "Distributeur");
        addUser(address(0x11121111111111), "John Doe", "Emetteur");
        addUser(address(0x22222223222222), "Mary Smith", "Distributeur");
    }

    event newCouponRegistered(uint id,uint val);

    function addCoupon(address _wAddresse,uint _campagneId,uint _couponValeur ) private
    returns(uint)
    {
        uint idcoup = lesCoupons.length++;
        Campagne storage cp = lesCampagnes[_campagneId];
        // storing the new user details
        lesCoupons[idcoup] = Coupon({
        	idCampagne: _campagneId,
            titre:strConcat(cp.name,toString(idcoup)),
        	valeur: _couponValeur,
        	couponEmetteur: _wAddresse,
        	proprietaire:address(0x0),
        	datedebutAt: now,
        	datefinAt: now+10 days,
        	etatCoupon:"Emis"
        });
        string memory varr="Emis";
        if(keccak256(abi.encodePacked(cp.etatCampagne)) == keccak256(abi.encodePacked(varr))){
            campagneGenerer[_campagneId]=true;
            cp.etatCampagne="Generer";
            
        }
       isEmetteurCoupon[idcoup] = _wAddresse;
       
               emit newCouponRegistered(idcoup,_couponValeur);
        return idcoup;
    }
    
    function registerCoupon(uint _campagneId,uint _couponValeur)  public
    returns(uint)
    {
    	return addCoupon(msg.sender, _campagneId,_couponValeur);
    }
    
    function genererCoupon(uint _campagneId,uint _couponValeur,uint _nombreCoupon)  public
    returns(bool)
    { 
        for(uint i=0 ; i< _nombreCoupon; i++){
    	     addCoupon(msg.sender, _campagneId,_couponValeur);
    	     //return true;
        }
          return true;
    }
    
    function getCouponById(uint _id) public view
    returns(
    	uint,
    	uint,
        string memory,
    	uint,
    	address,
    	address,
    	uint,
    	uint,
    	string memory
    ) {
    	Coupon memory c = lesCoupons[_id];

    	return (
    	    _id,
    		c.idCampagne,
            c.titre,
    		c.valeur,
    		c.couponEmetteur,
    		c.proprietaire,
    		c.datedebutAt,
    		c.datefinAt,
    		c.etatCoupon
    	);
    }
    
    function getEmetteurCouponById(uint _id) public view
    returns(
	    uint,
    	uint,
        string memory,
    	uint,
    	address,
    	address,
    	uint,
    	uint,
    	string memory
    ) {
    	require(CheckIsEmetteurCoupon(_id));
        return getCouponById(_id);
    }
    
    function getProprietaireCouponById(uint _id) public view
    returns(
    	uint,
    	uint,
        string memory,
    	uint,
    	address,
    	address,
    	uint,
    	uint,
    	string memory
    ) {
    	 require(CheckIsProprietaireCoupon(_id));
         return getCouponById(_id);
    }
    event newCampagneRegistered(uint id,uint nbre);

    function addCampagne(address _wAddresse, string memory  _campagneName,uint _campagneValeur) private
    returns(uint)
    {
        uint idcmap = lesCampagnes.length++;

        // storing the new user details
        lesCampagnes[idcmap] = Campagne({
        	name: _campagneName,
        	nombre: _campagneValeur,
        	campagneEmetteur: _wAddresse,
        	datedebutAt: now,
        	datefinAt: now+20 days,
        	etatCampagne:"Emis"
        });
        isEmetteurCampagne[idcmap] = _wAddresse;
        emit newCouponRegistered(idcmap,_campagneValeur);
        return idcmap;
    }

    function registerCampagne(string memory  _campagneName,uint _campagneValeur)  public
    returns(uint)
    {
    	return addCampagne(msg.sender, _campagneName,_campagneValeur);
    }
    
    function getCampagneById(uint _id) public view
    returns(
    	uint,
    	string memory,
    	address,
    	uint,
    	uint,
    	uint,
    	string memory
    ) {
    	
    	Campagne memory cp = lesCampagnes[_id];

    	return (
    		_id,
    		cp.name,
    		cp.campagneEmetteur,
    		cp.nombre,
    		cp.datedebutAt,
    		cp.datefinAt,
    		cp.etatCampagne
    	);
    }
    
   function getEmetteurCampagneById(uint _id) public view
    returns(
    	uint,
    	string memory,
    	address,
    	uint,
    	uint,
    	uint,
    	string memory
    ) {
        
    	require(CheckIsEmetteurCampagne(_id));
    	return getCampagneById(_id);
    }
       function getEmetteurCampagneGenererById(uint _id) public view
    returns(
    	uint,
    	string memory,
    	address,
    	uint,
    	uint,
    	uint,
    	string memory
    ) {
    	require(CheckIsEmetteurCampagne(_id));
        require(CheckCampagneGenerer(_id));
    	return getCampagneById(_id);
    }
    
       function getEmetteurNonCampagneGenererById(uint _id) public view
    returns(
    	uint,
    	string memory,
    	address,
    	uint,
    	uint,
    	uint,
    	string memory
    ) {
    	require(CheckIsEmetteurCampagne(_id));
        require(!CheckCampagneGenerer(_id));
    	return getCampagneById(_id);
    }
   
    function totalCampagnes() public view returns (uint)
    {
       return lesCampagnes.length;
    }
   
    function totalCoupons() public view returns (uint)
    {
         return lesCoupons.length;
    }
    
  // Check whether the redeem time is between the span of startTime and endTime.
  modifier isValidRedeemTime(uint debut,uint fin){
    require(debut <= now);
    require(fin >= now);
    _;
  } 

  // receiver is the owner to be changed to 
  function changeOwnerTo(uint idCoup, address receiver) public  {
        Coupon storage oldCoupon = lesCoupons[idCoup];
    	oldCoupon.proprietaire = receiver;
    	isProprietraireCoupon[idCoup] = receiver;
    	oldCoupon.etatCoupon="Acquis";
    	//emit ChangeOwnerTo(receiver);
  }

  // redeem the coupon
  function redeem(uint idcoup) public {
     Coupon storage oldCoupon = lesCoupons[idcoup];
	 oldCoupon.proprietaire = oldCoupon.couponEmetteur;
	 oldCoupon.etatCoupon="redeem";
  }

  // transfer the coupon ownership
  function transfer(uint idcoup ,address receiver) public  {
    changeOwnerTo(idcoup,receiver);
  }    

    
    /**
     * Function to register a new user.
     *
     * @param _userName 		The displaying name
     * @param _status        The status of the user
     */
    function registerUser(string memory _userName, bytes32 _status) public
    returns(uint)
    {
    	return addUser(msg.sender, _userName, _status);
    }



    /**
     * Add a new user. This function must be private because an user
     * cannot insert another user on behalf of someone else.
     *
     * @param _wAddr 		Address wallet of the user
     * @param _userName		Displaying name of the user
     * @param _status    	Status of the user
     */
    function addUser(address _wAddr, string memory  _userName, bytes32 _status) private
    returns(uint)
    {
        // checking if the user is already registered
        uint userId = usersIds[_wAddr];
        require (userId == 0);

        // associating the user wallet address with the new ID
        usersIds[_wAddr] = users.length;
        uint newUserId = users.length++;

        // storing the new user details
        users[newUserId] = User({
        	name: _userName,
        	status: _status,
        	walletAddress: _wAddr,
        	createdAt: now,
        	updatedAt: now
        });
        if (keccak256(abi.encodePacked(_status)) == keccak256(abi.encodePacked(stringToBytes32("Emetteur"))) ) {
            
            if (!isEmetteurs[_wAddr] ) {
                uint newEmetteurId = emetteurs.length++;
                isEmetteurs[_wAddr] = true;
                emetteurs[newEmetteurId]=User({
        	name: _userName,
        	status: _status,
        	walletAddress: _wAddr,
        	createdAt: now,
        	updatedAt: now
                });
            }
            
        }
        if (keccak256(abi.encodePacked(_status)) == keccak256(abi.encodePacked(stringToBytes32("Distributeur"))) ) {
            
            if (!isEmetteurs[_wAddr] ) {
                uint newDistributeurId = distributeurs.length++;
                isDistributeur[_wAddr] = true;
                distributeurs[newDistributeurId]=User({
        	name: _userName,
        	status: _status,
        	walletAddress: _wAddr,
        	createdAt: now,
        	updatedAt: now
                });
            }
            
        }

         if (keccak256(abi.encodePacked(_status)) == keccak256(abi.encodePacked(stringToBytes32("Consommateur"))) ) {
            
            if (!isEmetteurs[_wAddr] ) {
                uint newConsommateurId = consommateurs.length++;
                isConsommateur[_wAddr] = true;
                consommateurs[newConsommateurId]=User({
        	name: _userName,
        	status: _status,
        	walletAddress: _wAddr,
        	createdAt: now,
        	updatedAt: now
                });
            }
            
        }


        // emitting the event that a new user has been registered
        emit newUserRegistered(newUserId);
        

        return newUserId;
    }



    /**
     * Update the user profile of the caller of this method.
     * Note: the user can modify only his own profile.
     *
     * @param _newUserName	The new user's displaying name
     * @param _newStatus 	The new user's status
     */
    function updateUser(string memory _newUserName, bytes32 _newStatus) checkSenderIsRegistered public
    returns(uint)
    {
    	// An user can modify only his own profile.
    	uint userId = usersIds[msg.sender];

    	User storage user = users[userId];

    	user.name = _newUserName;
    	user.status = _newStatus;
    	user.updatedAt = now;

    	emit userUpdateEvent(userId);

    	return userId;
    }



    /**
     * Get the user's profile information.
     *
     * @param _id 	The ID of the user stored on the blockchain.
     */
    function getUserById(uint _id) public view
    returns(
    	uint,
    	string memory,
    	bytes32,
    	address,
    	uint,
    	uint
    ) {
    	User memory i = users[_id];

    	return (
    		_id,
    		i.name,
    		i.status,
    		i.walletAddress,
    		i.createdAt,
    		i.updatedAt
    	);
    }



    /**
     * Return the profile information of the caller.
     */
    function getOwnProfile() checkSenderIsRegistered public view
    returns(
    	uint,
    	string memory,
    	bytes32,
    	address,
    	uint,
    	uint
    ) {
    	uint id = usersIds[msg.sender];

    	return getUserById(id);
    }



    /**
     * Check if the user that is calling the smart contract is registered.
     */
    function isRegistered() public view returns (bool)
    {
    	return (usersIds[msg.sender] > 0);
    }



    /**
     * Return the number of total registered users.
     */
    function totalUsers() public view returns (uint)
    {
        // NOTE: the total registered user is length-1 because the user with
        // index 0 is empty check the contructor: addUser(address(0x0), "", "");
        return users.length;
    }
    
     /*
    *
    */
    function stringToBytes32(string memory testd) internal pure returns (bytes32 rt) {
        bytes memory tempEmptyStringTest = bytes(testd);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
    
        assembly {
            rt := mload(add(testd, 32))
        }
    }

    /**
     * Check if the user that is calling the smart contract is emeetteur.
     */
    function CheckIsEmetteur() public view returns (bool)
    {
    	return (isEmetteurs[msg.sender]);
    }

 
    /**
     * Check if the user that is calling the smart contract is distributeur.
     */
    function CheckIsDistributeur() public view returns (bool)
    {
    	return (isDistributeur[msg.sender]);
    }
    /**
     * Check if the user that is calling the smart contract is distributeur.
     */
    function CheckIsConsommateur() public view returns (bool)
    {
    	return (isConsommateur[msg.sender]);
    }
     function CheckIsEmetteurCampagne(uint id) public view returns (bool)
    {
    	return (isEmetteurCampagne[id]==msg.sender);
    }
     function CheckIsEmetteurCoupon(uint id) public view returns (bool)
    {
    	return (isEmetteurCoupon[id]==msg.sender);
    }
     function CheckIsProprietaireCoupon(uint id) public view returns (bool)
    {
    	return (isProprietraireCoupon[id]==msg.sender);
    }
    function CheckCampagneGenerer(uint id) public view returns (bool)
    {
    	return (campagneGenerer[id]);
    }

    function strConcat(string memory _a, string memory _b) internal pure returns (string memory){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        string memory abcde = new string(_ba.length + _bb.length );
        bytes memory babcde = bytes(abcde);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        return string(babcde);
    }
    function toString(uint _base)
        internal
        pure
        returns (string memory) {
        bytes memory _tmp = new bytes(32);
        uint i;
        for(i = 0;_base > 0;i++) {
            _tmp[i] = byte(uint8((_base % 10) + 48));
            _base /= 10;
        }
        bytes memory _real = new bytes(i--);
        for(uint j = 0; j < _real.length; j++) {
            _real[j] = _tmp[i--];
        }
        return string(_real);
    }

}