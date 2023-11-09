---
# theme: ./path/to/theme.json
author: Throttle (@Throt7le)
date: dd MMMM YYYY
paging: Slide %d / %d
---

# Overview

- ### Test frameworks
- ### Installing foundry
- ### Getting Started
- ### Basic Tests
- ### Libraries, console, foundry.toml
- ### Forge-std
- ### Popular Cheatcodes
- ### Forking
- ### Practice: Tests + Cheatcodes + Forking = Uniswap example
- ### Fuzz Testing
- ### Invariant Testing

## Please do ask questions anytime

Sources:
1. book.getfoundry.sh
2. https://www.youtube.com/@smartcontractprogrammer

---

# Test frameworks

#### 1. Truffle - Javascript
#### 2. Brownie - Python
#### 3. HardHat - Javascript
#### 4. Foundry - Solidity
#### 5. ApeX    - Python

---

# Installing foundry

#### 1. `$ curl -L https://foundry.paradigm.xyz | bash`
#### 2. `$ foundryup`

---

# Basic Tests

## `setUp` function

### This is automatically ran before each test, and can be used to setup any state necessary for your test.

```solidity
// Test contract needs to inherit from `Test`
contract BasicTest is Test {
    uint256 x;
    A a;

    // `setUp()` is ran before each test
    function setUp() public {
        a = new A();
        x = 42;
    }

    // Each test must start with `test` prefix to be recognized as a test by Foundry
    function test_simple() public {
        // very useful for print-debugging
        console2.log("You can print whatever here");

        assertEq(x, 42);
    }
}
```

---


# Basic Tests

## `setUp` function

### This is automatically ran before each test, and can be used to setup any state necessary for your test.

```solidity
// Test contract needs to inherit from `Test`
contract BasicTest is Test {
    uint256 x;
    A a;

    // `setUp()` is ran before each test
    function setUp() public {
        a = new A();
        x = 42;
    }

    // Each test must start with `test` prefix to be recognized as a test by Foundry
    function test_simple() public {
        // very useful for print-debugging
        console2.log("You can print whatever here");

        assertEq(x, 42);
    }
}
```

# Getting Started
### this will set up minimalistic foundry project
#### 1. `$ forge init`

### If you prefer start with different set up, you can init with template on github
#### 2. `$ forge init --template https://github.com/Thro77le/forge-template hello_foundry`

### To compile the project
#### 3. `$ forge build`

### To run all tests
#### 4. `$ forge test`

### To run all test with given prefix
#### 5. `$ forge test --match-test testExploit`

### To run tests and print the trace in case of error (and in other cases too)
#### 6. `$ forge test -vvvv`

---

# Libraries, foundry.toml

#### 1. `$ forge install OpenZeppelin/openzeppelin-contracts` // https://github.com/OpenZeppelin/openzeppelin-contracts
#### 2. `$ forge update openzeppelin-contracts`
#### 3. `$ forge remove openzeppelin-contracts`
#### 4. `$ forge install @uniswap/v2-periphery=uniswap/v2-periphery`
#### 5. `$ forge install` // install all dependencies

---

# Forge-Std

## `forge-std` is a library with utilities
####  `Vm.sol`
The most important file. Declaration of EVM cheatcodes.
####  `StdCheats.sol`
A helper for improving cheatcode UX
####  `StdAssertions.sol`
A helper file for writing assertions
####  `StdMath.sol`
A helper file for math related testing
####  `StdStorage.sol`
A helper for reading and affecting the storage of the EVM

---

# Popular Cheatcodes

#### `vm.deal(alice, 1e18);`
Set Alice balance to  1 ether
#### `vm.deal(alice, USDC_address, 100e6);`
Set Alice USDC balance to 100 USDC
#### `vm.prank(alice);`
Send a call as Alice
#### `vm.label(alice, "Alice");`
When calling trace this will print "Alice" next to her address. Helps analyzing long, complex traces
#### `vm.expectRevert();`
Expects revert to happen in next call. Prevents a reverting call to end execution
#### `vm.expectEmit();`
Expects event to be emitted in next call
#### `vm.createSelectFork(MAINNET_RPC_URL);`
Allows you to use mainnet state for your tests. After this line, tests will still run locally but will run as if it was on the forked blockchain
#### `vm.etch(address smart_contract, bytes code);`
Sets bytecode to provided address


