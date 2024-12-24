// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimplePasswordManager {

    // Mapping to store passwords by service name and user address
    mapping(address => mapping(string => string)) private userPasswords;

    // Event to log password storage
    event PasswordStored(address indexed user, string serviceName);

    // Function 1: Store a password for a specific service
    function storePassword(string calldata serviceName, string calldata password) external {
        require(bytes(serviceName).length > 0, "Service name cannot be empty");
        require(bytes(password).length > 0, "Password cannot be empty");

        // Store the password in the mapping (private for security)
        userPasswords[msg.sender][serviceName] = password;

        // Emit event for password storage
        emit PasswordStored(msg.sender, serviceName);
    }

    // Function 2: Retrieve the password for a specific service
    function getPassword(string calldata serviceName) external view returns (string memory) {
        string memory password = userPasswords[msg.sender][serviceName];
        require(bytes(password).length > 0, "Password not found for this service");

        // Return the stored password
        return password;
    }
}
