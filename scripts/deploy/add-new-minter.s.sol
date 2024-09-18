/**
 * Copyright 2024 Circle Internet Financial, LTD. All rights reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

pragma solidity 0.6.12;

import "forge-std/console.sol"; // solhint-disable no-global-import, no-console
import { Script } from "forge-std/Script.sol";
import { MasterMinter } from "../../contracts/minting/MasterMinter.sol";

/**
 * A utility script to add a new minter to the master minter
 * @dev Make sure to update the MINTER constant with the new minter address
 */
contract AddNewMinter is Script {
    address private minter;
    MasterMinter private masterMinter;
    uint256 private deployerPrivateKey;

    /**
     * @notice initialize variables from environment
     */
    function setUp() public {
        masterMinter = MasterMinter(vm.envAddress("MASTER_MINTER_ADDRESS"));
        minter = vm.envAddress("MINTER_ADDRESS"); // New minter
        deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        console.log("MASTER_MINTER_ADDRESS: '%s'", address(masterMinter));
    }

    /**
     * @notice main function that will be run by forge
     */
    function run() external {
        // Add Sophon's Shared Bridge as a USDC minter
        vm.startBroadcast(deployerPrivateKey);
        masterMinter.configureController(
            vm.addr(deployerPrivateKey), // controller
            minter // worker
        );
        masterMinter.configureMinter(type(uint256).max); // allowance that the minter can mint
        vm.stopBroadcast();
    }
}
