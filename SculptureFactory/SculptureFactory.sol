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

    function parseSculptureData(SculptureLibrary.PersistentData memory _persistentData,
        SculptureLibrary.MiscellaneousData memory _miscData,
        SculptureLibrary.EditionData memory _editionData,
        SculptureLibrary.ConservationData memory _conservationData,
        string memory _sculptureOwner
    ) private {

    }

    function createSculpture(
        SculptureLibrary.PersistentData memory _persistentData,
        SculptureLibrary.MiscellaneousData memory _miscData,
        SculptureLibrary.EditionData memory _editionData,
        SculptureLibrary.ConservationData memory _conservationData,
        string memory _sculptureOwner
    ) public {
        // Checks if the user is an Admin user
        require(userAuthorizationInstance.isAuthorizedToCreate(msg.sender) == true, "Your are not authorized to create a record.");

        //TODO: Check if the provided data is correct
        address newSculpture = address(new Sculpture(_persistentData, _miscData, _editionData, _conservationData, _sculptureOwner, address(userAuthorizationInstance)));

        sculptures.push(newSculpture);

        emit SculptureCreated(_persistentData, _miscData, _editionData, _conservationData);
    }
}

contract Sculpture {
    // UserAuthorization instance
    UserAuthorization userAuthorizationInstance;

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
        address _userAuthorizationAddress
    ) {
        persistentData = _persistentData;
        miscData = _miscData;
        editionData = _editionData;
        conservationData = _conservationData;
        sculptureOwner = _sculptureOwner;
        userAuthorizationInstance = UserAuthorization(_userAuthorizationAddress);
    }

    // event SculptureUpdated(uint256 timestamp, address authorizedModifier);

    // TODO: add the owner
    function updateSculpture(
        uint256 _date,
        string memory _technique,
        string memory _dimensions,
        string memory _location,
        SculptureLibrary.CategorizationLabel _categorizationLabel,
        bool _edition,
        string memory _editionExecutor,
        uint256 _editionNumber
    ) public {
        // Checks if the user has privileges to update the data
        require(userAuthorizationInstance.isAuthorizedToUpdate(msg.sender) == true, "Your are not authorized to update a record.");

        if (_date > 0) {
            miscData.date = _date;
        }

        if (bytes(_technique).length > 0) {
            miscData.technique = _technique;
        }

        if (bytes(_dimensions).length > 0) {
            miscData.dimensions = _dimensions;
        }

        if (bytes(_location).length > 0) {
            miscData.location = _location;
        }

        if (SculptureLibrary.isCategorizationLabelValid(uint8(_categorizationLabel))) {
            miscData.categorizationLabel = _categorizationLabel;
        }

        if (_edition !=  editionData.edition) {
            editionData.edition = _edition;
        }

        if (bytes(_editionExecutor).length > 0) {
            editionData.editionExecutor = _editionExecutor;
        }

        if (_editionNumber > 0) {
            editionData.editionNumber = _editionNumber;
        }

        //emit SculptureUpdated()
    }
}