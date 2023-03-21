// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.17 and less than 0.9.0
pragma solidity ^0.8.17;


/**
 * @dev Implementation of the test interface for Arbiter writing contracts.
 */
contract InfinitelyLiquidMarket {
    uint256 _price;

    event PriceChange(uint256 price);

    function setPrice(uint256 price) public{
        _price = price;
        emit PriceChange(price);
    }
    
}
