// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;


contract Transaction {

    uint256 public maxTransferAmount = 100 ether;

    event EtherTransferred(address from, address to, uint256 amount, string category);



    function setMaxTransferAmount(uint256 _maxTransferAmount) external {
        
        maxTransferAmount = _maxTransferAmount;
    }

    function transferEther(address payable  to, string memory category) external payable  {
        uint amount = msg.value;
        require(amount <= maxTransferAmount, "You have exceeded the maximum transfer amount");
        require(msg.sender.balance >= amount, "You don't have enough balance");

        // Transfer Ether
        (bool success, ) = to.call{value: amount}("");
        require(success, "Ether transfer failed");

        emit EtherTransferred(msg.sender, to, amount, category);
  }
}