---


# Forking
## Allows you to use mainnet state for your tests

#### `forge test --fork-url <your_rpc_url>`

#### Accessible in Solidity
```solidity
// Global way: `forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/ALCHEMY_KEY

contract ForkTest is Test {
    uint256 mainnetFork;
    
    // Anti-pattern:
    // string MAINNET_RPC_URL = 'https://eth-mainnet.g.alchemy.com/v2/ALCHEMY_KEY'

    // Access variables from .env file via vm.envString("varname")
    string MAINNET_RPC_URL = vm.envString("MAINNET_RPC_URL");
    
    // create fork but don't use it yet
    function setUp() public {
        mainnetFork = vm.createFork(MAINNET_RPC_URL);
        // vm.createAndSelectFork(MAINNET_RPC_URL);
    }

    // Use the fork
    function test_X_with_fork() public {
        vm.selectFork(mainnetFork);
        ...
    }

}
```

---

# Tests + Cheatcodes + Forking = Uniswap example

Let's test live Uniswap contracts on mainnet from scratch

---

# Fuzz Tests: Regular tests vs. fuzz tests

## Fuzzing is a technique for automated testing - it generates random tests cases

```solidity
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
}
```

---

# Fuzz Tests

## Fuzzing is a technique for automated testing - it generates random tests cases

```solidity
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



        uint256 before = token.balanceOf(alice);

        token.transfer(alice, amount); // transfer amount TKN to alice

        assertEq(before + amount, token.balanceOf(alice));
    }
}
```

---

# Fuzz Tests

## Fuzzing is a technique for automated testing - it generates random tests cases

```solidity
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



        uint256 before = token.balanceOf(alice);

        token.transfer(alice, amount); // transfer amount TKN to alice

        assertEq(before + amount, token.balanceOf(alice));
    }
}
```

### Will this test pass?

---

# Fuzz Tests

## Fuzzing is a technique for automated testing - it generates random tests cases

```solidity
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



        uint256 before = token.balanceOf(alice);

        token.transfer(alice, amount); // transfer amount TKN to alice

        assertEq(before + amount, token.balanceOf(alice));
    }
}
```


```diff
Running 1 test for test/fuzzing/FuzzTest.t.sol:FuzzingTest
-[FAIL. Reason: ERC20InsufficientBalance(0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496, 1000000000000000000000000 [1e24], 1000000000000000000000001 [1e24]) Counterexample: calldata=0xdb39cf2500000000000000000000000000000000000000000000d3c21bcecceda1000001, args=[1000000000000000000000001 [1e24]]] test_fuzzing(uint256) (runs: 45, μ: 39714, ~: 39821)
Test result: FAILED. 0 passed; 1 failed; 0 skipped; finished in 9.13ms
Ran 1 test suites: 0 tests passed, 1 failed, 0 skipped (1 total tests)
```

---

# Fuzz Tests

## Fuzzing is a technique for automated testing - it generates random tests cases

```solidity
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
        vm.assume(amount < token.totalSupply());


        uint256 before = token.balanceOf(alice);

        token.transfer(alice, amount); // transfer amount TKN to alice

        assertEq(before + amount, token.balanceOf(alice));
    }
}
```


```diff
Running 1 test for test/fuzzing/FuzzTest.t.sol:FuzzingTest
+ [PASS] test_fuzzing(uint256) (runs: 256, μ: 45923, ~: 46590)
+ Test result: ok. 1 passed; 0 failed; 0 skipped; finished in 20.46ms
Ran 1 test suites: 1 tests passed, 0 failed, 0 skipped (1 total tests)
```

---

# Fuzz Tests

## Fuzzing is a technique for automated testing - it generates random tests cases

```solidity
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
```

```diff
Running 1 test for test/fuzzing/FuzzTest.t.sol:FuzzingTest
+ [PASS] test_fuzzing(uint256) (runs: 256, μ: 45923, ~: 46590)
+ Test result: ok. 1 passed; 0 failed; 0 skipped; finished in 20.46ms
Ran 1 test suites: 1 tests passed, 0 failed, 0 skipped (1 total tests)
```

---

# Fuzz Tests

## Fuzzing is a technique for automated testing - it generates random tests cases

```solidity
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
```

```toml
[fuzz]
runs = 1024
max_test_rejects = 65536
seed = 1234
```


---


# Fuzz Tests

## Fuzzing is a technique for automated testing - it generates random tests cases

```solidity
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
```

## Questions?

---



# Invariant Tests

```solidity
contract A {
    bool public flag;
    function func_1() external {}
    function func_2() external {}
    function func_3() external {}
    function func_4() external {}
    function func_5() external { flag = true; }
}

