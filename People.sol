pragma solidity 0.5.12;
import './Ownable.sol';

pragma solidity 0.5.12;

contract People is Ownable {

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
    uint internal activePeople;
    
    event personCreated(address creator, uint id, string name, uint age, uint height);
    event personUpdated(address creator, string oldName, string newName, uint oldAge, uint newAge, uint oldHeight, uint newHeight);
    event personDeleted(address creator, uint id);
    
    constructor() public {
        // Create a null person for id==0.   Minimum active id==1
        peopleLookupById.push(Person(msg.sender, 0, 'nobody', 0,0));
    }

    function createPerson(string memory name, uint age, uint height) public returns(uint) {
        address creator = msg.sender;
        
        Person memory person = Person(creator, ++totalPeople, name, age, height);
        peopleLookupById.push(person);
        people[creator] = person;
        
        ++activePeople;
        
        emit personCreated(creator, person.id, person.name, person.age, person.height );
        
        return person.id;
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
    
    function getPerson() public view returns(uint id, string memory name, uint age, uint height) {
        address creator = msg.sender;
        
        require(people[creator].creator == msg.sender, "You have created no person");
        return (people[creator].id, people[creator].name, people[creator].age, people[creator].height);
    }
    
    function getAllPeople() view public onlyOwner returns(uint[] memory peopleIds) {
        uint[] memory ids = new uint[](activePeople);
        uint userCount = 0;
        
        // we start at 1 since the 0 index position is just a null person
        for (uint i=1; i <= totalPeople; i++) {
            if (peopleLookupById[i].creator != address(0)) {
                ids[userCount++] = peopleLookupById[i].id;
            }
        }
        return ids;
    }
    
    function deletePerson(uint id) internal returns(bool) {
        Person memory person = peopleLookupById[id];
        require(person.creator != address(0), "Person does not exist");
        require(msg.sender == owner || person.creator == msg.sender, "Only the original creator can delete this person");
        
        peopleLookupById[id].creator = address(0);
        people[msg.sender].creator = address(0);
        
        --activePeople;
        
        // Find the highest index person that msg.sender has created and remap it to the people mapping
        // This way, getPerson will always return the most recently created person that msg.sender has created
        id = totalPeople;
        while (id > 0) {
            if (peopleLookupById[id].creator == msg.sender) {
                people[msg.sender] = peopleLookupById[id];
                break;
            }
            --id;
        }
        
        emit personDeleted(msg.sender, id);

        return true;
    }
}