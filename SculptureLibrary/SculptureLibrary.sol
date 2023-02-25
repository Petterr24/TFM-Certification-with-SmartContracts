// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library SculptureLibrary {

    enum CategorizationLabel { 
        AUTHORIZED_UNIQUE_WORK, 
        AUTHORIZED_UNIQUE_WORK_VARIATION, 
        AUTHORIZED_WORK, 
        AUTHORIZED_MULTIPLE, 
        AUTHORIZED_CAST, 
        POSTHUMOUS_WORK_AUTHORIZED_BY_ARTIST, 
        POSTHUMOUS_WORK_AUTHORIZED_BY_RIGHTSHOLDERS, 
        AUTHORIZED_REPRODUCTION, 
        AUTHORIZED_EXHIBITION_COPY, 
        AUTHORIZED_TECHNICAL_COPY, 
        AUTHORIZED_DIGITAL_COPY 
    }
    
    enum ConservationLabel {
        AUTHORIZED_RECONSTRUCTION,
        AUTHORIZED_RESTORATION,
        AUTHORIZED_EPHEMERAL_WORK
    }

    struct PersistentData {
        string sculptureId;
        string name;
        string artist;
        string criticalCatalogNumber;
    }

    struct MiscellaneousData {
        uint256 date;
        string technique;
        string dimensions;
        string location;
        CategorizationLabel categorizationLabel;
    }

    struct EditionData {
        bool edition;
        string editionExecutor;
        uint256 editionNumber;
    }

    struct ConservationData {
        bool conservation;
        ConservationLabel conservationLabel;
    }

    function isCategorizationLabelValid(uint8 label) internal pure returns (bool) {
        return label >= uint8(CategorizationLabel.AUTHORIZED_DIGITAL_COPY);
    }

    function isConservationLabelValid(uint8 label) internal pure returns (bool) {
        return label >= uint8(ConservationLabel.AUTHORIZED_EPHEMERAL_WORK);
    }
}