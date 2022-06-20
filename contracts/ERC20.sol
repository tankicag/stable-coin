// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

contract ERC20 {
    uint256 public totalSupply;
    string public name;
    string public symbol;

    mapping(address => uint256) public balanceOf;
    
    mapping(address => mapping(address => uint256)) public allownce;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(string memory _name, string memory _symbol) public {
        name = _name;
        symbol = _symbol;
    }

    function decimals() external pure returns(uint8){
      return 18;
    }

    function transfer(address recipient, uint256 amount) external returns(bool) {
     return _transfer(msg.sender, recipient, amount);
    }
 
    // function transferFrom
    function transferFrom(address sender, address recipient, uint256 amount) external returns(bool) {
       
      uint256 currentAllowance = allownce[sender][msg.sender];

      require(currentAllowance >= amount, "ERC20: transffer exceed allowance");

      return _transfer(sender, recipient, amount);
    }

    function approve(address spender, uint256 amount) external returns(bool){
      require(spender != address(0), "ERC20: transfer to the zero address");

      allownce[msg.sender][spender] = amount;
      emit Approval(msg.sender, spender, amount);

      return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) private returns(bool) {
       require(recipient != address(0), "ERC20: transfer to the zero address");

      uint256 senderBalance = balanceOf[sender];

      require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
      balanceOf[sender] = senderBalance - amount;
      balanceOf[recipient] += amount;

      emit Transfer(sender, recipient, amount);

      return true;
    }
   
    function _mint(address to, uint256 amount) internal {
      require(to != address(0), "ERC20: mint to the zero address");

      totalSupply += amount;
      balanceOf[to] += amount;

      emit Transfer(address(0), to, amount);
    }

     function _burn(address from, uint256 amount) internal {
      require(from != address(0), "ERC20: burn to the zero address");

      totalSupply -= amount;
      balanceOf[from] -= amount;

      emit Transfer(from, address(0), amount);
    }
}
