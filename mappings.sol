pragma solidity 0.5.12;

contract HelloWorld{

    struct Person {
      address creator;
      uint id;
      string name;
      uint age;
      uint height;
    }
    
    address owner;

    mapping (address => Person) internal people;
    Person[] internal peopleLookupById;
    uint internal totalPeople;
    
    event personCreated(address creator, uint id, string name, uint age, uint height);
    event personUpdated(address creator, string oldName, string newName, uint oldAge, uint newAge, uint oldHeight, uint newHeight);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    constructor() public {
        owner = msg.sender;
    }
    
    function createPerson(string memory name, uint age, uint height) public {
        address creator = msg.sender;

        Person memory person = Person(creator, ++totalPeople, name, age, height);
        peopleLookupById.push(person);
        people[creator] = person;
        
        emit personCreated(creator, person.id, person.name, person.age, person.height );
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
    
    function getAllPeople() view public onlyOwner returns(uint[] memory peopleIds) {
        uint[] memory ids = new uint[](totalPeople);
        for (uint32 i=0; i < totalPeople; i++) {
            ids[i] = peopleLookupById[i].id;
        }
        return ids;
    }
}