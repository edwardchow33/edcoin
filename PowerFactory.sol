pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/StandardToken.sol';
import 'zeppelin-solidity/contracts/token/BurnableToken.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

contract PowerFactory (
	uint 256 public totalSupply;
	uint remaining;
	uint price;
	
	mapping (address => uint) investors;
	
	function token(unit _totalSupply){
		totalSupply = _totalSupply
		remaining = 0;
	}
	
	function() payable{
		assert(remaining < totalSupply);
		uint tokens = msg.value;
		assert(tokens < sub(totalSupply,remaining));
		add(investors[msg.sender],tokens);
		remaining = add(remaining,tokens)
		transfer(msg.sender,tokens)
	}
)