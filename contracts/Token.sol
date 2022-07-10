pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

import "./TRC20.sol";

contract Token is TRC20 {
    constructor() public TRC20("ATron", "ATRX") {
        _mint(msg.sender, 1000 * (10 ** uint256(18))); // mints 1000 atrons!
    }
}
