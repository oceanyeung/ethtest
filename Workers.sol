pragma solidity 0.5.12;

import './People.sol';

contract Workers is People {
    struct Payroll {
        address boss;
        address payoutAddress;
        uint salary;
    }
    
    mapping (uint => Payroll) payrolls;  // people ID => Payroll

    event workerCreated(address creator, uint id, string name, uint age, uint height, address payoutAddress, uint salary);
    event workerFired(address creator, uint id);

    function createWorker(string memory name, uint age, uint height, address payoutAddress, uint salary) public {
        require(age <= 75, "Age cannot be above 75");
        require(payoutAddress != address(0), "Invalid payout address");
        require(msg.sender != payoutAddress, "You cannot payout to yourself");
        require(salary > 0, "Salary should be higher than zero");

        uint id = createPerson(name, age, height);
        Payroll memory payroll = Payroll(msg.sender, payoutAddress, salary);
        payrolls[id] = payroll;
        
        emit workerCreated(msg.sender, id, name, age, height, payoutAddress, salary);
    }
    
    function fireWorker(uint id) public {
        Payroll memory employeeRecord = payrolls[id];
        require(employeeRecord.boss != address(0), "Worker does not exist");
        require(msg.sender == owner || msg.sender == employeeRecord.boss, "You can only fire an employee that you manage");
        
        employeeRecord.boss = address(0);
        payrolls[id] = employeeRecord;
        
        bool deleted = deletePerson(id);
        
        assert(deleted);
        assert(payrolls[id].boss == address(0));
        
        emit workerFired(msg.sender, id);
    }
}