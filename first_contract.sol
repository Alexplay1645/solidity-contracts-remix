// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

// 1. Counter Contract
contract Counter {

    int256 private counter;

    function increment() public {
        counter += 1;
    }

    function decrement() public {
        counter -= 1;
    }

    function getCounter() public view returns (int256) {
        return counter;
    }
}

// 2. Task Manager Contract
contract TaskManager {

    string[] private tasks;

    function addTask(string memory _task) public {
        tasks.push(_task);
    }

    function deleteTask(uint index) public {
        require(index < tasks.length, "Invalid index");

        tasks[index] = tasks[tasks.length - 1];
        tasks.pop();
    }

    function getTasks() public view returns (string[] memory) {
        return tasks;
    }
}

// 3. Product Store Contract
contract ProductStore {

    struct Product {
        string name;
        uint price;
    }

    Product[] public products;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function addProduct(string memory _name, uint _price) public {
        require(msg.sender == owner, "Only owner");

        products.push(Product(_name, _price));
    }

    function buyProduct(uint index) public payable {
        require(index < products.length, "Invalid product");

        Product memory product = products[index];

        require(msg.value >= product.price, "Not enough ETH");

        payable(owner).transfer(msg.value);
    }

    function getProducts() public view returns (Product[] memory) {
        return products;
    }
}


// 4. Voting System
contract VotingSystem {

    struct Candidate {
        string name;
        uint voteCount;
    }

    Candidate[] public candidates;
    mapping(address => bool) public hasVoted;

    function addCandidate(string memory _name) public {
        candidates.push(Candidate(_name, 0));
    }

    function vote(uint index) public {
        require(!hasVoted[msg.sender], "Already voted");
        require(index < candidates.length, "Invalid candidate");

        candidates[index].voteCount += 1;
        hasVoted[msg.sender] = true;
    }

    function getCandidates() public view returns (Candidate[] memory) {
        return candidates;
    }
}

// 5. Subscription System
contract SubscriptionSystem {

    address public owner;
    uint public subscriptionPrice = 0.01 ether;
    uint public subscriptionPeriod = 30 days;

    mapping(address => uint) public subscriptionEnd;

    constructor() {
        owner = msg.sender;
    }

    function subscribe() public payable {
        require(msg.value >= subscriptionPrice, "Not enough ETH");

        subscriptionEnd[msg.sender] =
            block.timestamp + subscriptionPeriod;
    }

    function isSubscribed(address user)
        public
        view
        returns (bool)
    {
        return subscriptionEnd[user] > block.timestamp;
    }

    function changePrice(uint newPrice) public {
        require(msg.sender == owner, "Only owner");

        subscriptionPrice = newPrice;
    }
}

// 6. Project Funding Voting
contract ProjectFunding {

    struct Project {
        string description;
        uint requiredAmount;
        uint votes;
        bool funded;
    }

    Project[] public projects;
    mapping(address => mapping(uint => bool)) public hasVoted;

    function proposeProject(
        string memory _description,
        uint _amount
    ) public {
        projects.push(
            Project(_description, _amount, 0, false)
        );
    }

    function voteProject(uint index) public {
        require(index < projects.length, "Invalid project");
        require(
            !hasVoted[msg.sender][index],
            "Already voted"
        );

        projects[index].votes += 1;
        hasVoted[msg.sender][index] = true;
    }

    function fundProject(uint index) public payable {
        Project storage project = projects[index];

        require(!project.funded, "Already funded");
        require(
            msg.value >= project.requiredAmount,
            "Not enough funds"
        );

        project.funded = true;
    }

    function getProjects()
        public
        view
        returns (Project[] memory)
    {
        return projects;
    }
}