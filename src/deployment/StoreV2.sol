// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract StoreV2 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
  uint256 public x;
  uint256 public y;

  /// @custom:oz-upgrades-unsafe-allow constructor
  constructor() {
    _disableInitializers();
  }

  function initialize() public initializer {
    __Ownable_init(msg.sender);
    __UUPSUpgradeable_init();
  }

  function setY(uint256 _y) external {
    y = _y;
  }

  function _authorizeUpgrade(address _newImplementation) internal override {}
}