// Invariant tests are randomized sequences of function calls
contract MyInvariantTest is Test {
    A private target;

    function setUp() public {
        // invaraint engine will randomly choose all exposed contracts and call all their exposed functions 
        target = new A();
    }

    // all invariant test names need to start with "invariant" prefix
    function invariant_flag_is_always_false() public {
        assertEq(target.flag(), false);
    }
}
```

---

# Invariant Tests

```solidity
contract A {
    bool public flag;
    function func_1() external {}
    function func_2() external {}
    function func_3() external {}
    function func_4() external {}
    function func_5() external { flag = true; }
}

// Invariant tests are randomized sequences of function calls
contract MyInvariantTest is Test {
    A private target;

    function setUp() public {
        // invaraint engine will randomly choose all exposed contracts and call all their exposed functions 
        target = new A();
    }

    // all invariant test names need to start with "invariant" prefix
    function invariant_flag_is_always_false() public {
        assertEq(target.flag(), false);
    }
}
```

## What will happen if we run this invariant test?

---

# Invariant Tests

```solidity
contract A {
    bool public flag;
    function func_1() external {}
    function func_2() external {}
    function func_3() external {}
    function func_4() external {}
    function func_5() external { flag = true; }
}

// Invariant tests are randomized sequences of function calls
contract MyInvariantTest is Test {
    A private target;

    function setUp() public {
        // invaraint engine will randomly choose all exposed contracts and call all their exposed functions 
        target = new A();
    }

    // all invariant test names need to start with "invariant" prefix
    function invariant_flag_is_always_false() public {
        assertEq(target.flag(), false);
    }
}
```

## What will happen if we run this invariant test?
```diff
Failing tests:
Encountered 1 failing test in test/invariants/InvariantBasics.sol:IntroInvariantTest
-[FAIL. Reason: Assertion failed.]
-        [Sequence]
-                sender=0x5c22070dafc36ad75f3dcf5e7237b22ade9aecc4 addr=[test/invariants/InvariantBasics.sol:InvariantIntro]0x5615deb798bb3e4dfa0139dfa1b3d433cc23b72f calldata=func_4(), args=[]
-                sender=0xad02049678e67b805207ba05712cdc634fb0fb6b addr=[test/invariants/InvariantBasics.sol:InvariantIntro]0x5615deb798bb3e4dfa0139dfa1b3d433cc23b72f calldata=func_2(), args=[]
-                sender=0x8af9cfd8ccb62ca72f5e932764e9116889d4d91e addr=[test/invariants/InvariantBasics.sol:InvariantIntro]0x5615deb798bb3e4dfa0139dfa1b3d433cc23b72f calldata=func_1(), args=[]
-                sender=0x0000000000000000000000000000000000000d97 addr=[test/invariants/InvariantBasics.sol:InvariantIntro]0x5615deb798bb3e4dfa0139dfa1b3d433cc23b72f calldata=func_2(), args=[]
-                sender=0x0000000000000000000000000000000000000947 addr=[test/invariants/InvariantBasics.sol:InvariantIntro]0x5615deb798bb3e4dfa0139dfa1b3d433cc23b72f calldata=func_1(), args=[]
-                sender=0x0000000000000000000000000000000000000ce5 addr=[test/invariants/InvariantBasics.sol:InvariantIntro]0x5615deb798bb3e4dfa0139dfa1b3d433cc23b72f calldata=func_3(), args=[]
-                sender=0x30cec75afdd22037391f942d8491ebf1985f112b addr=[test/invariants/InvariantBasics.sol:InvariantIntro]0x5615deb798bb3e4dfa0139dfa1b3d433cc23b72f calldata=func_5(), args=[]
```


---

# Invariant Tests

```solidity
contract A {
    bool public flag;
    function func_1() external {}
    function func_2() external {}
    function func_3() external {}
    function func_4() external {}
    function func_5() external { flag = true; }
}

