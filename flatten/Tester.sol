pragma solidity ^0.4.21;

contract Tester {
  uint256 public price;
  
  function setUint256(uint256 x) public {
    price = x;
  }
  
  function setBytes(bytes b) public {
    uint256 k = uint256(convertBytesToBytes32(b));
    price = k;
  }
  
  function getPrice() returns (uint256) {
    return price;
  }
  
  function convertBytesToBytes32(bytes inBytes) public returns (bytes32 out) {
    if (inBytes.length == 0) {
      return 0x0;
    }
    
    assembly {
      out := mload(add(inBytes, 32))
    }
  }
}
