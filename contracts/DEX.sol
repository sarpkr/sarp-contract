pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

import "./Token.sol";
import "./Ownable.sol";

contract DEX is Ownable {
    Token token;

    event BuyTokens(address buyer, uint256 amountOfTRX, uint256 amountOfTokens);
    event ExchangeTokens(address buyer, uint256 tokenAmountToExchange);

    function init(address addr) public onlyOwner {
        token = Token(addr);
    }

    function deposit() public payable returns (uint256 tokenAmount) {
        require(msg.value > 0, "Send TRX to deposit");

        uint256 amountToDeposit = msg.value;

        require(token.balanceOf(address(this)) >= amountToDeposit, "Vendor contract has not enough tokens in its balance");

        (bool sent) = token.transfer(msg.sender, amountToDeposit);
        require(sent, "Failed to transfer tokens to an user");

        emit BuyTokens(msg.sender, msg.value, amountToDeposit);

        return amountToDeposit;
    }

    function withdraw() public onlyOwner {
        uint256 ownerBalance = address(this).balance;
        require(ownerBalance > 0, "Owner has not balance to withdraw");

        (bool sent,) = msg.sender.call{value : address(this).balance}("");
        require(sent, "Failed to send user balance back to the owner");
    }

    function balance(address addr) public view returns (uint256 amount) {
        return token.balanceOf(addr);
    }

    function exchange(uint256 tokenAmountToExchange) public {
        require(tokenAmountToExchange > 0, 'Must be over zero');

        uint256 balance = token.balanceOf(msg.sender);
        require(balance >= tokenAmountToExchange, 'Amount should not be over balance');

        require(token.transferFrom(msg.sender, address(this), tokenAmountToExchange), 'Transfer failed');

        uint256 ownerTRXBalance = address(this).balance;
        require(ownerTRXBalance >= tokenAmountToExchange, 'Not enough balance');

        (bool success,) = msg.sender.call{value : tokenAmountToExchange}("");
        require(success, 'Failed to exchange TRX with ATRON');

        emit ExchangeTokens(msg.sender, tokenAmountToExchange);
    }
}
