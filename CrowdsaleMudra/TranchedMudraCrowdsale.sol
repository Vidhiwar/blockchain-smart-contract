pragma solidity >= 0.4.24;

import "./MudraCrowdsale.sol";

contract TranchedMudraCrowdsale is MudraCrowdsale {

    struct Tranche {
        uint weiCeiling;
        uint weiTokenPrice;
    }

    mapping (uint => Tranche) public trancheStructure;
    uint public currentTrancheLevel;

    constructor (uint _startTime, uint _endTime, uint _etherInvestmentObjective) MudraCrowdsale(_startTime, _endTime, 1, _etherInvestmentObjective) payable public {
        trancheStructure[0] = Tranche(3000 ether, 0.002 ether);
        trancheStructure[1] = Tranche(10000 ether, 0.003 ether);
        trancheStructure[2] = Tranche(15000 ether, 0.004 ether);
        trancheStructure[3] = Tranche(1000000000 ether, 0.005 ether);

        currentTrancheLevel = 0;
    }

    function calculateNumberOfTokens(uint investment) internal view override(MudraCrowdsale) returns (uint) {
        updateCurrentTrancheAndPrice();
        return investment/ weiTokenPrice;
    }

    function updateCurrentTrancheAndPrice() internal {
        uint i = currentTrancheLevel;

        while(trancheStructure[i].weiCeiling < investmentReceived){
            ++i;
        }

        currentTrancheLevel = i;
        weiTokenPrice = trancheStructure[currentTrancheLevel].weiTokenPrice;
    }
}