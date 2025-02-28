//SPDX-License-Identifier: MIT

pragma solidity 0.8.19; 

import {PriceConverter} from "./PriceConverter.sol";

error Unauthorized();
error LowFunds();
error CallFailed();

contract FundMe {

    using PriceConverter for uint256;

    address immutable public i_owner;
    address immutable public i_priceFeedAddress;
    uint256 constant public MIN_USD = 5e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmount;

    constructor(address _priceFeedAddress) {
        i_owner = msg.sender;
        i_priceFeedAddress = _priceFeedAddress;
    }

    function fund() public payable {
        //require((msg.value.weiToUSD()) >= MIN_USD, "Didn't send enough ETH");
        //require to revert for low gas costs
        if((msg.value.weiToUSD(i_priceFeedAddress)) < MIN_USD){
            revert LowFunds();
        }
        funders.push(msg.sender);
        addressToAmount[msg.sender] += msg.value;
    }
    
    function getBalanceInUSD() public view returns(uint256) {
        uint256 balanceInWei = address(this).balance;
        return ((balanceInWei.weiToUSD(i_priceFeedAddress))/(10**18));
    }

    function cheapWithdraw() public onlyOwner {
        //It will cost less gas
        //we will reduce the no of time we will read from storage
        uint256 len = funders.length;
        for(uint64 i=0; i < len; i++){
            addressToAmount[funders[i]] = 0;
        }
        funders = new address[](0);
        
        //call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        // require(callSuccess == true, "Call failed!");
        if(callSuccess == false){
            revert CallFailed();
        }
    }

    function withdraw() public onlyOwner{
        //reseting mapping to 0
        for(uint64 i=0; i < funders.length; i++){
            addressToAmount[funders[i]] = 0;
        }
        funders = new address[](0);

        //transfer
        //payable(msg.sender).transfer(address(this).balance);

        //send
        //bool success = payable(msg.sender).send(address(this).balance);
        //require(success == true, "send failed!");

        //call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        // require(callSuccess == true, "Call failed!");
        if(callSuccess == false){
            revert CallFailed();
        }
    }

    function getVersion() public view returns(uint256){
        return PriceConverter.getVersion(i_priceFeedAddress);
    }
    
    modifier onlyOwner {
        //require(msg.sender == i_owner, "Only owner is allowed");
        if(msg.sender != i_owner) {
            revert Unauthorized();
        }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}