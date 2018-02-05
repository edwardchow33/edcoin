pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';
import 'zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

interface TokenRecipient { function tokenFallback(address _from, uint256 _value, bytes _extraData) public returns (bool); }

contract Finchain is StandardToken, BurnableToken, Ownable {
	string public name;
	string public symbol;
	uint8 public decimals; 
	bool public transfer_enabled = false;
 
  
	function Finchain(uint256 _initalSupply, string _name, string _symbol, uint8 _decimals) public{
		decimals = _decimals;
		totalSupply_  = _initalSupply * (10 ** uint256(decimals));
		name = _name;
		symbol = _symbol;
		balances[msg.sender] = totalSupply_ ;
	}
  
	/**
     * Enables the ability of anyone to transfer their tokens. This can
     * only be called by the token owner. Once enabled, it is not
     * possible to disable transfers.
    */
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
	
	
	/* Transfer and then calls the receiving contract */
	function transferAndCall(address _recipient, uint256 _value, bytes _extraData) external{
		transfer(_recipient, _value);
		//call the tokenFallback function on the contract you want to be notified.
		require(TokenRecipient(_recipient).tokenFallback(msg.sender,_value,_extraData)); 
	}
	
	function burn(uint256 _value) public {
        require(transfer_enabled || msg.sender == owner);
        super.burn(_value);
        Transfer(msg.sender, address(0x0), _value);
    }
	
	function () {
        //if ether is sent to this address, send it back.
        throw;
    }
}