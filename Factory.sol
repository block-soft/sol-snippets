pragma solidity ^0.4.13;


// MyFactory with MyObject

contract MyObject {

    address public owner;

    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }

    function changeOwner(address _newOwner) onlyOwner {
        owner = _newOwner;
    }

    string public name;

    MyObject public parentObject;

    MyFactory public objectsFactory;

    function MyObject(address _objectsFactory, address _parentObject, string _name) {
        objectsFactory = MyFactory(_objectsFactory);
        parentObject = MyObject(_parentObject);
        name = _name;
        owner = msg.sender;
    }

    function createClone(string _cloneName) returns (address) {
        MyObject cloneObject = objectsFactory.createClone(this, _cloneName);
        cloneObject.changeOwner(msg.sender);
        NewCloneObject(address(cloneObject));
        return address(cloneObject);
    }

    event NewCloneObject(address indexed _cloneObject);
}


contract MyFactory {

    function createClone(address _parentToken, string _tokenName) returns (MyObject) {
        MyObject newObject = new MyObject(this, _parentToken, _tokenName);
        newObject.changeOwner(msg.sender);
        return newObject;
    }
}
