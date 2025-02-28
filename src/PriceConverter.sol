//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


library PriceConverter {
    function getPrice(address priceFeedAddress) internal view returns(uint256) {
        AggregatorV3Interface dataFeed = AggregatorV3Interface(priceFeedAddress);

        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();

        return uint256(answer) * 10 ** 10;

    }

    function weiToUSD(uint256 val, address priceFeedAddress) internal view returns(uint256){
        return ((val * getPrice(priceFeedAddress) )/ 10 ** 18);
    }

    function getVersion(address priceFeedAddress) internal view returns(uint256) {
        AggregatorV3Interface dataFeed = AggregatorV3Interface(priceFeedAddress);
        return dataFeed.version();
    }

}