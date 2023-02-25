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
        string date;
        string technique;
        string dimensions;
        string location;
        CategorizationLabel categorizationLabel;
    }

    struct EditionData {
        bool edition;
        string editionExecutor;
        string editionNumber;
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

    function getCategorizationLabelAsString(CategorizationLabel _enum) internal pure returns (string memory) {
        if (_enum == CategorizationLabel.AUTHORIZED_UNIQUE_WORK) {
            return "Authorized unique work";
        } else if (_enum == CategorizationLabel.AUTHORIZED_UNIQUE_WORK_VARIATION) {
            return "Authorized unique work variation";
        } else if (_enum == CategorizationLabel.AUTHORIZED_WORK) {
            return "Authorized work";
        } else if (_enum == CategorizationLabel.AUTHORIZED_MULTIPLE) {
            return "Authorized multiple";
        } else if (_enum == CategorizationLabel.AUTHORIZED_CAST) {
            return "Authorized cast";
        } else if (_enum == CategorizationLabel.POSTHUMOUS_WORK_AUTHORIZED_BY_ARTIST) {
            return "Posthumous work authorized by artist";
        } else if (_enum == CategorizationLabel.POSTHUMOUS_WORK_AUTHORIZED_BY_RIGHTSHOLDERS) {
            return "Posthumous work authorized by rightsholders";
        } else if (_enum == CategorizationLabel.AUTHORIZED_REPRODUCTION) {
            return "Authorized reproduction";
        } else if (_enum == CategorizationLabel.AUTHORIZED_EXHIBITION_COPY) {
            return "Authorized exhibition copy";
        } else if (_enum == CategorizationLabel.AUTHORIZED_TECHNICAL_COPY) {
            return "Authorized technical copy";
        } else if (_enum == CategorizationLabel.AUTHORIZED_DIGITAL_COPY) {
            return "Authorized digital copy";
        }

        revert("Invalid Categorization Label");
    }

    function getConservationLabelAsString(ConservationLabel _enum) internal pure returns (string memory) {
        if (_enum == ConservationLabel.AUTHORIZED_RECONSTRUCTION) {
            return "Authorized reconstruction";
        } else if (_enum == ConservationLabel.AUTHORIZED_RESTORATION) {
            return "Authorized restoration";
        } else if (_enum == ConservationLabel.AUTHORIZED_EPHEMERAL_WORK) {
            return "Authorized ephermal work";
        }

        revert("Invalid Conservation Label");
    }
}