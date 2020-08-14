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

    function createPerson(string memory name, uint age, uint height) public {
        address creator = msg.sender;

        Person memory newPerson;
        newPerson.creator = creator;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
        
        people.push(newPerson);

    }
    function getPerson(uint index) public view returns(string memory name, uint age, uint height){
        assert(index < people.length);
        return (people[index].name, people[index].age, people[index].height);
    }
}