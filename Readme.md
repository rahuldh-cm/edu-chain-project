# Simple Password Manager

## Overview

The **Simple Password Manager** is a decentralized application (dApp) built using Ethereum smart contracts. It allows users to securely store and retrieve passwords for different services on the blockchain. The system leverages **Ethereum** for storage and uses **MetaMask** to interact with the blockchain.

The application enables users to store passwords with a specific service name and retrieve them when needed. All data is stored on the blockchain to ensure transparency, immutability, and decentralization.

### Key Features:

- Store passwords for specific services securely.
- Retrieve stored passwords based on the service name.
- Interaction with Ethereum blockchain via MetaMask.

> **Note**: This project is for educational purposes. **Storing sensitive information such as passwords directly on the blockchain** is not secure and should not be used in production environments. Always implement additional security and encryption when building real-world applications.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Frontend Code](#frontend-code)
- [Usage](#usage)
- [Contract Details](#contract-details)
- [License](#license)

---

## Prerequisites

Before using the application, ensure that you have the following:

- **MetaMask** browser extension installed.
  - [Download MetaMask](https://metamask.io/).
- **Ethereum Test Network (Rinkeby, Goerli, etc.)** configured in MetaMask.
- **Web3.js** library for interacting with Ethereum blockchain.
- A **deployed instance** of the **SimplePasswordManager** smart contract on the Ethereum network.

---

## Installation

1. **Clone the repository**:

```bash
git clone https://github.com/yourusername/simple-password-manager.git
cd simple-password-manager
```

2. **Install dependencies**:
   - You can use the provided HTML file with no need for additional installation steps.
   - Simply open `index.html` in your browser to start using the dApp.

---

## Frontend Code

The frontend is a simple **HTML** page with embedded **JavaScript** that interacts with the **SimplePasswordManager** contract.

Here is an overview of the key components:

- **Web3.js**: Used to interact with the Ethereum blockchain and MetaMask.
- **MetaMask**: Allows users to sign transactions and interact with the blockchain.
- **Contract Functions**:
  - `storePassword(serviceName, password)`: Allows users to store passwords for a given service name.
  - `getPassword(serviceName)`: Allows users to retrieve the stored password for a specific service.

### HTML/JavaScript:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Simple Password Manager</title>
    <script src="https://cdn.jsdelivr.net/npm/web3/dist/web3.min.js"></script>
    <style>
      body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 20px;
      }

      h1 {
        text-align: center;
      }

      .container {
        max-width: 600px;
        margin: 0 auto;
        padding: 20px;
        background-color: #f4f4f4;
        border-radius: 10px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      }

      .input-group {
        margin-bottom: 15px;
      }

      input[type="text"],
      input[type="password"] {
        width: 100%;
        padding: 10px;
        margin: 5px 0;
        border-radius: 5px;
        border: 1px solid #ccc;
      }

      button {
        width: 100%;
        padding: 10px;
        background-color: #4caf50;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
      }

      button:hover {
        background-color: #45a049;
      }

      .output {
        margin-top: 20px;
        font-weight: bold;
        color: #333;
      }
    </style>
  </head>
  <body>
    <h1>Simple Password Manager</h1>

    <div class="container">
      <div class="input-group">
        <label for="serviceName">Service Name</label>
        <input
          type="text"
          id="serviceName"
          placeholder="Enter service name (e.g., Gmail)"
        />
      </div>

      <div class="input-group">
        <label for="password">Password</label>
        <input type="password" id="password" placeholder="Enter password" />
      </div>

      <button id="storePasswordBtn">Store Password</button>

      <div class="input-group">
        <button id="getPasswordBtn">Get Password</button>
      </div>

      <div class="output" id="outputMessage"></div>
    </div>

    <script>
      let web3;
      let contract;
      let userAccount;

      const contractAddress = "YOUR_CONTRACT_ADDRESS"; // Replace with your deployed contract address
      const contractABI = [
        // Replace with your contract ABI
        {
          inputs: [
            { internalType: "string", name: "serviceName", type: "string" },
            { internalType: "string", name: "password", type: "string" },
          ],
          name: "storePassword",
          outputs: [],
          stateMutability: "nonpayable",
          type: "function",
        },
        {
          inputs: [
            { internalType: "string", name: "serviceName", type: "string" },
          ],
          name: "getPassword",
          outputs: [{ internalType: "string", name: "", type: "string" }],
          stateMutability: "view",
          type: "function",
        },
      ];

      async function initWeb3() {
        if (window.ethereum) {
          web3 = new Web3(window.ethereum);
          await window.ethereum.enable();
          userAccount = (await web3.eth.getAccounts())[0];
          contract = new web3.eth.Contract(contractABI, contractAddress);
        } else {
          alert("Please install MetaMask to use this application.");
        }
      }

      async function storePassword() {
        const serviceName = document.getElementById("serviceName").value;
        const password = document.getElementById("password").value;
        if (!serviceName || !password) {
          document.getElementById("outputMessage").innerText =
            "Please fill out both fields.";
          return;
        }
        try {
          await contract.methods
            .storePassword(serviceName, password)
            .send({ from: userAccount });
          document.getElementById(
            "outputMessage"
          ).innerText = `Password for ${serviceName} stored successfully.`;
        } catch (error) {
          document.getElementById("outputMessage").innerText =
            "Error storing password: " + error.message;
        }
      }

      async function getPassword() {
        const serviceName = document.getElementById("serviceName").value;
        if (!serviceName) {
          document.getElementById("outputMessage").innerText =
            "Please enter a service name.";
          return;
        }
        try {
          const password = await contract.methods
            .getPassword(serviceName)
            .call({ from: userAccount });
          document.getElementById(
            "outputMessage"
          ).innerText = `Password for ${serviceName}: ${password}`;
        } catch (error) {
          document.getElementById("outputMessage").innerText =
            "Error retrieving password: " + error.message;
        }
      }

      document
        .getElementById("storePasswordBtn")
        .addEventListener("click", storePassword);
      document
        .getElementById("getPasswordBtn")
        .addEventListener("click", getPassword);

      window.onload = initWeb3;
    </script>
  </body>
</html>
```

---

## Usage

1. **Connect MetaMask**: Open the frontend application in a browser and connect your **MetaMask** wallet.
2. **Store Password**: Enter the service name and password, then click the "Store Password" button to save the password to the blockchain.
3. **Retrieve Password**: Enter the service name and click the "Get Password" button to retrieve the stored password.

---

## Contract Details

### Contract Functions

- **storePassword(string serviceName, string password)**:
  - Stores the password associated with the given service name for the sender (user).
- **getPassword(string serviceName)**:
  - Retrieves the stored password for the given service name.

### Smart Contract Address

Replace `YOUR_CONTRACT_ADDRESS` in the frontend code with the deployed contract address.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

### Disclaimer

This is a **decentralized application** and is meant to demonstrate the capabilities of blockchain technology for storing and retrieving sensitive information. Please do not store sensitive information like passwords on the blockchain in a real-world application without proper encryption and security measures.