contract MyInvariantTest is Test {
    A private target;

    function setUp() public {
        // invaraint engine will randomly choose all exposed contracts and call all their exposed functions 
        target = new A();
    }

    // all invariant test names need to start with "invariant" prefix
    function invariant_flag_is_always_false() public {
        assertEq(target.flag(), false);
    }
}
```

## What will happen if we run this invariant test?
```diff
Failing tests:
Encountered 1 failing test in test/invariants/InvariantBasics.sol:IntroInvariantTest
-[FAIL. Reason: Assertion failed.]
-        [Sequence]
-                sender=0x5c22070dafc36ad75f3dcf5e7237b22ade9aecc4 addr=[test/invariants/InvariantBasics.sol:InvariantIntro]0x5615deb798bb3e4dfa0139dfa1b3d433cc23b72f calldata=func_4(), args=[]
-                sender=0xad02049678e67b805207ba05712cdc634fb0fb6b addr=[test/invariants/InvariantBasics.sol:InvariantIntro]0x5615deb798bb3e4dfa0139dfa1b3d433cc23b72f calldata=func_2(), args=[]
-                sender=0x8af9cfd8ccb62ca72f5e932764e9116889d4d91e addr=[test/invariants/InvariantBasics.sol:InvariantIntro]0x5615deb798bb3e4dfa0139dfa1b3d433cc23b72f calldata=func_1(), args=[]
-                sender=0x0000000000000000000000000000000000000d97 addr=[test/invariants/InvariantBasics.sol:InvariantIntro]0x5615deb798bb3e4dfa0139dfa1b3d433cc23b72f calldata=func_2(), args=[]
-                sender=0x0000000000000000000000000000000000000947 addr=[test/invariants/InvariantBasics.sol:InvariantIntro]0x5615deb798bb3e4dfa0139dfa1b3d433cc23b72f calldata=func_1(), args=[]
-                sender=0x0000000000000000000000000000000000000ce5 addr=[test/invariants/InvariantBasics.sol:InvariantIntro]0x5615deb798bb3e4dfa0139dfa1b3d433cc23b72f calldata=func_3(), args=[]
-                sender=0x30cec75afdd22037391f942d8491ebf1985f112b addr=[test/invariants/InvariantBasics.sol:InvariantIntro]0x5615deb798bb3e4dfa0139dfa1b3d433cc23b72f calldata=func_5(), args=[]
```

## Default invariant engine configuration values
```toml
[invariant]
runs = 256
depth = 15
```

---

# Invariant Tests

```solidity
contract WETH {
  string public name = "Wrapped Ether";
  string public symbol = "WETH";
  uint8 public decimals = 18;

  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;

  function deposit() public payable {
    balanceOf[msg.sender] += msg.value;
  }

  function withdraw(uint256 wad) public {
    balanceOf[msg.sender] -= wad;
    payable(msg.sender).transfer(wad);
  }

  function totalSupply() public view returns (uint256) {
    return address(this).balance;
  }

  function approve(address guy, uint256 wad) public returns (bool) {
    allowance[msg.sender][guy] = wad;
    return true;
  }

  function transfer(address dst, uint256 wad) public returns (bool) {
    return transferFrom(msg.sender, dst, wad);
  }

  function transferFrom(address src, address dst, uint256 wad) public returns (bool) {
    if (src != msg.sender && allowance[src][msg.sender] != type(uint256).max) {
      allowance[src][msg.sender] -= wad;
    }
    balanceOf[src] -= wad;
    balanceOf[dst] += wad;
    return true;
  }
}

