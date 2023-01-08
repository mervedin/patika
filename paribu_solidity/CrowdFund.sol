// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract CrowdFund {

    event Launch(uint amount, address indexed creator, uint goal, uint32 startAt, uint32 endAt);
    event Cancel(uint id);
    event Pledge(uint id, address indexed caller, uint amount);
    event Unpledge(uint id, address indexed caller, uint amount);
    event Claim(uint id);
    event Refund(uint id, address indexed caller, uint amount);

    IERC20 public immutable token;
    //  campaign id
    uint public count;
    // campaign mappaing
    mapping(uint => Campaign) public campaigns;
    // track the amount an address pledged for a campaign
    mapping(uint => mapping(address => uint)) public pledgedAmount;

    constructor(address _token){
        token = IERC20(_token);
    }

    struct Campaign {
        address  creator;
        uint goal;
        uint pledged;
        uint32 startAt;
        uint32 endAt;
        bool claimed;
    }

    
    function launch(uint  _goal, uint32 _startAt, uint32 _endAt) external {
        require(_startAt >= block.timestamp, "start at < now");
        require(_endAt >= _startAt, "end at < start at");
        require(_endAt <= _startAt + 90 days, "end at > max duration");

        count += 1;
        campaigns[count] = Campaign({
            creator: msg.sender,
            goal: _goal,
            pledged: 0,
            startAt: _startAt,
            endAt: _endAt,
            claimed: false
        });

        emit Launch(count, msg.sender, _goal, _startAt, _endAt);
    }

    function cancel(uint _id) external {
        Campaign memory campaign = campaigns[_id];
        require(msg.sender == campaign.creator, "not creator");
        require(campaign.startAt < block.timestamp, "started");

        delete campaigns[_id];
        emit Cancel(_id);
    }

    function pledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(campaign.startAt >= block.timestamp, "not started");
        require(campaign.endAt <= block.timestamp, "ended");

        token.transferFrom(msg.sender, address(this), _amount);
        campaign.pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;

        emit Pledge(_id, msg.sender, _amount);
    }

    function unpledge(uint _id, uint _amount) external{
        Campaign storage campaign = campaigns[_id];
        require(campaign.endAt <= block.timestamp, "ended");
        require(_amount <= pledgedAmount[_id][msg.sender], "amount > your pledge amount");

        token.transfer(msg.sender, _amount);
        pledgedAmount[_id][msg.sender] -= _amount;
        campaign.pledged -= _amount;

        emit Unpledge(_id, msg.sender, _amount);
    }

    function claim(uint _id) external {
        Campaign storage campaign = campaigns[_id]; 
        require(campaign.creator == msg.sender, "not the creator");
        require(campaign.endAt > block.timestamp, "not ended");
        require(campaign.pledged >= campaign.goal, "pleged < goal");
        require(campaign.claimed, "claimed before");

        token.transfer(msg.sender, campaign.pledged);
        campaign.claimed = true;

        emit Claim(_id);
    }

    function refund(uint _id) external {
        Campaign memory campaign = campaigns[_id]; 
        require(campaign.endAt > block.timestamp, "not ended");
        require(campaign.pledged < campaign.goal, "pleged >= goal");

        uint bal = pledgedAmount[_id][msg.sender];
        token.transfer(msg.sender, bal);
        pledgedAmount[_id][msg.sender] = 0;

        emit Refund(_id, msg.sender, bal);
    }

}