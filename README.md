# FundMe Project

The **FundMe** project is a smart contract built using Solidity and deployed with **Foundry**. It allows users to fund the contract with Ethereum, ensuring that a minimum donation threshold in USD is met. The contract owner can withdraw the funds, with two different methods available: a regular withdrawal and a gas-efficient withdrawal.

## Features

- **User Funding**: Users can send ETH to the contract, provided the donation meets a minimum threshold (in USD).
- **Owner Withdrawals**: Only the contract owner can withdraw funds.
- **Gas-Efficient Withdrawals**: The contract includes a method for gas-efficient withdrawals.
- **Unit Tests**: Comprehensive tests to ensure correct functionality.

## Project Structure
```bash

├── src/
│   ├── FundMe.sol         # Main contract logic
│   └── PriceConverter.sol # Helper library for USD conversion
├── script/
│   ├── DeployFundMe.s.sol # Deployment script
│   └── HelperConfig.s.sol # Price feed and local network configuration
├── test/
│   └── FundMeTest.sol     # Unit tests for the contract
├── test/mock/
│   └── MockV3Aggregator.sol # Mock price feed for testing
├── foundry.toml           # Foundry configuration
└── README.md              # Project README

```
## Installation

### 1. Install Foundry

Install Foundry using the following command:

```bash

curl -L https://foundry.paradigm.xyz | bash
foundryup

```
### 2. Clone the Repository

Clone the project to your local machine:

```bash
git clone <repository_url>
cd FundMe
```
### 3. Compile the Contracts

Compile the contracts:

```bash
forge build
```

### 4. Run Unit Tests

Run the unit tests:

```bash
forge test
```
### 5. Deploy the Contract

To deploy the contract to a network, run:

```bash
forge script script/DeployFundMe.s.sol --rpc-url <your_rpc_url> --private-key <your_private_key> --broadcast
```
Replace <your_rpc_url> and <your_private_key> with your network's RPC URL and your private key.

## Key Contract Methods
- fund(): Allows users to send ETH to the contract.
- withdraw(): Allows the owner to withdraw the contract's balance.
- cheapWithdraw(): A gas-efficient withdrawal method for the owner.
- getBalanceInUSD(): Returns the contract's balance in USD terms.
- getVersion(): Returns the version of the price feed.

## License
This project is open-source and available under the MIT License.
