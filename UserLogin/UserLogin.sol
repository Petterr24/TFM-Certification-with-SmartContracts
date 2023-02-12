// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../UserAuthorization/UserAuthorization.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/ECDSA.sol";

contract UserLogin {
    // Singleton to allow only creating one Instance of this Smart Contract
    address public s_UserLogin;

    // UserAuthorization instance
    UserAuthorization userAuthorizationInstance;

    // Mapping to store users' public keys
    mapping (address => bool) public loggedInUsers;

    constructor(address _userAuthorizationAddress) {
        // Checks if an instance of this Smart Contract already exists
        require(s_UserLogin == address(0), "The Instance of this Smart Contract already exists");

        //TODO: checks if the address is a correct SC address
        userAuthorizationInstance = UserAuthorization(_userAuthorizationAddress);

        // Checks if the user to deploy this SC is an admin user
        require(userAuthorizationInstance.isAdminUser(msg.sender), "You are not authorized to deploy this SC");
        
        // Sets the Instance address to the address of the contract
        s_UserLogin = address(this);

    }

    // Login function which uses a signature verification mechanism
    function login(bytes32 _hash, uint8 _v, bytes32 _r, bytes32 _s) public {
        // Checks if the user is an already registered user by any admin
        require(userAuthorizationInstance.isUserRegistered(msg.sender) == true, "Unregistered user");

        // Verifies the signature using the verifySignature function
        require(ECDSA.recover(_hash, _v, _r, _s) == msg.sender, "Signature verification failed. Unable to log in!");
        // Logs the user in by adding their public key to the mapping
        loggedInUsers[msg.sender] = true;
    }

    // Logout function 
    function logout(address _userAddress) public {
        // Checks if the user is an already registered user by any admin
        require(userAuthorizationInstance.isUserRegistered(_userAddress) == true, "Unregistered user");

        // Checks if the user is logged in
        require(loggedInUsers[_userAddress], "You are not logged in to logout");

        loggedInUsers[_userAddress] = false;
    }

    // Checks the user status
    function isLoggedIn(address _userAddress) public view returns (bool) {
        // Checks if the user is an already registered user by any admin
        require(userAuthorizationInstance.isUserRegistered(_userAddress) == true, "Unregistered user");

        return loggedInUsers[_userAddress];
    }
}
