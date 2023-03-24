// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.17 and less than 0.9.0
pragma solidity ^0.8.17;
// import "solmate/utils/FixedPointMathLib.sol"; // This import is correct given Arbiter's foundry.toml
import "../../portfolio/lib/solmate/src/utils/FixedPointMathLib.sol"; // This import goes directly to the contract
import "./erc20_contracts/erc20/contracts/ERC20.sol";

/**
 * @dev Implementation of the test interface for Arbiter writing contracts.
 */
contract LiquidExchange {
    using FixedPointMathLib for int256;
    using FixedPointMathLib for uint256;
    address public admin;
    ERC20 public arbiter_token_x;
    address public arbiter_token_x_address;
    ERC20 public arbiter_token_y;
    address public arbiter_token_y_address;
    uint256 public price;
    uint256 public constant WAD = 10**18;

    // Each LiquidExchange contract will be deployed with a pair of token addresses and an initial price
    constructor(address _arbiter_token_x, address _arbiter_token_y, uint256 _price) {
        admin = msg.sender; // Set the contract deployer as the initial admin
        arbiter_token_x = ERC20(_arbiter_token_x);
        arbiter_token_x_address = _arbiter_token_x;
        arbiter_token_y = ERC20(_arbiter_token_y);
        arbiter_token_y_address = _arbiter_token_x;
        price = _price;
    }

    // Our admin lock
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    event PriceChange(uint256 price);
    // TODO: This event may not really be necessary.
    event SwapOccured(address token_in, uint256 amount_in, address token_out, uint256 amount_out);

    // Admin only function to set the price of x in terms of y
    function setPrice(uint256 _price) public onlyAdmin {
        price = _price;
        emit PriceChange(price);
    }
    
    // Returns the price of x in terms of y (i.e., y is the numeraire)
    function getPrice() public view returns (uint256) {
        return price;
    }

    // TODO: This function is NOT completed yet. It is just a placeholder for now.
    function swap(address _token_in_address, uint256 _amount_in) public {
        uint256 amount_out;
        ERC20 token_out;
        address token_out_address;
        if (_token_in_address == arbiter_token_x_address) {
            // amount_out = FixedPointMathLib.mulWadDown(_amount_in, price);
            amount_out = _amount_in * price;
            token_out = arbiter_token_y;
            // TODO: Transfer amount_out of arbiter_token_y to msg.sender
            token_out.transfer(msg.sender, amount_out);

            // consider minting here
        } else if (_token_in_address == arbiter_token_y_address) {
            amount_out = FixedPointMathLib.divWadDown(_amount_in, price);
            token_out = arbiter_token_x;
            // TODO: Transfer amount_out of arbiter_token_x to msg.sender
        } else {
            revert("Invalid token");
        }
        emit SwapOccured(_token_in_address, _amount_in, token_out_address, amount_out);    
    }
}