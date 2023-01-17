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

contract Wolf is Animal{

    string constant MEAL = "meat";

    function eat(string memory food) view override public returns(string memory){
        require(StringComparer.compare(food,MEAL), string.concat("Disgusting! Self-respecting wolf doesn`t eat ",food));
        return super.eat(food);
    }

    function speak() view override public returns(string memory){
        return "Awoo";
    }
}

contract Dog is Animal{
    string[] meal = ["meat", "plant"];
    string constant POISON = "chocolate";

    function eat(string memory food) view override public returns(string memory){
        require(!StringComparer.compare(food,POISON), string.concat("ugh! That`s dangerous!"));
        for(uint256 i=0; i < meal.length; i++){
            if(StringComparer.compare(food,meal[i])){
                return super.eat(food);
            }
        }
        revert("Can you give me something more delicious?");
    }

    function speak() view override public returns(string memory){
        return "Woof";
    }
}
