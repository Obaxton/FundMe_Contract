//SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

/**
  * Allow a user to send a donation with a minimum amount.
  * Once the total balance of donations reaches a minimum withdrawl amount, the owner can withdraw the entire balance.
  * The owner can view and withdraw the current balance, change minimum donation and withdrawl amount, and transfer ownership of the contract to a new address.
  */

contract FundMe {
    address private owner;
    uint256 minimumDonation; //default is 1 Gwei
    uint256 minimumWithdrawl; //default is 1 Gwei

    //constructor for state variables.
    constructor() {
        owner = msg.sender;
        minimumDonation = 1000000000;
        minimumWithdrawl = 1000000000;
    }

    //contract settings
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this.");
        _;
    }

    //user will send a value to be stored in the contract.
    function makeDonation() public payable {
        require(msg.sender.balance >= msg.value && msg.value >= minimumDonation, "Insufficient funds or minimum donation is not met."); //requires the sender to have the amount and the value be greater than the minimum donation amount.
    }

    //the owner of the contract can withdraw the minimum amount.
    function collectBalance() public payable onlyOwner {
        require(address(this).balance >= minimumWithdrawl, "Payout not available yet."); //requires the balance to be greater than or equal to the minimum withrawl amount.
        payable(owner).transfer(address(this).balance); //transfers current balance to the owner 
    }

    //shows the owner of the contract the current balance held in the contract.
    function showFunds() public view onlyOwner returns(uint256) {
        return address(this).balance;
    }

    //changes owner to new address
    function changeOwner(address newOwner) public onlyOwner {
        owner = newOwner;
    }

    //change minimum donation amount
    function changeMinimumDonation(uint256 newMinDonation) public onlyOwner {
        minimumDonation = newMinDonation;
    }

    //change minimum withdraw amount
    function changeMinimumWithdrawl(uint256 newMinWithdrawl) public onlyOwner {
        minimumWithdrawl = newMinWithdrawl;
    }
}