// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
struct Account{
    address userAddress;
    uint userId;
    bool isHolder;
    uint balance;
    Transaction[] transactions;
    uint lastInterestTime;
}
struct Transaction{
    uint txId;
    uint amount;
    uint time;
    string transactionType;
}
contract Simple_Bank{
    mapping(address => Account)internal balances;
    Account[] internal accounts;
    address public admin;
    uint immutable interestRate;
    uint minimumTime;

    constructor(uint _interestRate,uint _minimumTimeInMonths){
        admin = msg.sender;
        interestRate = _interestRate;
        minimumTime = ( _minimumTimeInMonths * 30 * 24 * 60 * 60); //cpnverts months to seconds;
    }
         receive() external payable { 
        require(balances[msg.sender].isHolder,"Must have an account!");
        balances[msg.sender].balance += msg.value;
        uint txId = (balances[msg.sender].transactions.length + 1);
        Transaction memory transaction = Transaction(txId,msg.value,block.timestamp,"deposit");
        balances[msg.sender].transactions.push(transaction);
     }
         fallback()external payable{
        revert("call a valid function!");
    }

    modifier onlyOwner(){
        require(admin == msg.sender,"You are not an admin!");
        _;
    }
    modifier onlyHolders(){
        require(balances[msg.sender].isHolder == true,"You dont have an account yet!");
        _;
    }



    //events

function addAccount () external {
require(!balances[msg.sender].isHolder,"account already added!");
uint userId = (accounts.length + 1001);
Account storage newAccount = balances[msg.sender];
newAccount.isHolder = true;
newAccount.balance = 0;
newAccount.userAddress = msg.sender;
newAccount.userId = userId;
accounts.push(newAccount);
//newAccount.transactions auto initialize to an empty array
}

function deposit() external payable onlyHolders{
balances[msg.sender].balance += msg.value;
uint txId = (balances[msg.sender].transactions.length + 1);
Transaction memory transaction = Transaction(txId,msg.value,block.timestamp,"deposit");
balances[msg.sender].transactions.push(transaction); 
}
function withdraw(uint _amount)external onlyHolders{
    require(balances[msg.sender].balance >= _amount,"Insufficient funds!");
    balances[msg.sender].balance -= _amount;
    uint txId = (balances[msg.sender].transactions.length + 1);
    balances[msg.sender].transactions.push(Transaction(txId,_amount,block.timestamp,"withdraw"));
    (bool callSuccess,)= payable(msg.sender).call{value:_amount}("");
    require(callSuccess,"failed!");

}

function getInterest()external onlyHolders returns(uint){
    Account memory account = balances[msg.sender];
      account.lastInterestTime = block.timestamp;
    // Transaction[] memory tx = account.transactions;
    require(account.lastInterestTime + minimumTime <= block.timestamp,"Error!you don't have any interest to withdraw!");
    uint interest = (account.balance * interestRate / 100);

    balances[msg.sender].balance += interest;
    return interest;

}





}