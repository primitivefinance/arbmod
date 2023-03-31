// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.17 and less than 0.9.0
pragma solidity ^0.8.17;
// import "solmate/utils/FixedPointMathLib.sol"; // This import is correct given Arbiter's foundry.toml
import "../../portfolio/lib/solmate/src/utils/FixedPointMathLib.sol"; // This import goes directly to the contract
import "../../openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

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
    event Swap(address token_in, address token_out, uint256 amount_in, uint256 amount_out, address to);

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
        address token_out_address;
        if (_token_in_address == arbiter_token_x_address) {
            // amount_out = FixedPointMathLib.mulWadDown(_amount_in, price);
            amount_out = _amount_in * price;
            // Set allowances
            // arbiter_token_x.increaseAllowance(msg.sender, _amount_in);
            // arbiter_token_y.increaseAllowance(admin, amount_out); //might not be necessary if we increase the allowance for the manager outside of this
            // Transfer amount in and amount out
            arbiter_token_x.transferFrom(msg.sender, admin, _amount_in);
            arbiter_token_y.transferFrom(admin, msg.sender, amount_out);
        } else if (_token_in_address == arbiter_token_y_address) {
            amount_out = FixedPointMathLib.divWadDown(_amount_in, price);
            // Transfer amount in and amount out
            arbiter_token_y.transferFrom(msg.sender, admin, _amount_in);
            arbiter_token_x.transferFrom(admin, msg.sender, amount_out);
        } else {
            revert("Invalid token");
        }
        emit Swap(_token_in_address, token_out_address, _amount_in, amount_out, msg.sender);    
    }
}