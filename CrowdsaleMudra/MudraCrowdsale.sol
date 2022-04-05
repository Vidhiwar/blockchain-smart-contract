pragma solidity >=0.4.24;

import "./ReleasableMudra.sol";
import "./Pausable.sol";
import "./Destructible.sol";

contract MudraCrowdsale is Pausable, Destructible {
    uint public startTime;
    uint public endTime;
    uint public weiTokenPrice;
    uint public weiInvestmentObjective;

    mapping (address => uint) public investmentAmountOf;
    uint public investmentReceived;
    uint public investmentRefunded;

    bool public isFinalized;
    bool public isRefundingAllowed;

    uint timeStamp = block.timestamp;

    ReleasableMudra public crowdsaleToken;

    constructor(uint _startTime, uint _endTime, uint _weiTokenPrice, uint _weiInvestmentObjective) payable public {

        require(_startTime >= timeStamp);
        require(_endTime >= _startTime);
        require(_weiTokenPrice != 0);
        require(_weiInvestmentObjective != 0);

        startTime = _startTime;
        endTime = _endTime;
        weiTokenPrice = _weiTokenPrice;
        weiInvestmentObjective = _weiInvestmentObjective;

        crowdsaleToken = new ReleasableMudra(0);
        isFinalized = false;
    }

    event LogInvestment(address indexed investor, uint value);
    event LogTokenAssignment(address indexed investor, uint numTokens);
    event Refund(address investor, uint value);

    function invest() public payable {

        require(isValidInvestment(msg.value));
        
        address investor = msg.sender;
        uint investment = msg.value;

        investmentAmountOf[investor] += investment;
        investmentReceived += investment;

        assignTokens(investor, investment);
        emit LogInvestment(investor,investment);
    }

    function isValidInvestment(uint _investment) internal pure returns (bool) {
        bool nonZeroInvestment = _investment != 0;
        bool withinCrowdsalePeriod = true; //timeStamp >= startTime && timeStamp <= endTime;

        return nonZeroInvestment && withinCrowdsalePeriod && isFullInvestmentWithinLimit(_investment);
    }

    function isFullInvestmentWithinLimit(uint _investment) internal view returns (bool) {
        return true;
    }

    function assignTokens(address _beneficiary, uint _investment) internal {
        uint _numberOfTokens = calculateNumberOfTokens(_investment);

        crowdsaleToken.mintToken(_beneficiary, _numberOfTokens);
    }
    function calculateNumberOfTokens(uint _investment) internal view returns (uint) {
        return _investment/weiTokenPrice;
    }

    function finalize() onlyOwner public {
        if (isFinalized) revert();
        bool isCrowdsaleComplete = true;  //timeStamp > endTime;
        bool investmentObjectiveComplete = investmentReceived >= weiInvestmentObjective;

        if (isCrowdsaleComplete) {

            if (investmentObjectiveComplete) {

                crowdsaleToken.release();
            }
            else {
                isRefundingAllowed = true;
            }
            isFinalized = true;
        }
    }

    function refund() public {
        if (!isRefundingAllowed) revert();

        address investor = msg.sender;
        uint investment = investmentAmountOf[investor];
        if (investment == 0) revert();
        investmentAmountOf[investor] = 0;
        investmentRefunded += investment;
        emit Refund(msg.sender, investment);

        if (!payable(investor).send(investment)) revert();
    }

}