// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor() ERC20("Token", "TKN") {
        _mint(msg.sender, 1_000_000 * 1e18); // 1 million tokens
    }
}

contract FuzzingTest is Test {
    Token token;
    address alice = 0x1E8Cc81Cdf99C060c3CA646394402b5249B3D3a0; // random address

    function setUp() public {
        token = new Token();
    }

    function test_regular() public {
        uint256 amount = 1e18; // exactly 1 TKN

        uint256 before = token.balanceOf(alice);

        token.transfer(alice, amount); // transfer 1 TKN to alice

        assertEq(before + amount, token.balanceOf(alice));
    }

    function test_fuzzing(uint256 amount) public { // random amount of tokens
        // vm.assume(amount < token.totalSupply());
        amount = bound(amount, 0, token.totalSupply());

        uint256 before = token.balanceOf(alice);

        token.transfer(alice, amount); // transfer amount TKN to alice

        assertEq(before + amount, token.balanceOf(alice));
    }
}