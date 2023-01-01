pragma solidity ^0.8.0;

import "https://github.com/bokkypoobah/BokkyPooBahsDateTimeLibrary/blob/master/contracts/BokkyPooBahsDateTimeLibrary.sol";

contract BirthdayPayout {

    string _name;

    address _owner;

    Teammate[] public _teammates;

    struct Teammate {
        string name;
        address account;
        uint256 salary;
        uint256 birthday;
        uint256 yearVariable; //the year is '0' by default and is changed after we send the present for the first time
    }

    uint256[] _indexes;

    constructor() {
        _name="max";
        _owner = msg.sender;
    }

    function addTeammate(address account,string memory name, uint256 salary,uint256 birthday, uint256 yearVariable) public onlyOwner {
        require(msg.sender != account,"Cannot add oneself");
        Teammate memory newTeammate = Teammate(name,account,salary, birthday, yearVariable); 
        _teammates.push(newTeammate);
        emit NewTeammate(account,name);
    }

    //For a quick check here are some already made teammates. The timestamp needs changing.
    
    // 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,Masha,500000000000000000,1672594403,0
    // 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db,Anna,500000000000000000,948924598,0
    // 0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB,Nastya,500000000000000000,1672594403,0

    function findBirthday() public onlyOwner returns(string memory){
        require(getTeammatesNumber()>0,"No teammates in the database");
        for(uint256 i=0;i<getTeammatesNumber();i++){
            if(checkBirthday(i) == true){
                birthdayPayout( i);    
            }
        }
        return "Good mood"; // As I get it, each function needs to return something. But I couldn`t really understand what this particular one should return. :D
        revert("Noone found");
    }
    
    function birthdayPayout(uint256 index) public onlyOwner {
        sendToTeammate(index);
        emit HappyBirthday(_teammates[index].name,_teammates[index].account);
    }

    function getDate(uint256 timestamp) view public returns(uint256 year, uint256 month, uint256 day){
        (year, month, day) = BokkyPooBahsDateTimeLibrary.timestampToDate(timestamp);
    }

    function checkBirthday(uint256 index) public returns(bool){
        uint256 birthday = getTeammate(index).birthday;
        (, uint256 birthday_month,uint256 birthday_day) = getDate(birthday);
        uint256 today = block.timestamp;
        (uint256 today_year, uint256 today_month,uint256 today_day) = getDate(today); 
        
        // we get the current year, so that we can compare 'yearVariable' with it later to check if we have sent the present this year already or not.

        if(birthday_day == today_day && birthday_month==today_month && _teammates[index].yearVariable != today_year){ 
            _teammates[index].yearVariable = today_year; // here we update the info when the last present was sent
            return true;
        }
        return false;
    }

    function getTeammate(uint256 index) view public returns(Teammate memory){
        return _teammates[index];
    }

    function getTeam() view public returns(Teammate[] memory){
        return  _teammates;
    }

    function getTeammatesNumber() view public returns(uint256){
        return _teammates.length;
    }

    function sendToTeammate(uint256 index) public onlyOwner{
        payable(_teammates[index].account).transfer(_teammates[index].salary);
    }

    function deposit() public payable{

    }

    modifier onlyOwner{
        require(msg.sender == _owner,"Sender should be the owner of contract");
        _;
    }

    event NewTeammate(address account, string name);

    event HappyBirthday(string name, address account);
}
