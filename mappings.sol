  
pragma solidity 0.5.12;

contract HelloWorld{

    struct Person {
      uint id;
      string name;
      uint age;
      uint height;
      address creator;
    }

    mapping (address => Person) private people;
    
    event personUpdated(address creator, string oldName, string newName, uint oldAge, uint newAge, uint oldHeight, uint newHeight);
    
    function createPerson(string memory name, uint age, uint height) public {
        Person memory person;
        
        address creator = msg.sender;

        person.creator = creator;
        person.name = name;
        person.age = age;
        person.height = height;
        
        people[msg.sender] = person;
    }
    
    function updatePerson(string memory name, uint age, uint height) public {
        address sender = msg.sender;
        require(people[sender].creator == sender);
        
        string memory oldName = people[sender].name;
        uint oldAge = people[sender].age;
        uint oldHeight = people[sender].height;
        
        people[sender].name = name;
        people[sender].age = age;
        people[sender].height = height;
        
        assert(
            people[sender].creator == sender
            && keccak256(abi.encodePacked(people[sender].name)) == keccak256(abi.encodePacked(name)) 
            && people[sender].age == age 
            && people[sender].height == height
        );
        
        emit personUpdated(sender, oldName, name, oldAge, age, oldHeight, height);
    }
    
    function getPerson() public view returns(string memory name, uint age, uint height){
        address creator = msg.sender;
        return (people[creator].name, people[creator].age, people[creator].height);
    }
}