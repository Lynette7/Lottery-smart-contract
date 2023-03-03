// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery{
    address public manager;
    address payable[] public players;

    constructor() {
        //will run first when we deploy the contract for the first time
        manager = msg.sender;
    }

    function getBalance() public view returns(uint) {
        require(msg.sender == manager, "You are not the manager!");
        return address(this).balance;
        //returns amount that is stored in the smart contract
    }

    receive() payable external {
        require(msg.value == 2 ether, "Ether amount is not 2!");
        players.push(payable(msg.sender));
    }

    function random() internal view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length, block.chainid)));
        //specify uint so that result can be converted from byte to uint
    }

    function pickWinner() public {
        require(msg.sender == manager, "You are not the manager!");
        require(players.length >= 3, "You need a minimum of three players!");

        uint r= random();
        address payable winner;

        uint index = r % players.length; //divide random number by number of players

        winner = players[index]; //winner is the player at the index that was generated

        winner.transfer(getBalance()); //winner is credited with the balance

        players = new address payable[](0); //reset contract
    }
}