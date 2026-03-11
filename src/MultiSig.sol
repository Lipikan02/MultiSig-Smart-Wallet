// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract MultiSig {
    struct Payment {
        address recipient;
        uint256 amount;
        uint256 numAuths;
        bool isExecuted;
    }

    // A table of which addresses are authorized for this wallet
    mapping (address => bool) public authorized;

    // The number of authorizations required
    uint256 public authsRequired;

    // Map a paymentId to a struct of data about it
    mapping (uint256 => Payment) public idToPayment;

    // Keep track of which paymentIds exist
    mapping (uint256 => bool) public idToExists;

    // For each paymentId, a table of which addresses have authorized it
    mapping(uint256 => mapping (address => bool)) paymentAuths;

    // Constructor: initialize member variables
    constructor(address[] memory _authorized, uint256 _authsRequired) {
        for (uint i = 0; i < _authorized.length; i++) {
            require(!authorized[_authorized[i]], "authorized addresses are not unique");
            authorized[_authorized[i]] = true;
        }
        authsRequired = _authsRequired;
    }

    // This function allows this smart contract to receive and hold Ether
    receive() external payable { }

    // Propose a new payment
    function proposePayment(uint256 _paymentId, address _recipient, uint256 _amount) external {
        // TODO: implement
    }

    // Authorize a payment
    function authorizePayment(uint256 paymentId) external {
        // TODO: implement
    }

    // Execute a payment
    function executePayment(uint256 paymentId) external {
        // TODO: implement

        // Hint: use the following code to send 5 wei to anAddress
        // (bool sent, ) = anAddress.call{value: 5}("");
    }
}

