// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BUSD is ERC20 {
    constructor() public ERC20("Binance-Pegged-Coin", "BUSD") {
        _mint(msg.sender, 1000e18);
    }

    receive() external payable {
        _mint(msg.sender, 1000e18);
    }
}
