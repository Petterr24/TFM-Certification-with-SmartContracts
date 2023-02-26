// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../SculptureLibrary/SculptureLibrary.sol";
import "../UserAuthorization/UserAuthorization.sol";

contract SculptureFactory {
    
    // Singleton to allow only creating one Instance of this Smart Contract
    address private s_SculptureFactory;

    // Stores the addresses of the deployed SC (records)
    address[] private sculptures;

    // UserAuthorization instance
    UserAuthorization userAuthorizationInstance;

    event SculptureCreated(
        SculptureLibrary.PersistentData persistentData,
        SculptureLibrary.MiscellaneousData miscData,
        SculptureLibrary.EditionData editionData,
        SculptureLibrary.ConservationData conservationData
    );

    constructor(address _userAuthorizationAddress) {
        // Checks if an instance of this Smart Contract already exists
        require(s_SculptureFactory == address(0), "The Instance of this Smart Contract already exists");

        //TODO: checks if the address is a correct SC address
        userAuthorizationInstance = UserAuthorization(_userAuthorizationAddress);

        // Checks if the user to deploy this SC is an admin user
        require(userAuthorizationInstance.isAdminUser(msg.sender), "You are not authorized to deploy this SC");

        // Sets the Instance address to the address of the contract
        s_SculptureFactory = address(this);
    }

    /*function parseSculptureData(SculptureLibrary.PersistentData memory _persistentData,
        SculptureLibrary.MiscellaneousData memory _miscData,
        SculptureLibrary.EditionData memory _editionData,
        SculptureLibrary.ConservationData memory _conservationData,
        string memory _sculptureOwner
    ) private {

    }*/

    function createSculpture(
        SculptureLibrary.PersistentData memory _persistentData,
        SculptureLibrary.MiscellaneousData memory _miscData,
        SculptureLibrary.EditionData memory _editionData,
        SculptureLibrary.ConservationData memory _conservationData,
        string memory _sculptureOwner
    ) public payable returns(Sculpture) {
        // Checks if the user is an Admin user
        require(userAuthorizationInstance.isAuthorizedToCreate(msg.sender) == true, "Your are not authorized to create a record.");

        //TODO: Check if the provided data is correct
        Sculpture newSculpture = new Sculpture{value: msg.value}(_persistentData, _miscData, _editionData, _conservationData, _sculptureOwner, address(userAuthorizationInstance),s_SculptureFactory);
        address newSculptureAddress = address(newSculpture);

        sculptures.push(newSculptureAddress);

        emit SculptureCreated(_persistentData, _miscData, _editionData, _conservationData);

        return newSculpture;
    }
}

contract Sculpture {
    // UserAuthorization instance
    UserAuthorization userAuthorizationInstance;

    // SculptureFactory instance (parent)
    SculptureFactory sculptureFactoryInstance;

    // UNIX Time of the last unit modification
    uint256 public lastChangeTimestamp;

    // Sculpture data
    string private sculptureOwner;
    SculptureLibrary.PersistentData public persistentData;
    SculptureLibrary.MiscellaneousData public miscData;
    SculptureLibrary.EditionData public editionData;
    SculptureLibrary.ConservationData public conservationData;

    constructor(
        SculptureLibrary.PersistentData memory _persistentData,
        SculptureLibrary.MiscellaneousData memory _miscData,
        SculptureLibrary.EditionData memory _editionData,
        SculptureLibrary.ConservationData memory _conservationData,
        string memory _sculptureOwner,
        address _userAuthorizationAddress,
        address _sculptureFactoryAddress
    ) payable {
        persistentData = _persistentData;
        miscData = _miscData;
        editionData = _editionData;
        conservationData = _conservationData;
        sculptureOwner = _sculptureOwner;
        userAuthorizationInstance = UserAuthorization(_userAuthorizationAddress);
        sculptureFactoryInstance = SculptureFactory(_sculptureFactoryAddress);
    }

    struct UpdatedSculptureData {
        string date;
        string technique;
        string dimensions;
        string location;
        string categorizationLabel;
        string edition;
        string editionExecutor;
        string editionNumber;
    }
    
    event SculptureUpdated(uint256 timestamp, address authorizedModifier, UpdatedSculptureData updatedData);

    // TODO: add the owner
    function updateSculpture(
        string memory _date,
        string memory _technique,
        string memory _dimensions,
        string memory _location,
        uint8 _categorizationLabel,
        bool _edition,
        string memory _editionExecutor,
        string memory _editionNumber
    ) public {
        // Checks if the user has privileges to update the data
        require(userAuthorizationInstance.isAuthorizedToUpdate(msg.sender) == true, "Your are not authorized to update a record.");

        //TODO: parse the data to see if it is correct

        // Initializes the updated data struct
        UpdatedSculptureData memory updatedData = UpdatedSculptureData(
            "Not updated",
            "Not updated",
            "Not updated",
            "Not updated",
            "Not updated",
            "Not updated",
            "Not updated",
            "Not updated"
        );

        if (bytes(_date).length > 0) {
            miscData.date = _date;
            updatedData.date = _date;
        }

        if (bytes(_technique).length > 0) {
            miscData.technique = _technique;
            updatedData.technique = _technique;
        }

        if (bytes(_dimensions).length > 0) {
            miscData.dimensions = _dimensions;
            updatedData.dimensions = _dimensions;
        }

        if (bytes(_location).length > 0) {
            miscData.location = _location;
            updatedData.location = _location;
        }

        if (SculptureLibrary.isCategorizationLabelValid(_categorizationLabel)) {
            miscData.categorizationLabel = _categorizationLabel;
            updatedData.categorizationLabel = SculptureLibrary.getCategorizationLabelAsString(_categorizationLabel);
        }

        if (_edition !=  editionData.edition) {
            editionData.edition = _edition;
            
            if (_edition) {
                updatedData.edition = "Yes";
            } else {
                updatedData.edition = "No";
            }
            
        }

        if (bytes(_editionExecutor).length > 0) {
            editionData.editionExecutor = _editionExecutor;
            updatedData.editionExecutor = _editionExecutor;
        }

        if (bytes(_editionNumber).length > 0) {
            editionData.editionNumber = _editionNumber;
            updatedData.editionNumber = _editionNumber;
        }

        lastChangeTimestamp = block.timestamp;
        emit SculptureUpdated(lastChangeTimestamp, msg.sender, updatedData);
    }
}