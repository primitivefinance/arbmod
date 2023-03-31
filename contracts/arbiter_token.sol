pragma solidity ^0.8.10;
import "../../openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract ArbiterToken is ERC20 {
    address public admin;

    constructor(string memory name, string memory symbol) 
        ERC20(name, symbol) {
            admin = msg.sender; // Set the contract deployer as the initial admin
    }

    // Our admin lock
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    function mint(address receiver, uint256 amount) public onlyAdmin {
        _mint(receiver, amount);
    }

    function mintMax(address receiver) public onlyAdmin {
        _mint(receiver, type(uint256).max);
    }
}