// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.6;
// pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Nice} from "Nice/Nice.sol";
import {IUniswapV2Router} from "../../src/cheatcodes/IUniswapV2Router.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {WETH} from "./WETH.sol";

contract UniswapTest is Test {
  using Nice for uint256;

  address alice;
  address dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
  address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
  IUniswapV2Router public router = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

  string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");
  uint256 block_number = 18_312_872;

  function setUp() public {
    vm.createSelectFork(MAINNET_RPC_URL, block_number);

    alice = createUser("alice");
    deal(address(weth), alice, 1_000_000e18);
    deal(address(dai), alice, 1_000_000e18);

    // FILL HERE
    WETH w = new WETH();
    bytes memory code = address(w).code;
    vm.etch(weth, code);
  }

  //. `forge test --match-test test_add_liquidity_good`
  //. -vv for printing console log
  //. -vvvv for printing trace
  function test_add_liquidity_good() public {
    // FILL HERE
    vm.startPrank(alice);

    IERC20(weth).approve(address(router), type(uint256).max);
    IERC20(dai).approve(address(router), type(uint256).max);

    (uint256 amountToken, uint256 amountWETH, uint256 liquidity) =
      router.addLiquidity(dai, weth, 2000e18, 1 ether, 0, 0, alice, block.timestamp);

    console2.log("Sent DAI = %s", amountToken.format());
    console2.log("Sent WETH = %s", amountWETH.format());
    console2.log("Received LP token = %s", liquidity.format());

    assertGe(liquidity, 20e18);

    vm.stopPrank();
  }

  // `forge test --match-test test_add_liquidity_fail`
  function test_add_liquidity_fail() public {
    vm.startPrank(alice);

    //. now apporaval is commented out so we should revert when adding liquidity
    IERC20(dai).approve(address(router), type(uint256).max);

    vm.expectRevert();
    (uint256 amountToken, uint256 amountETH, uint256 liquidity) =
      router.addLiquidityETH{value: 1 ether}(dai, 2000e18, 0, 0, alice, block.timestamp);

    console2.log("Sent DAI = %s", amountToken.format());
    console2.log("Sent ETH = %s", amountETH.format());
    console2.log("Received LP token = %s", liquidity.format());

    vm.stopPrank();
  }

  // creates a user
  function createUser(string memory name) private returns (address _user) {
    _user = address(uint160(uint256(keccak256(abi.encode(name)))));
    vm.label(_user, name); //. label will be present in trace
    vm.deal(_user, 10_000 ether);
  }
}
