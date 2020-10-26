pragma solidity ^0.5.9;

import "./ERC20.sol";
import "./ERC20Detailed.sol";
import "./IMineableToken.sol";

contract MineableToken is IMineableToken, ERC20, ERC20Detailed, Ownable {
    using SafeMath for uint256;

    address public  supplyAddress = address(0);
    address private admin;
    uint256 public supplyCap;

    constructor(
        address _owner,
        address _admin,
        address _minter,
        string memory _name,
        string memory _symbol,
        uint8 _decimals)

    public ERC20Detailed(_name, _symbol, _decimals) Ownable(_owner){
        minters[_minter] = _minter;
        admin = _admin;
        supplyCap = 210000 * (10 ** uint256(_decimals));
    }

    mapping(address=>address) public minters;

    function setMinter(address _minter) public {
        require(isMinter(msg.sender) || isOwner());
        minters[_minter] = _minter;
    }

    function removeMinter(address _minter) public {
        require(isMinter(msg.sender) || isOwner());
        delete minters[_minter];
    }

    function isMinter(address _minter) public view returns(bool) {
        return (address(0) != minters[_minter]);
    }

    function mint(address to, uint256 amount) public {
        require(minters[msg.sender] != address(0), "not minter");
        require(to != address(0), "can not mint to addresss 0");

        uint256 currentSupply = totalSupply();
        if(currentSupply.add(amount) > supplyCap) {
            amount = supplyCap.sub(currentSupply);
        }
        _mint(to, amount);
        emit Transfer(supplyAddress, to, amount);
    }

    function setAdmin(address _newAdmin) public onlyOwner {
        admin = _newAdmin;
    }

    function signature() external pure returns (string memory) {
        return "provided by Seal-SC / www.sealsc.com";
    }
}
