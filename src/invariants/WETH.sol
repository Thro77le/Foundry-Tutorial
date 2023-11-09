// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract WETH {
  string public name = "Wrapped Ether";
  string public symbol = "WETH";
  uint8 public decimals = 18;

  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;

  function deposit() public payable {
    balanceOf[msg.sender] += msg.value;
  }

  function withdraw(uint256 wad) public {
    balanceOf[msg.sender] -= wad;
    payable(msg.sender).transfer(wad);
  }

  function totalSupply() public view returns (uint256) {
    return address(this).balance;
  }

  function approve(address guy, uint256 wad) public returns (bool) {
    allowance[msg.sender][guy] = wad;
    return true;
  }

  function transfer(address dst, uint256 wad) public returns (bool) {
    return transferFrom(msg.sender, dst, wad);
  }

  function transferFrom(address src, address dst, uint256 wad) public returns (bool) {
    if (src != msg.sender && allowance[src][msg.sender] != type(uint256).max) {
      allowance[src][msg.sender] -= wad;
    }
    balanceOf[src] -= wad;
    balanceOf[dst] += wad;
    return true;
  }
}
