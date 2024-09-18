pragma solidity 0.6.12;

import "forge-std/console.sol"; // solhint-disable no-global-import, no-console
import { Script } from "forge-std/Script.sol";
import { SignatureChecker } from "../../contracts/util/SignatureChecker.sol";

/**
 * A utility script to directly deploy SignatureChecker library
 *
 * @dev We need to deploy first this library and then link it since ZkSync Foundry does not yet support libraries.
 * To build and link: `forge build --zksync --libraries ./contracts/util/SignatureChecker.sol:SignatureChecker:LIBRARY_ADDRESS`
 */
contract DeployLibrary is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy the library
        new SignatureChecker();
        // console.log("SignatureChecker deployed at:", address(checker));

        vm.stopBroadcast();
    }
}
