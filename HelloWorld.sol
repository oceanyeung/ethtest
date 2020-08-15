pragma solidity 0.5.12;
import './Destroyable.sol';
import './Ownable.sol';
import './HasCost.sol';

contract HelloWorld is Ownable, Destroyable, hasCost {

    struct Person {
      uint id;
      string name;
      uint age;
      uint height;
      address creator;
    }
    
    // Doubly linked list to track all the address that has created a person

    mapping (address => Person) private people;
    address[] creators;
    uint creatorsCount;
    
    uint public balance;
    
    event personUpdated(address creator, string name, uint age, uint height);

    function createPerson(string memory name, uint age, uint height) public payable costs(1 ether){
        Person memory person;
        
        balance += msg.value;
        
        address creator = msg.sender;

        person.creator = creator;
        person.name = name;
        person.age = age;
        person.height = height;

        if (people[msg.sender].creator != msg.sender) {
            // record does not exist in people yet, so can increase count
            creators.push(creator);
            creatorsCount++;
        }
        person.id = creatorsCount;
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
    
    function getAllPeople() view public onlyOwner returns(uint[] memory peopleIds) {
        uint[] memory ids = new uint[](creatorsCount);
        for (uint32 i=0; i < creatorsCount; i++) {
            ids[i] = people[creators[i]].id;
        }
        return ids;
    }
    
    function withdrawAll() public onlyOwner returns(uint) {
        uint toTransfer = balance;
        balance = 0;
        msg.sender.transfer(toTransfer);
        return toTransfer;
    }
}