contract WETH_Open_Invariant_Tests is Test {
  WETH public weth;

  function setUp() public {
    weth = new WETH();
  }

  receive() external payable {}

  // run with `forge test --match-test invariant_totalSupply_is_always_zero`
  function invariant_totalSupply_is_always_zero() public {
    assertEq(0, weth.totalSupply());
  }
}
```

# Question 1: Which functions will be triggered?

---

# Invariant Tests

```solidity
contract WETH {
  string public name = "Wrapped Ether";
  string public symbol = "WETH";
  uint8 public decimals = 18;

  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;

  function deposit() public payable {
    balanceOf[msg.sender] += msg.value;
  }

  function withdraw(uint256 wad) public {
    balanceOf[msg.sender] -= wad;
    payable(msg.sender).transfer(wad);
  }

  function totalSupply() public view returns (uint256) {
    return address(this).balance;
  }

  function approve(address guy, uint256 wad) public returns (bool) {
    allowance[msg.sender][guy] = wad;
    return true;
  }

  function transfer(address dst, uint256 wad) public returns (bool) {
    return transferFrom(msg.sender, dst, wad);
  }

  function transferFrom(address src, address dst, uint256 wad) public returns (bool) {
    if (src != msg.sender && allowance[src][msg.sender] != type(uint256).max) {
      allowance[src][msg.sender] -= wad;
    }
    balanceOf[src] -= wad;
    balanceOf[dst] += wad;
    return true;
  }
}

contract WETH_Open_Invariant_Tests is Test {
  WETH public weth;

  function setUp() public {
    weth = new WETH();
  }

  receive() external payable {}

  // run with `forge test --match-test invariant_totalSupply_is_always_zero`
  function invariant_totalSupply_is_always_zero() public {
    assertEq(0, weth.totalSupply());
  }
}
```

## Question 2: What will be the result if we run this invariant test?

---

# Invariant Tests

```solidity
contract WETH {
  string public name = "Wrapped Ether";
  string public symbol = "WETH";
  uint8 public decimals = 18;

  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;

  function deposit() public payable {
    balanceOf[msg.sender] += msg.value;
  }

  function withdraw(uint256 wad) public {
    balanceOf[msg.sender] -= wad;
    payable(msg.sender).transfer(wad);
  }

  function totalSupply() public view returns (uint256) {
    return address(this).balance;
  }

  function approve(address guy, uint256 wad) public returns (bool) {
    allowance[msg.sender][guy] = wad;
    return true;
  }

  function transfer(address dst, uint256 wad) public returns (bool) {
    return transferFrom(msg.sender, dst, wad);
  }

  function transferFrom(address src, address dst, uint256 wad) public returns (bool) {
    if (src != msg.sender && allowance[src][msg.sender] != type(uint256).max) {
      allowance[src][msg.sender] -= wad;
    }
    balanceOf[src] -= wad;
    balanceOf[dst] += wad;
    return true;
  }
}

contract WETH_Open_Invariant_Tests is Test {
  WETH public weth;

  function setUp() public {
    weth = new WETH();
  }

  receive() external payable {}

  // run with `forge test --match-test invariant_totalSupply_is_always_zero`
  function invariant_totalSupply_is_always_zero() public {
    assertEq(0, weth.totalSupply());
  }
}
```

## Question 2: What will be the result if we run this invariant test?
## Test is successful
```diff
+[PASS] invariant_totalSupply_is_always_zero() (runs: 256, calls: 3840, reverts: 2212)
```

---

# Invariant Tests

```solidity
contract WETH {
  string public name = "Wrapped Ether";
  string public symbol = "WETH";
  uint8 public decimals = 18;

  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;

  function deposit() public payable {
    balanceOf[msg.sender] += msg.value;
  }

  function withdraw(uint256 wad) public {
    balanceOf[msg.sender] -= wad;
    payable(msg.sender).transfer(wad);
  }

  function totalSupply() public view returns (uint256) {
    return address(this).balance;
  }

  function approve(address guy, uint256 wad) public returns (bool) {
    allowance[msg.sender][guy] = wad;
    return true;
  }

  function transfer(address dst, uint256 wad) public returns (bool) {
    return transferFrom(msg.sender, dst, wad);
  }

  function transferFrom(address src, address dst, uint256 wad) public returns (bool) {
    if (src != msg.sender && allowance[src][msg.sender] != type(uint256).max) {
      allowance[src][msg.sender] -= wad;
    }
    balanceOf[src] -= wad;
    balanceOf[dst] += wad;
    return true;
  }
}

