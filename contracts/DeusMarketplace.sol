pragma solidity 0.4.21;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol";
import "zeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol";

contract DeusMarketplace is Ownable, ERC721Receiver {
  address public owner;
  address public wallet;
  uint256 public fee_percentage;
  ERC721Basic public token;
  
  mapping(uint256 => uint256) public priceList;
  mapping(uint256 => address) public holderList;
  
  event Stored(uint256 indexed id, uint256 price, address seller);
  event Cancelled(uint256 indexed id, address seller);
  event Sold(uint256 indexed id, uint256 price, address seller, address buyer);
  
  event TokenChanged(address old_token, address new_token);
  event WalletChanged(address old_wallet, address new_wallet);
  event FeeChanged(uint256 old_fee, uint256 new_fee);
  
  function DeusMarketplace(address _token, address _wallet) public {
    owner = msg.sender;
    token = ERC721Basic(_token);
    wallet = _wallet;
    fee_percentage = 10;
  }
  
  function setToken(address _token) public onlyOwner {
    address old = token;
    token = ERC721Basic(_token);
    emit TokenChanged(old, token);
  }
  
  function setWallet(address _wallet) public onlyOwner {
    address old = wallet;
    wallet = _wallet;
    emit WalletChanged(old, wallet);
  }
  
  function changeFeePercentage(uint256 _percentage) public onlyOwner {
    uint256 old = fee_percentage;
    fee_percentage = _percentage;
    emit FeeChanged(old, fee_percentage);
  }
  
  function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4) {
    require(msg.sender == address(token));
    
    uint256 _price = uint256(convertBytesToBytes32(_data));
    
    require(_price > 0);
    
    priceList[_tokenId] = _price;
    holderList[_tokenId] = _from;
  
    emit Stored(_tokenId, _price, _from);
    
    return ERC721Receiver.ERC721_RECEIVED;
  }
  
  function cancel(uint256 _id) public returns (bool) {
    require(holderList[_id] == msg.sender);
    
    holderList[_id] = 0x0;
    priceList[_id] = 0;
    
    token.safeTransferFrom(this, msg.sender, _id);
  
    emit Cancelled(_id, msg.sender);
    
    return true;
  }
  
  function buy(uint256 _id) public payable returns (bool) {
    require(priceList[_id] == msg.value);
    
    address oldHolder = holderList[_id];
    uint256 price = priceList[_id];
    
    uint256 toWallet = price / 100 * fee_percentage;
    uint256 toHolder = price - toWallet;
    
    holderList[_id] = 0x0;
    priceList[_id] = 0;
    
    token.safeTransferFrom(this, msg.sender, _id);
    wallet.transfer(toWallet);
    oldHolder.transfer(toHolder);
    
    emit Sold(_id, price, oldHolder, msg.sender);
    
    return true;
  }
  
  function getPrice(uint _id) public view returns(uint256) {
    return priceList[_id];
  }
  
  function convertBytesToBytes32(bytes inBytes) internal returns (bytes32 out) {
    if (inBytes.length == 0) {
      return 0x0;
    }
    
    assembly {
      out := mload(add(inBytes, 32))
    }
  }
}
