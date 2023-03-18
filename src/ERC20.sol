//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./IERC20.sol";
import "./EIP712.sol";

contract ERC20 is IERC20, EIP712 {
    mapping(address => uint256) private _balances;
    mapping(address => uint256) private _nonces;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    bool private _paused;

    address private _owner;




    address internal constant alice = address(1);
    address internal constant bob = address(2);

    
    
    

    modifier onlyOwenr(){
          require(msg.sender == _owner);
         _;
    }

    constructor(string memory name_, string memory symbol_) 
        EIP712(name_, "1.0") 
    {
        _name = name_;
        _symbol = symbol_;
        _totalSupply = 40000 * 10 ** 18;

        _balances[msg.sender] = 20000 * 10 ** 18;
        _balances[alice] = 20000 * 10 ** 18;

        _paused = false;

        _owner = msg.sender;
    }


    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return 18;
    }


    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(_balances[msg.sender] >= amount);
        require(_paused == false);

        _balances[msg.sender] = _balances[msg.sender] - amount;
        _balances[to] = _balances[to] + amount;          // Integer Overflow 가능?

        return true;
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        require(_balances[msg.sender] >= amount);

        _allowances[msg.sender][spender] = amount;

        return true;
    }
    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(_allowances[from][to] >= amount);
        require(_balances[from] >= amount);

        
        _allowances[from][to] = _allowances[from][to] - amount;
        
        _balances[from] = _balances[from] - amount;
        _balances[to] = _balances[to] + amount;


        
    }


    function pause() public onlyOwenr returns (bool) {
        _paused = true;

        // emit Paused(_msgSender());
        return true;
    }

    receive() external payable {

    }



    function nonces(address _addr) public returns (uint) {
        return _nonces[_addr];
    }

    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {
        // [1] 유효기간에 대한 검증
        require(block.timestamp <= deadline, "ERC20Permit: expired deadline");

        // [2] 서명에 대한검증
        bytes32 structHash = _toStructHash(owner, spender, value, _nonces[owner], deadline);
        require(ecrecover(_toTypedDataHash(structHash), v, r, s) == owner, "INVALID_SIGNER");

        _allowances[owner][spender] = value;
        _nonces[owner]++;

    }







}