contract WETH_Open_Invariant_Tests is Test {
  WETH public weth;

  function setUp() public {
    weth = new WETH();
  }

  receive() external payable {}

  // run with `forge test --match-test invariant_totalSupply_is_always_zero`
  function invariant_totalSupply_is_always_zero() public {
    assertEq(0, weth.totalSupply());
  }
}
```

# Question 3: What are runs / calls / reverts?
```diff
+[PASS] invariant_totalSupply_is_always_zero() (runs: 256, calls: 3840, reverts: 2212)
```

---

# Invariant Tests

```solidity
contract WETH {
  string public name = "Wrapped Ether";
  string public symbol = "WETH";
  uint8 public decimals = 18;

  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;

  function deposit() public payable {
    balanceOf[msg.sender] += msg.value;
  }

  function withdraw(uint256 wad) public {
    balanceOf[msg.sender] -= wad;
    payable(msg.sender).transfer(wad);
  }

  function totalSupply() public view returns (uint256) {
    return address(this).balance;
  }

  function approve(address guy, uint256 wad) public returns (bool) {
    allowance[msg.sender][guy] = wad;
    return true;
  }

  function transfer(address dst, uint256 wad) public returns (bool) {
    return transferFrom(msg.sender, dst, wad);
  }

  function transferFrom(address src, address dst, uint256 wad) public returns (bool) {
    if (src != msg.sender && allowance[src][msg.sender] != type(uint256).max) {
      allowance[src][msg.sender] -= wad;
    }
    balanceOf[src] -= wad;
    balanceOf[dst] += wad;
    return true;
  }
}

contract WETH_Open_Invariant_Tests is Test {
  WETH public weth;

  function setUp() public {
    weth = new WETH();
  }

  receive() external payable {}

  // run with `forge test --match-test invariant_totalSupply_is_always_zero`
  function invariant_totalSupply_is_always_zero() public {
    assertEq(0, weth.totalSupply());
  }
}
```

## Question 4: What is fuzzed? And what is not fuzzed?

---

# Invariant Tests

```solidity
contract WETH {
  string public name = "Wrapped Ether";
  string public symbol = "WETH";
  uint8 public decimals = 18;

  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;

  function deposit() public payable {
    balanceOf[msg.sender] += msg.value;
  }

  function withdraw(uint256 wad) public {
    balanceOf[msg.sender] -= wad;
    payable(msg.sender).transfer(wad);
  }

  function totalSupply() public view returns (uint256) {
    return address(this).balance;
  }

  function approve(address guy, uint256 wad) public returns (bool) {
    allowance[msg.sender][guy] = wad;
    return true;
  }

  function transfer(address dst, uint256 wad) public returns (bool) {
    return transferFrom(msg.sender, dst, wad);
  }

  function transferFrom(address src, address dst, uint256 wad) public returns (bool) {
    if (src != msg.sender && allowance[src][msg.sender] != type(uint256).max) {
      allowance[src][msg.sender] -= wad;
    }
    balanceOf[src] -= wad;
    balanceOf[dst] += wad;
    return true;
  }
}

contract WETH_Open_Invariant_Tests is Test {
  WETH public weth;

  function setUp() public {
    weth = new WETH();
  }

  receive() external payable {}

  // run with `forge test --match-test invariant_totalSupply_is_always_zero`
  function invariant_totalSupply_is_always_zero() public {
    assertEq(0, weth.totalSupply());
  }
}
```

## Question 4: What is fuzzed? And what is not fuzzed?
### fuzzed: contract and function choice, msg.sender, calldata (function args)
### not fuzzed: msg.value - always 0

---

# Invariant Tests

```solidity
contract WETH {
  string public name = "Wrapped Ether";
  string public symbol = "WETH";
  uint8 public decimals = 18;

  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;

  function deposit() public payable {
    balanceOf[msg.sender] += msg.value;
  }

  function withdraw(uint256 wad) public {
    balanceOf[msg.sender] -= wad;
    payable(msg.sender).transfer(wad);
  }

  function totalSupply() public view returns (uint256) {
    return address(this).balance;
  }

  function approve(address guy, uint256 wad) public returns (bool) {
    allowance[msg.sender][guy] = wad;
    return true;
  }

  function transfer(address dst, uint256 wad) public returns (bool) {
    return transferFrom(msg.sender, dst, wad);
  }

  function transferFrom(address src, address dst, uint256 wad) public returns (bool) {
    if (src != msg.sender && allowance[src][msg.sender] != type(uint256).max) {
      allowance[src][msg.sender] -= wad;
    }
    balanceOf[src] -= wad;
    balanceOf[dst] += wad;
    return true;
  }
}

