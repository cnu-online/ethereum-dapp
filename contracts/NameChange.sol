pragma solidity ^0.4.17;

contract NameChange {

    string name;
    function NameChange(string n) public {        
        name = n;
    }
    function showName() public constant returns(string) {
        return name;
    }
    function changename(string n) public {
        name = n;
    }
}