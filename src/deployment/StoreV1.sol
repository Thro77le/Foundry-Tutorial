// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract StoreV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
  uint256 public x;

  /// @custom:oz-upgrades-unsafe-allow constructor
  constructor() {
    _disableInitializers();
  }

  function initialize(uint256 _x) public initializer {
    __Ownable_init(msg.sender);
    __UUPSUpgradeable_init();
    x = _x;
  }

  function _authorizeUpgrade(address _newImplementation) internal override {}
}
