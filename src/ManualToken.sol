// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

contract ManualToken {
    mapping (address wallet => uint balance) private s_balances;
    
    function name() public pure  returns (string memory) {
        return "Manaul Token";
    }
    
    function totalSupply() public pure returns (uint256) {
        return 100 ether;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function balanceOf(address _owner)  public view returns (uint256) {
        return s_balances[_owner];
    }  

    function transfer(address _to, uint256 _amount) public returns (uint256) {
        uint256 previousBalance = s_balances[msg.sender] + s_balances[_to];

        s_balances[msg.sender] -= _amount;
        s_balances[_to] += _amount;

        require(s_balances[msg.sender] + s_balances[_to] == previousBalance);
        return s_balances[_to];
    }
}