// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../SculptureLibrary/SculptureLibrary.sol";

contract SculptureFactory {
    
    address[] public sculptures;

    // Insert the admin's public key and address as private variables
    bytes32 private ownerPublicKeyHash;
    address private ownerPublicKeyAddress;

    event SculptureCreated(
        SculptureLibrary.PersistentData persistentData,
        SculptureLibrary.MiscellaneousData miscData,
        SculptureLibrary.EditionData editionData,
        SculptureLibrary.ConservationData conservationData
    );

    constructor() {
        // Insert the admin's public key hash as a constant and its address
        ownerPublicKeyHash = keccak256(abi.encodePacked(msg.sender));
        ownerPublicKeyAddress = msg.sender;
    }

    function createSculpture(
        SculptureLibrary.PersistentData memory _persistentData,
        SculptureLibrary.MiscellaneousData memory _miscData,
        SculptureLibrary.EditionData memory _editionData,
        SculptureLibrary.ConservationData memory _conservationData,
        string memory _sculptureOwner
    ) public {
        //TODO: Check if the provided data is correct
        address newSculpture = address(new Sculpture(_persistentData, _miscData, _editionData, _conservationData, _sculptureOwner));

        sculptures.push(newSculpture);

        emit SculptureCreated(_persistentData, _miscData, _editionData, _conservationData);
    }
}

contract Sculpture {
    // Insert the owner's public key and address as private variables
    bytes32 private ownerPublicKeyHash;
    address private ownerPublicKeyAddress;

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
        string memory _sculptureOwner
    ) {
        persistentData = _persistentData;
        miscData = _miscData;
        editionData = _editionData;
        conservationData = _conservationData;
        sculptureOwner = _sculptureOwner;
    }

    // event SculptureUpdated(bytes32 indexed hash, uint lastModifiedDate, address authorizedModifier);

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
        miscData.date = _date;
        miscData.technique = _technique;
        miscData.dimensions = _dimensions;
        miscData.location = _location;
        miscData.categorizationLabel = _categorizationLabel;

        editionData.edition = _edition;
        editionData.editionExecutor = _editionExecutor;
        editionData.editionNumber = _editionNumber;
        //emit SculptureUpdated()
    }
}