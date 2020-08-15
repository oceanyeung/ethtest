pragma solidity 0.5.12;

contract hasCost {
    modifier costs(uint cost) {
        require(msg.value >= cost);
        _;
    }
}
