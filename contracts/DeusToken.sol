pragma solidity 0.4.21;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

contract DeusToken is Ownable, ERC721Token {
  function DeusToken() public ERC721Token("DeusETH Token", "DEUS") {
  }
  
  function safeTransferFromWithData(address from, address to, uint256 tokenId, bytes data) public {
    return super.safeTransferFrom(from, to, tokenId, data);
  }
  
  function mint(address _to, uint256 _tokenId) public onlyOwner {
    super._mint(_to, _tokenId);
  }
  
  function burn(address _owner, uint256 _tokenId) public onlyOwner {
    super._burn(_owner, _tokenId);
  }
  
  function setTokenURI(uint256 _tokenId, string _uri) public onlyOwner {
    super._setTokenURI(_tokenId, _uri);
  }
}