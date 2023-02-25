// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Smart Contract to store the privileges of those users that can create new Smart Contracts
contract UserAuthorization {
    // Singleton to allow only creating one Instance of this Smart Contract
    address private s_UserAuthorization;

    // Admin address
    address private admin;
    
    // Count the number of admin users
    uint256 numOfAdmins;

    // Data structure for users
    struct User {
        address userAddress;
        uint8 privilegeLevel;
    }

    // Mapping from user address to user data
    mapping (address => User) private users;

    // Enum for different privilege levels
    enum PrivilegeLevel {
        NONE,
        USER,
        ADMIN
    }

    constructor() {
        // Check if an instance of this Smart Contract already exists
        require(s_UserAuthorization == address(0), "The Instance of this Smart Contract already exists");
        
        // Set the Instance address to the address of the contract
        s_UserAuthorization = address(this);

        // Set the Admin address of who deployed the Smart Contract
        admin = msg.sender;

        // Increse the number of admins
        numOfAdmins++;

        // Add this admin user to the users mapping
        users[msg.sender] = User(msg.sender, uint8(PrivilegeLevel.ADMIN));
    }

    // Event for logging user authorization
    event UserAuthorized(
        address indexed userAddress,
        string privilegeLevel
    );

    // Event for logging privilege modifications
    event NewUserPrivilege(
        address indexed userAddress,
        uint8 oldPrivilegeLevel,
        uint8 newPrivilegeLevel
    );

    // Event for logging user deletion
    event UserRemoved(
        address indexed userAddress
    );

    // Authorizes a new user
    function authorizeUser(
        address _userAddress,
        uint8 _privilegeLevel
    ) public isAdmin isValidPrivilege(_privilegeLevel) {
        // Checks if the user is already authorized
        require(users[_userAddress].userAddress == address(0), "User is already created and authorized");

        // Stores the user data
        users[_userAddress] = User(_userAddress, _privilegeLevel);

        // Emits the event for logging the user authorization
        emit UserAuthorized(_userAddress, getPrivilegeAsString(uint8(_privilegeLevel)));
    }

    // Changes the user privileges
    function changeUserPrivilege(
        address _userAddress,
        uint8 _oldPrivilegeLevel,
        uint8 _newPrivilegeLevel
    ) public isAdmin isAnExistingUser(_userAddress) isValidPrivilege(_newPrivilegeLevel) {
        // Checks if the user exists
        require(users[_userAddress].userAddress != address(0), "The user does not exist");

        // Checks if the old privilege level matches with the stored privilege
        require(users[_userAddress].userAddress == _userAddress 
            && users[_userAddress].privilegeLevel == _oldPrivilegeLevel, "The provided old privilege does not match with the stored one");

        // Stores the new Privilege level
        users[_userAddress].privilegeLevel = _newPrivilegeLevel;

        // Emits the event for logging the user authorization
        emit NewUserPrivilege(_userAddress, _oldPrivilegeLevel, _newPrivilegeLevel);
    }

    // Removes an Authorized User
    function removeAuthorizedUser(
        address _userAddress
    ) public isAdmin isAnExistingUser(_userAddress) {
        
        if (isAdminUser(_userAddress)) {
            require(numOfAdmins > 2, "This admin user cannot be removed since there must be at least one Admin user");
        }

        users[_userAddress].userAddress = address(0);
        users[_userAddress].privilegeLevel = uint8(PrivilegeLevel.NONE);

        // Emits the event for logging the user removal
        emit UserRemoved(_userAddress);
    }

    // Checks if a user has the minimum privileges to create a Record
    function isAuthorizedToCreate(address _userAddress) public isAnExistingUser(_userAddress) view returns (bool) {
        // Checks if the user is authorized and has the required privilege level
        return users[_userAddress].privilegeLevel == uint8(PrivilegeLevel.ADMIN);
    }

    // Checks if a user has the minimum privileges to update a Record
    function isAuthorizedToUpdate(address _userAddress) public isAnExistingUser(_userAddress) view returns (bool) {
        // Checks if the user is authorized and has the required privilege level
        return users[_userAddress].privilegeLevel >= uint8(PrivilegeLevel.USER);
    }

    function isAdminUser(address _userAddress) public view returns (bool) {
        return (_userAddress == admin || users[_userAddress].privilegeLevel == uint8(PrivilegeLevel.ADMIN));
    }

    function isUserRegistered(address _userAddress) public view returns (bool) {
        return (users[_userAddress].userAddress != address(0));
    }

    modifier isAdmin() {
        require(msg.sender == admin || users[msg.sender].privilegeLevel == uint8(PrivilegeLevel.ADMIN), "You are not authorized to perform this action!");
        _;
    }

    modifier isValidPrivilege(uint8 _privilege) {
        require(_privilege >= uint8(PrivilegeLevel.NONE) && _privilege <= uint8(PrivilegeLevel.ADMIN), "Invalid Privilege value");
        _;
    }

    modifier isAnExistingUser(address _userAddress) {
        // Checks if the user exists
        require(users[_userAddress].userAddress != address(0), "The user does not exist!");
        _;
    }

    function getPrivilegeAsString(uint8 _privilege) private pure returns (string memory) {
        if (_privilege == uint8(PrivilegeLevel.NONE)) {
            return "User without privileges to create or update records";
        } else if (_privilege == uint8(PrivilegeLevel.USER)) {
            return "User with privileges to update an existing record";
        } else if (_privilege == uint8(PrivilegeLevel.ADMIN)) {
            return "User with privileges to create or update records";
        } else {
            revert("Invalid privilege value");
        }
    }
}
