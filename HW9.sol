pragma solidity ^0.8.17;

library StringComparer{
    function compare(string memory str1, string memory str2) public pure returns (bool) {
        return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
    }
}

abstract contract Animal{

    function eat(string memory food) view virtual public returns(string memory){
        return string.concat("Animal eats ",food);
    }

    function speak() view virtual public returns(string memory){
        return "...";
    }
}

abstract contract Omnivore is Animal{
    string[] meal = ["meat", "plant"];

    function eat(string memory food) view virtual override public returns(string memory){
        for(uint256 i=0; i < meal.length; i++){
            if(StringComparer.compare(food,meal[i])){
                return super.eat(food);
            }
        }
        revert("I don`t eat any of that!");
    }
}

abstract contract Carnivore is Animal{
    string constant MEAL="meat";

    modifier eatOnlyMeat(string memory food){
        require(StringComparer.compare(food,MEAL),string.concat("Disgusting! Self-respecting Carnivore doesn`t eat ",food));
        _;
    }

    function eat(string memory food) view virtual override public eatOnlyMeat(food) returns(string memory){
        return super.eat(food);
    }
}

contract Wolf is Carnivore{

    function speak() view override public returns(string memory){
        return "Awoo";
    }
}

contract Dog is Omnivore{
    string constant POISON = "chocolate";
    function eat(string memory food) view override public returns(string memory){
        require(!StringComparer.compare(food,POISON), string.concat(food, " is dangerous!"));
        return super.eat(food);
    }

    function speak() view override public returns(string memory){
        return "Woof";
    }
}
