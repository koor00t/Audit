// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "contracts/token/ERC20/IERC20.sol";
import "contracts/utils/math/SafeMath.sol";

interface IPriceOracle {
    function getPrice(address token) external view returns (uint256);
}

contract DreamAcademyLending{
    struct UserInfo {
        uint usdc_balance;
        uint debt_balance;
        uint eth_collateral;
    }
    uint interest_rate = 100;
    uint LTV = 50;
    uint Liquidation_threshold = 75;
    IPriceOracle _dreamOracle;
    IERC20 usdc;
    mapping(address=>UserInfo) User;

    constructor(IPriceOracle _oracle,address _usdc){
        _dreamOracle = _oracle;
        usdc = IERC20(_usdc);
    }

    function initializeLendingProtocol(address _usdc) external payable {
        require(msg.value > 0,"not efficient");
        usdc.transferFrom(msg.sender,address(this),1);
    }

    function deposit(address tokenAddress, uint256 amount) external payable {
        require(amount > 0,"It is not effisient");
        if(tokenAddress == address(0)){
            require(msg.value >= amount,"your send value more than amount");
            User[msg.sender].eth_collateral += amount; // 담보액 증가
        }
        else{
            User[msg.sender].usdc_balance += amount;
            usdc.transferFrom(msg.sender, address(this), amount); // 실제 이더를 거래소로 전송
        }
    }
    function borrow(address tokenAddress, uint256 amount) external{
        require(amount>0,"borrow fail");
        require(tokenAddress == address(usdc),"only usdc address");
        
    }

    



    function repay(address tokenAddress, uint256 amount) external{

    }
    function liquidate(address user, address tokenAddress, uint256 amount) external{

    }
    function withdraw(address tokenAddress, uint256 amount) external{
        require(amount > 0, "Amount must be greater than zero");
    
        if (tokenAddress == address(0)) {
            require(amount <= User[msg.sender].eth_collateral, "Insufficient ETH collateral");
            User[msg.sender].eth_collateral -= amount;
            payable(msg.sender).transfer(amount);
        } else {
            require(amount <= User[msg.sender].usdc_balance, "Insufficient USDC balance");
            User[msg.sender].usdc_balance -= amount;
            usdc.transfer(msg.sender, amount);
        }
    }

    function getAccruedSupplyAmount(address _usdc) external payable{
        
        
    }



}