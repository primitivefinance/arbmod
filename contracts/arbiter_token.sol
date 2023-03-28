pragma solidity ^0.8.10;
import "../../openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
contract ArbiterToken is ERC20 {
    constructor(string memory name, string memory symbol) 
        ERC20(name, symbol) {
        
    }

    function mint(address receiver, uint256 amount) public {
        _mint(receiver, amount);
    }
}