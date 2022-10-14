// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract Tip {

    address payable public User1;
    address payable public User2;
    address payable public User3;

    uint256 public fee;

     event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );

    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    // initialize 3 users that tip will be split between
    constructor (address payable user1, address payable user2, address payable user3) {
        User1 = user1;
        User2 = user2;
        User3 = user3;
    }

    // List of all memos received from friends
    Memo[] memos;

    // retrieves list of tips that are stored
     function getAllMemos() public view returns (Memo[] memory) {
        return memos;
    }
    
    // be able to tip and have the tips stored inside contract
    function tip(string memory _name, string memory _message) payable external {
        uint256 cost = 0.001 ether;
        require(msg.value <= cost, "Tip must be greater than 0");
        
        // add memo to storage, store data in array
        memos.push(Memo(msg.sender, block.timestamp, _name, _message));
        // Emit a log event when a new memo is created
        emit NewMemo(msg.sender, block.timestamp, _name, _message);
    }

    // notes the balance stored in the contract
    function getBalance() public view returns (uint256 _balance) {
        return address(this).balance;
    }

    // distributes the tips to the assigned addresses by calling split function
    // then, it transfers the proper amount to inputted addresses
    // splits the amount stored in the contract and transfers to users
    function Withdraw() public payable {
        require(msg.sender != address(0), "not owner");

        uint256 splitBalance = address(this).balance / 3;

        // send split amount to each user
        User1.transfer(splitBalance);
        User2.transfer(splitBalance);
        User3.transfer(splitBalance);
    }
}