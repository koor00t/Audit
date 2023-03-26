// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/console.sol";

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

interface IPriceOracle {
    function getPrice(address) external view returns (uint);
    function setPrice(address token, uint256 price) external returns (uint);
}


contract DreamOracle is IPriceOracle {
   address public operator;
   mapping(address=>uint256) prices;


   constructor() {
       operator = msg.sender;
   }


   function getPrice(address token) external view returns (uint256) {
       require(prices[token] != 0, "the price cannot be zero");
       return prices[token];
   }


   function setPrice(address token, uint256 price) external returns (uint) {
       require(msg.sender == operator, "only operator can set the price");
       return prices[token] = price;
   }
}

contract DreamAcademyLending {
    IPriceOracle oracle;
    mapping (address => uint) etherDepositAmounts;
    mapping (address => mapping(address => uint)) borrowAmounts;
    constructor (IPriceOracle _oracle, address token) {
        oracle = _oracle;
    }
    function initializeLendingProtocol(address token) payable external {
        IERC20(token).transferFrom(msg.sender, address(this), msg.value);
    }
    function deposit(address tokenAddress, uint256 amount) payable external {
        require((msg.value > 0 || msg.value >= amount) || amount > 0);
        uint valueOrAmount = msg.value > 0 ? msg.value : amount;

        if (tokenAddress != address(0)) {
            IERC20(tokenAddress).transferFrom(msg.sender, address(this), valueOrAmount);
        }
        else {
            etherDepositAmounts[msg.sender] += msg.value;
        }
    }
    function borrow(address tokenAddress, uint256 amount) payable external {
        require(amount > 0);

        if (tokenAddress == address(0)) {

        }
        else {
            require(oracle.getPrice(address(0)) / 10 ** 18 * etherDepositAmounts[msg.sender] * 50 / 100 - borrowAmounts[msg.sender][tokenAddress] >= amount, "Insufficient Collaterals");

            borrowAmounts[msg.sender][tokenAddress] += amount;
            IERC20(tokenAddress).transfer(msg.sender, amount);
        }
    }
    function repay(address tokenAddress, uint256 amount) payable external {
        require((msg.value > 0 || msg.value >= amount) || amount > 0);
        uint valueOrAmount = msg.value > 0 ? msg.value : amount;

        if (tokenAddress != address(0)) {
            IERC20(tokenAddress).transferFrom(msg.sender, address(this), valueOrAmount);
            borrowAmounts[msg.sender][tokenAddress] -= valueOrAmount;
        }
        else {
            etherDepositAmounts[msg.sender] += msg.value;
        }
    }
    function liquidate(address user, address tokenAddress, uint256 amount) payable external {}
    function withdraw(address tokenAddress, uint256 amount) payable external {}
    function getAccruedSupplyAmount(address token) payable external returns (uint) {}


}