contract WETH_Open_Invariant_Tests is Test {
  WETH public weth;

  function setUp() public {
    weth = new WETH();
  }

  receive() external payable {}

  // run with `forge test --match-test invariant_totalSupply_is_always_zero`
  function invariant_totalSupply_is_always_zero() public {
    assertEq(0, weth.totalSupply());
  }
}
```

# How we can make it better?

---

# Invariant Tests

```solidity
contract Handler is CommonBase, StdCheats, StdUtils {
  WETH private weth;
  uint256 public wethBalance;

  constructor(WETH _weth) {
    weth = _weth;
  }

  function deposit(uint256 amount) public {
    amount = bound(amount, 0, address(this).balance);
    wethBalance += amount;

    weth.deposit{value: amount}();
  }

  function withdraw(uint256 amount) public {
    amount = bound(amount, 0, weth.balanceOf(address(this)));
    wethBalance -= amount;

    weth.withdraw(amount);
  }

  receive() external payable {}
}

contract WETH_Handler_Based_Invariant_Tests is Test {
  WETH public weth;
  Handler public handler;

  function setUp() public {
    weth = new WETH();
    handler = new Handler(weth);

    deal(address(handler), 100 * 1e18);

    targetContract(address(handler));

    bytes4[] memory selectors = new bytes4[](2);
    selectors[0] = Handler.deposit.selector;
    selectors[1] = Handler.withdraw.selector;

    targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));
  }

  // run with `forge test --match-test invariant_eth_balance`
  function invariant_eth_balance() public {
    assertEq(address(weth).balance, handler.wethBalance());
  }
}
```


## What will happen if we run this invariant test?
```diff
+[PASS] invariant_eth_balance() (runs: 256, calls: 3840, reverts: 0)
```

---

# Invariant Tests

```solidity
contract Handler is CommonBase, StdCheats, StdUtils {
  WETH private weth;
  uint256 public wethBalance;

  constructor(WETH _weth) {
    weth = _weth;
  }

  modifier prank(address actor) {
    vm.startPrank(actor);
    _;
    vm.stopPrank();
  }

  function deposit(uint256 amount) public prank(msg.sender) {
    amount = bound(amount, 0, msg.sender.balance);
    wethBalance += amount;

    weth.deposit{value: amount}();
  }

  function withdraw(uint256 amount) public prank(msg.sender) {
    amount = bound(amount, 0, weth.balanceOf(msg.sender));
    wethBalance -= amount;

    weth.withdraw(amount);
  }

  receive() external payable {}
}

contract WETH_Handler_Based_Invariant_Tests is Test {
  WETH public weth;
  Handler public handler;

  function setUp() public {
    weth = new WETH();
    handler = new Handler(weth);

    targetContract(address(handler));
    
    bytes4[] memory selectors = new bytes4[](2);
    selectors[0] = Handler.deposit.selector;
    selectors[1] = Handler.withdraw.selector;
    targetSelector(FuzzSelector({addr: address(handler), selectors: selectors}));

    for (uint256 i = 1337; i < 1337 + 3; i++) {
      targetSender(address(uint160(i)));
      deal(address(uint160(i)), 100 ether);
    }
  }

  // run with `forge test --match-test invariant_actor_management`
  function invariant_actor_management() public {
    uint256 total = 0;
    for (uint256 i = 1337; i < 1337 + 3; i++) {
      total += weth.balanceOf(address(uint160(i)));
    }
    assertEq(address(weth).balance, total);
  }
}
```

## What will happen if we run this invariant test?

