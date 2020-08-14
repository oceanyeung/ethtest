pragma solidity 0.5.12;

contract HelloWorld{

    struct Person {
      address creator;
      uint id;
      string name;
      uint age;
      uint height;
    }
    
    Person [] private people;
    mapping (address => uint) private recentIndex;

    function createPerson(string memory name, uint age, uint height) public {
        address creator = msg.sender;

        Person memory newPerson;
        newPerson.creator = creator;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
        
        uint index = people.push(newPerson);
        recentIndex[creator] = index;
    }
    
    function getPerson(uint index) public view returns(address creator, string memory name, uint age, uint height) {
        require(index < people.length);
        Person memory person = people[index];
        return (person.creator, person.name, person.age, person.height);
    }
    
    function getLastAdded() public view returns(uint lastIndex, string memory name, uint age, uint height) {
        uint index = recentIndex[msg.sender] - 1;
        require(index < people.length);
        return (index, people[index].name, people[index].age, people[index].height);
    }

    function getAllPeople() public view returns(uint[] memory addedIndex) {
        address sender = msg.sender;
        uint count = 0;
        uint[] memory indexList = new uint[](people.length);
        
        for (uint i=0; i < people.length; i++) {
            if (people[i].creator == sender) {
                indexList[count] = i;
                count++;
            }
        }
        
        uint[] memory results = new uint[](count);
        for (uint i=0; i < count; i++) {
            results[i] = indexList[i];
        }
        return results;
    }
}