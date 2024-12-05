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
    address paymaster;
    uint256 deployerPrivateKey;

    function run() external {
        deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
        paymaster = vm.envAddress("PAYMASTER_ADDRESS");

        vm.startBroadcast(deployerPrivateKey);

        // Use paymaster
        bytes memory paymaster_encoded_input = abi.encodeWithSelector(
            bytes4(keccak256("general(bytes)")),
            bytes("0x")
        );
        (bool success, ) = address(vm).call(
            abi.encodeWithSignature(
                "zkUsePaymaster(address,bytes)",
                paymaster,
                paymaster_encoded_input
            )
        );
        require(success, "zkUsePaymaster() call failed");

        // Deploy library
        new SignatureChecker();

        vm.stopBroadcast();
    }
}
