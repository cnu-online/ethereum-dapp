pragma solidity ^0.4.17;

contract NameChange {

    string name;
    function NameChange(string n) {
        name=n;
    }
    function ShowName() public constant returns(string) {
        return name;
    }
    function Changename(string n) public {
        name=n;
    }
}