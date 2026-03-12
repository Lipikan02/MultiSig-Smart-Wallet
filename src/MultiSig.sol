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
        //require(_balances[msg.sender] >= _value, "Insufficient balance");
        //require(!authorized[_authorized[i]], "authorized addresses are not unique");
        require(authorized[msg.sender], "Not authorized");
        require(!idToExists[_paymentId], "Payment ID already in use");
        require(_recipient != address(0), "Invalid recipient");

        //mapping (uint256 => Payment) public idToPayment;
        idToPayment[_paymentId] = Payment ({
            recipient: _recipient,
            amount: _amount,
            numAuths: 0,
            isExecuted: false
        });

        //mapping (uint256 => bool) public idToExists;
        idToExists[_paymentId] = true;
    }

    // Authorize a payment
    function authorizePayment(uint256 paymentId) external {
        // TODO: implement
        require(authorized[msg.sender], "Not authorized");
        require(idToExists[paymentId], "Payment ID not in use");
        require(!idToPayment[paymentId].isExecuted, "Payment ID not in use");
        //if aith alrady exists error since already used
        //mapping(uint256 => mapping (address => bool)) paymentAuths;
        require(!paymentAuths[paymentId][msg.sender], "Already authenticated by user");

        paymentAuths[paymentId][msg.sender] = true;
        idToPayment[paymentId].numAuths += 1;


    }

    // Execute a payment
    function executePayment(uint256 paymentId) external {
        // TODO: implement

        require(idToExists[paymentId], "Payment ID not in use");
        //storage is a keyword that tells the EVM (Ethereum Virtual Machine) where to look for data
        Payment storage payment = idToPayment[paymentId];

        require(!payment.isExecuted, "Payment ID not in use");
        require(payment.numAuths >= authsRequired, "Not enough athentications");
        require(address(this).balance >= payment.amount, "Insufficient balance");

        // Hint: use the following code to send 5 wei to anAddress
        // (bool sent, ) = anAddress.call{value: 5}("");

        //do this now for now quick reentrant attacks
        payment.isExecuted = true;
        (bool sent, ) = payment.recipient.call{value: payment.amount}("");

        //check if succesful
        require(sent, "Failed to send Ether");

    }
}

