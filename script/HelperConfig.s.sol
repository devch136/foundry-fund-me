// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.sol";

contract HelperConfig is Script{

    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant PRICE = 2000e8;

    struct NetworkConfig{
        address priceFeedAddress;
    }

    constructor() {
        if(block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaNetworkConfig();
        }
        else {
            activeNetworkConfig = getOrCreateLocalNetworkConfig();
        }
    }

    function getSepoliaNetworkConfig() public pure returns(NetworkConfig memory){
        return NetworkConfig(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function getOrCreateLocalNetworkConfig() public returns(NetworkConfig memory){
        if(activeNetworkConfig.priceFeedAddress != address(0)){
            return activeNetworkConfig;
        }

        vm.startBroadcast();

        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, PRICE);

        vm.stopBroadcast();

        return NetworkConfig(address(mockPriceFeed));
    }

    function getActiveNetworkConfig() public view returns(NetworkConfig memory){
        return activeNetworkConfig;
    }
}