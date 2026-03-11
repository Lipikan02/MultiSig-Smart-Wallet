// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {MultiSig} from "../src/MultiSig.sol";

contract MultiSigTester is Test {
    address[] public myAddresses;
    uint256 paymentId = 155;
    address recipient = address(42);
    uint256 amount = 10;
    uint256 maxAuths = 50;

    function setUp() public {
        for (uint256 i = 0; i < maxAuths; i++) {
            myAddresses.push(makeAddr(string(abi.encodePacked(i))));
        }
    }

    function _tryKofN(uint256 k, uint256 n) public {
        require(n <= maxAuths, "test parameters invalid");
        require(k <= n, "test parameters invalid");

        address[] memory tempAddresses = new address[](n);
        for (uint256 i = 0; i < n; i++) {
            tempAddresses[i] = myAddresses[i];
        }

        vm.deal(recipient, 0);  // set recipient balance to 0
        MultiSig multisig = new MultiSig(tempAddresses, k);
        vm.deal(address(multisig), amount);  // give contract eth

        vm.prank(tempAddresses[0]);  // act as this address
        multisig.proposePayment(paymentId, recipient, amount);
        for (uint256 i = 0; i < k; i++) {
            vm.prank(tempAddresses[i]);  // act as this address
            multisig.authorizePayment(paymentId);
        }
        assertEq(recipient.balance, 0);
        multisig.executePayment(paymentId);  // we can call even if unauthorized
        assertEq(recipient.balance, amount);
    }

    function test_2of3() public {
        _tryKofN(2, 3);
    }
}

