pragma solidity >=0.4.0 <0.7.0;

contract JaviCoin {
    string public constant name = "JaviCoin";
    string public constant symbol = "JCN";
    uint8 public constant decimals = 18;  // 18 is the most common number of decimal places
    uint public totalSupply = 0;
    uint public timesMinted = 0;
    address public minter;    //we are instantiating a a value type: address called minter. This address is 0x00000000... right now because there is nothing tied to it.
    uint public mintReward;

    //Here we are adding a map to all addresses. Esentially making a key value pair from an address that interacts with this contract, and pairing it with a balance.
    mapping (address => uint) public balances;

    //events log information into the blockchain
    event sentCoin(address sender, address receiver, uint ammount);

    //a function that calculates how many coins to emit for each time the mint function is called 1000 coins
    // the first 10 calls it gives 1000, and it gives 1/10 after every 10x calls

    function mintamount() private {
        if (timesMinted < 10){
            mintReward = 1000;
        } else if (timesMinted < 100){
            mintReward = 100;
        } else if (timesMinted < 1000){
            mintReward = 10;
        }else{
            mintReward = 1;
        }
        timesMinted += 1;
    }


    //constructors is code that is launched at the creation(deployment) of a contract
    //
    constructor() public {
        minter = msg.sender;
        mintReward = 1000;
        mint();
    }

    //notice only the contract creator can execute it
    function mint() public{
        require(minter == msg.sender, "Only Javier, the creator of this contract, can mint new coins");
        mintamount();
        balances[minter] += mintReward;
        totalSupply += mintReward;
        }


    function transfer(address receiver, uint amount) public returns(bool success){
        require(amount <= balances[msg.sender], "Insufficient balance.");
        balances[receiver] += amount;
        balances[msg.sender] -= amount;
        emit sentCoin(msg.sender, receiver, amount);
        return true;
            }

}
