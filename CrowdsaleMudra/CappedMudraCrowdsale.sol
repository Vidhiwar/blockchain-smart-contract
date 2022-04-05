pragma solidity >= 0.4.18;
import "./MudraCrowdsale.sol";

contract CappedMudraCrowdsale is MudraCrowdsale {

    uint fundingCap;
    constructor(uint _startTime, uint _endTime, uint _weiTokenPrice, uint _etherInvestmentObjective, uint _fundingCap)
    MudraCrowdsale(_startTime, _endTime, _weiTokenPrice, _etherInvestmentObjective) public payable {
        require(_fundingCap > 0);
        fundingCap = _fundingCap;
    }

    function isFullInvestmentWithinLimit(uint _investment) internal override(MudraCrowdsale) view returns (bool) {
        bool check = (investmentReceived + _investment) < fundingCap;
        return check; 

    }
}