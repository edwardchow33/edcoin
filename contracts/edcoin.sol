pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';
import 'zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

interface TokenRecipient { function tokenFallback(address _from, uint256 _value, bytes _extraData) public returns (bool); }

contract EdCoin is StandardToken, BurnableToken, Ownable {
  string public name = "Ed coin";
  string public symbol = "EDC";
  uint8 public constant decimals = 18;
  bool public transfer_enabled = false;
  uint256 public constant INITIAL_SUPPLY = 1000000000  * (10 ** uint256(decimals));
 
  
  function EdCoin() public{
	totalSupply_  = INITIAL_SUPPLY;
    balances[msg.sender] = totalSupply_ ;
	}
  
  
  function enableTransfer() external onlyOwner {
	transfer_enabled = true;
  }
  
  modifier onlyWhenTransferEnabled() {
		if(!transfer_enabled){
			require(msg.sender == owner);
		}
        _;
    }
  
  function transfer(address _to, uint256 _value) public onlyWhenTransferEnabled returns (bool) {
        return super.transfer(_to, _value);
    }
	
	function transferFrom(address _from, address _to, uint256 _value) public onlyWhenTransferEnabled returns (bool) {
        bool result = super.transferFrom(_from, _to, _value);
	
        return result;
    }
	
	function transferAndCall(address _recipient, uint256 _value, bytes _extraData) external{
		transfer(_recipient, _value);
		require(TokenRecipient(_recipient).tokenFallback(msg.sender,_value,_extraData)); 
		
	}
	
	function burn(uint256 _value) public {
        require(transfer_enabled || msg.sender == owner);
        super.burn(_value);
        Transfer(msg.sender, address(0x0), _value);
    }
}