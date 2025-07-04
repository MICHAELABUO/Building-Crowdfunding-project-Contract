// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

// building Crowdfunding project Contract

contract CrowdFunding{
    
address public custodian;
uint public goal;
uint public deadline;
string public title;
uint public amountRaised;

mapping (address => uint) public contribution;

constructor (uint _goal, uint _timeframe, string memory _title ) {
custodian = msg.sender;
title = _title;
goal = _goal;
deadline = _timeframe + block.timestamp;
}

function contribute () payable public {
require (block.timestamp < deadline, "contribution time is over");
require (msg.value > 0, "contributed amount too small");
contribution [msg.sender] += msg.value;
amountRaised += msg.value;
}

function withdrawContribution() public {
require (custodian ==msg.sender, "only owner can withdraw");
require (block.timestamp > deadline, "campaign not over yet");
require (amountRaised >= goal, "campaign goal not met");
(bool sent, ) = payable(custodian).call {value: address(this).balance}("");
require (sent== true, "transfer fail");

}

function RefundSender () public {
require (block.timestamp > deadline, "campaign not over");
require (amountRaised < goal, "Campaign goal met");
uint amount = contribution [msg.sender] = 0;
require (amount > 0, "No contribution found");
(bool sent, ) = payable(msg.sender).call {value: amount}("");
require (sent== true, "transfer fail");


}





}