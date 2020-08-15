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
    
    event personUpdated(address creator, string name, uint age, uint height);
    
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
        
        people[sender].name = name;
        people[sender].age = age;
        people[sender].height = height;
        
        assert(
            people[sender].creator == sender
            && keccak256(abi.encodePacked(people[sender].name)) == keccak256(abi.encodePacked(name)) 
            && people[sender].age == age 
            && people[sender].height == height
        );
        
        emit personUpdated(sender, name, age, height);
    }
    
    function getPerson() public view returns(string memory name, uint age, uint height){
        address creator = msg.sender;
        return (people[creator].name, people[creator].age, people[creator].height);
    }
}