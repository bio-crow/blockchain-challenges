// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfTokens);

  YourToken public token;
  address private immutable i_owner;
  uint256 public constant tokensPerEth = 100;

  constructor(address tokenAddress) {
    token = YourToken(tokenAddress);
    i_owner = msg.sender;
  }

  // Payable function to buy tokens
  function buyTokens() public payable {
    //msg.value is the amount of wei
    uint256 tokens = tokensPerEth * (msg.value / 1 ether);

    token.transfer(msg.sender, tokensPerEth * msg.value);

    emit BuyTokens(msg.sender, msg.value / 1 ether, tokens);
  }

  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner {
    (bool callSuccess, ) = i_owner.call{value: address(this).balance}("");
    require(callSuccess, "call failed");
  }

  // ToDo: create a sellTokens(uint256 _amount) function:

  function sellTokens(uint256 _amount) public {
    token.approve(address(this), _amount);
    token.transferFrom(msg.sender, address(this), _amount);
    //have to use call so it takes care of the gas .... trasnferFrom does not transfer money to your wallet, it only gives the tokens back to the contract , so if
    //you want the funds as eth in  your wallet , you need to use call
    (bool callSuccess, ) = i_owner.call{value: address(this).balance}("");
    require(callSuccess, "call failed");
  }
}
