pragma solidity ^0.4.19;

contract NameChange{
	string name;
	function NameChange(string initialname) public {
		name = initialname;
	}
	function showName() public constant returns(string) {
		return name;
	}	
	function changename(string newname)public { 
		name = newname;
    }
}