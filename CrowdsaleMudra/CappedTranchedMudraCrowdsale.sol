pragma solidity >=0.4.24;
import "./TranchedMudraCrowdsale.sol";

contract CappedTranchedMudraCrowdsale is TranchedMudraCrowdsale {

    uint fundingCap;

    constructor(uint _startTime, uint _endTime, uint _etherInvestmentObjective, uint _fundingCap)
    TranchedMudraCrowdsale(_startTime, _endTime, _etherInvestmentObjective) public payable {
        require(_fundingCap > 0);
        fundingCap = _fundingCap;
    }

    function isFullInvestmentWithinLimit(uint _investment) internal override(MudraCrowdsale) view returns (bool) {
        bool check = (investmentReceived + _investment) < fundingCap;
        return check; 

    }
}