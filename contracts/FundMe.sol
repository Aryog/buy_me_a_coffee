// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
//Pragma
pragma solidity 0.8.12;
// Imports
import "./PriceConverter.sol";
// Errors
error FundMe__NotOwner();

/**
 * @title A contract for crowd support
 * @author Yogesh Aryal
 * @notice This contract is to demo buy me a coffee
 * @dev This implements pric feeds as our libraray
 */
contract FundMe {
    using priceConverter for uint256;

    //  Using For
    //  The directive using A for B; can be used to attach library functions of library A to a given type B. These functions will used the caller type as their first parameter (identified using self).

    uint256 public constant MINIMUM_USD = 25;
    address[] private funders;
    mapping(address => uint256) private addressToAmountFunded;

    address private immutable i_owner;
    AggregatorV3Interface public priceFeed;
    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Sender is not owner!");
        // _;
        // all the code here whoever calls the onlyOwner modifier
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    // using immutable and constant variables to make it gas efficient
    constructor(address priceFeedAddress) {
        // deployer of the contract is the first who runs constructor
        i_owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function fund() public payable {
        // want to be able to set a minimum fund.
        // 1. How do we send ETH to this contract?
        // require method says if the first statement is false then revert with the error.

        // msg.value is uint type which get passed to getConversionRate library funtion.
        require(
            msg.value.getConversionRate(priceFeed) >= MINIMUM_USD,
            "Didn't send enough"
        ); // 1e18 == 1 * 10 ** 18 (1 Eth in wei)
        funders.push(msg.sender);
        // storing the amount funded
        addressToAmountFunded[msg.sender] += msg.value;
        // What is reverting?
        // undo any action before, and send remaining gas back.
    }

    function Withdraw() public onlyOwner {
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0; //reset
        }
        // reset the array
        funders = new address[](0);
        // actually withdraw the funds
        // transfer
        // send
        // call
        payable(msg.sender).transfer(address(this).balance);
        // send
        bool sendSuccess = payable(msg.sender).send(address(this).balance);
        require(sendSuccess, "Send failed");
        // call (best option)
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    // if the fund is received by contract accidently
    // we use receive function and fallback function to handle.

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getFunder(uint256 index) public view returns (address) {
        return funders[index];
    }

    function getAddressToAmountFunded(address funder)
        public
        view
        returns (uint256)
    {
        return addressToAmountFunded[funder];
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return priceFeed;
    }
}
