// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import {SlotPuzzle} from "src/SlotPuzzle.sol";
import {SlotPuzzleFactory} from "src/SlotPuzzleFactory.sol";

contract SlotPuzzleTest is Test {
    SlotPuzzle public slotPuzzle;
    SlotPuzzleFactory public slotPuzzleFactory;
    address aravindh;

    function setUp() public {
        slotPuzzleFactory = new SlotPuzzleFactory{value: 3 ether}();
        aravindh = makeAddr("aravindh");

        vm.deal(address(aravindh), 1 ether);
    }

    function testHack() public {
        vm.startPrank(aravindh,aravindh);
        assertEq(address(slotPuzzleFactory).balance, 3 ether, "weth contract should have 10 ether");

        slotPuzzle = new SlotPuzzle();

        
        vm.stopPrank();
    }
}