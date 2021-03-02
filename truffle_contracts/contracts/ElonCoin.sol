// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

/**
 * @dev Interface of the BEP20 standard as defined in the EIP.
 */
interface IBEP20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b)
        internal
        pure
        returns (bool, uint256)
    {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

contract BEP20 is Context, IBEP20 {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) public {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {BEP20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IBEP20-balanceOf} and {IBEP20-transfer}.
     */
    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IBEP20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IBEP20-balanceOf}.
     */
    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[account];
    }

    /**
     * @dev See {IBEP20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IBEP20-allowance}.
     */
    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IBEP20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IBEP20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {BEP20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "BEP20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IBEP20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IBEP20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "BEP20: decreased allowance below zero"
            )
        );
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(
            amount,
            "BEP20: transfer amount exceeds balance"
        );
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "BEP20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "BEP20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(
            amount,
            "BEP20: burn amount exceeds balance"
        );
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal virtual {
        _decimals = decimals_;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

abstract contract BEP20Burnable is Context, BEP20 {
    using SafeMath for uint256;

    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {BEP20-_burn}.
     */
    function burn(uint256 amount) public virtual {
        _burn(_msgSender(), amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     *
     * See {BEP20-_burn} and {BEP20-allowance}.
     *
     * Requirements:
     *
     * - the caller must have allowance for ``accounts``'s tokens of at least
     * `amount`.
     */
    function burnFrom(address account, uint256 amount) public virtual {
        uint256 decreasedAllowance =
            allowance(account, _msgSender()).sub(
                amount,
                "BEP20: burn amount exceeds allowance"
            );

        _approve(account, _msgSender(), decreasedAllowance);
        _burn(account, amount);
    }
}

abstract contract BEP20Capped is BEP20 {
    using SafeMath for uint256;

    uint256 private _cap;

    /**
     * @dev Sets the value of the `cap`. This value is immutable, it can only be
     * set once during construction.
     */
    constructor(uint256 cap_) internal {
        require(cap_ > 0, "BEP20Capped: cap is 0");
        _cap = cap_;
    }

    /**
     * @dev Returns the cap on the token's total supply.
     */
    function cap() public view virtual returns (uint256) {
        return _cap;
    }

    /**
     * @dev See {BEP20-_beforeTokenTransfer}.
     *
     * Requirements:
     *
     * - minted tokens must not cause the total supply to go over the cap.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);

        if (from == address(0)) {
            // When minting tokens
            require(
                totalSupply().add(amount) <= cap(),
                "BEP20Capped: cap exceeded"
            );
        }
    }
}

interface IBEP20Extended {
    function decimals() external view returns (uint8);
}

contract ElonCoin is Ownable, BEP20, BEP20Burnable, BEP20Capped {
    using SafeMath for uint256;

    /**
     **-------------------------------
     **    PRESALE VARIABLES/FUNCTIONS
     **-------------------------------
     */

    // The token being received
    IBEP20 public tokenBUSD;

    // Address where busd are sent to
    address public wallet;

    // How many token a buyer gets per 4 busd.
    // The rate is the conversion between busd and the smallest and indivisible token unit.
    // So, if you are using a rate of 10**18 with an BEP20 token with 18 decimals called TOK
    // 4 busd will give you 1000000000000000000 unit, or 1 TOK.
    uint256 public rate;

    // Amount of busd raised
    uint256 public busdRaised;

    // Presale is still ongoing
    uint256 public presaleStarts = 1614801600; // Timestamp for 3/3/2021- 21:0:0 GMT+1
    uint256 public presaleEnds = presaleStarts.add(60 days); // 2 months

    uint256 public presaleCap; //amount of BUSD to raise == 80000 == 80000/4 = 20000 tokens

    // investor minimum contributions, an investor can't have less than 4usdt in his contribution
    uint256 public investorMinCap; // 4 busd

    // Track investor contributions
    mapping(address => uint256) public contributions;

    //last dividend pool
    mapping(address => uint256) public userLastDividened;

    // total token in dividen pool
    uint256 public totalDividend;

    // -----------------------------------------
    // PRESALE MODIFIER
    // -----------------------------------------

    modifier presaleOngoing() {
        require(
            presaleStarts < block.timestamp && presaleEnds > block.timestamp,
            "Presale has Ended"
        );
        _;
    }
    modifier presaleEnded() {
        require(presaleEnds < block.timestamp, "Presale is ongoing");
        _;
    }
    // Modifier to determine user is a holder
    modifier onlyHolder() {
        require(balanceOf(msg.sender) > 0, "Not a holder");
        _;
    }
    // Modifier to determine user is an investor
    modifier onlyInvestor() {
        require(contributions[msg.sender] > 0, "Not an investor");
        _;
    }
    // modifier to determine if cap(goal) is reached
    modifier goalReached() {
        require(busdRaised >= presaleCap);
        _;
    }
    // -----------------------------------------
    // Presale EVENT
    // -----------------------------------------

    /**
     * Event for token purchase logging
     * @param purchaser who paid for the tokens
     * @param beneficiary who got the tokens
     * @param value busd paid for purchase
     * @param amount amount of tokens purchased
     */
    event TokenPurchase(
        address indexed purchaser,
        address indexed beneficiary,
        uint256 value,
        uint256 amount
    );

    //DIVIDEND EVENT
    /**
     * Event for claiming dividends
     * @param _customer who claimed the tokens
     * @param amount amount of tokens claimed
     */
    event ClaimedDividend(address _customer, uint256 amount);

    //--------------------------------------------
    //  TOKENOMICS
    //--------------------------------------------

    // 3% is being shared to holders
    uint256 internal constant dividendFee_ = 3;

    //0.0001% is being burnt,, solidity doesn't support decimals, amount/1000000 == 0.0001%
    uint256 internal constant burntFee_ = 1000000;

    // number of tokens to send to the presale contract, should be 20% of maxSupply
    uint256 presaleTokens;

    // Number of tokens sold
    uint256 public tokenSold;

    //---------------------------
    // OVERIDDEN FUNCTIONS
    //---------------------------

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override(BEP20, BEP20Capped) {
        super._beforeTokenTransfer(from, to, amount);
    }

    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {BEP20-_burn}.
     */
    function burn(uint256 amount) public virtual override {
        if (
            (block.timestamp >= presaleStarts &&
                block.timestamp <= presaleEnds) || _msgSender() == owner()
        ) {
            //NO CHARGES DURING PRESALE AND FOR OWNER
            super.burn(amount);
        } else {
            uint256 _dividendFee = amount.div(100).mul(dividendFee_);
            totalDividend = totalDividend.add(_dividendFee);
            _transfer(msg.sender, address(this), _dividendFee);
            amount = amount.sub(_dividendFee);
            super.burn(amount);
        }
    }

    //Extend parent to charge fee
    function burnFrom(address account, uint256 amount) public virtual override {
        //Override main burnFrom cause we need to get a transaction fee
        if (
            (block.timestamp >= presaleStarts &&
                block.timestamp <= presaleEnds) || account == owner()
        ) {
            //NO CHARGES DURING PRESALE AND FOR OWNER
            super.burnFrom(account, amount);
        } else {
            uint256 decreasedAllowance =
                allowance(account, _msgSender()).sub(
                    amount,
                    "BEP20: burn amount exceeds allowance"
                );

            _approve(account, _msgSender(), decreasedAllowance);
            uint256 _dividendFee = amount.div(100).mul(dividendFee_);
            totalDividend = totalDividend.add(_dividendFee);
            _transfer(account, address(this), _dividendFee);
            _burn(account, amount.sub(_dividendFee));
        }
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * Extends parent transfer
     */
    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        if (
            (block.timestamp >= presaleStarts &&
                block.timestamp <= presaleEnds) || _msgSender() == owner()
        ) {
            //NO CHARGES DURING PRESALE AND FOR OWNER
            super.transfer(recipient, amount);
        } else {
            uint256 _dividendFee = amount.div(100).mul(dividendFee_);
            _transfer(msg.sender, address(this), _dividendFee);

            totalDividend = totalDividend.add(_dividendFee);

            uint256 _burntFee = amount.div(burntFee_);
            _burn(msg.sender, _burntFee);

            amount = amount.sub(_dividendFee).sub(_burntFee);
            super.transfer(recipient, amount);
        }
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        if (
            (block.timestamp >= presaleStarts &&
                block.timestamp <= presaleEnds) || sender == owner()
        ) {
            //NO CHARGES DURING PRESALE AND FOR OWNER
            super.transferFrom(sender, recipient, amount);
        } else {
            uint256 _dividendFee = amount.div(100).mul(dividendFee_);
            _transfer(sender, address(this), _dividendFee);
            totalDividend = totalDividend.add(_dividendFee);
            uint256 _burntFee = amount.div(burntFee_);
            _burn(sender, _burntFee);
            uint256 amountToSend = amount.sub(_dividendFee).sub(_burntFee);
            _transfer(sender, recipient, amountToSend);
            _approve(
                sender,
                _msgSender(),
                allowance(sender, _msgSender()).sub(
                    amount,
                    "BEP20: transfer amount exceeds allowance"
                )
            );
        }

        return true;
    }

    function mint(uint256 amount) public onlyOwner {
        _mint(msg.sender, amount);
    }

    constructor(address _tokenBUSD, uint8 decimal_)
        public
        BEP20("ElonCoin", "ELON")
        BEP20Capped(100000 * (10**uint256(decimal_)))
    {
        require(_tokenBUSD != address(0), "Zero address");
        _setupDecimals(decimal_);
        transferOwnership(0x9Ee6aa72C37FcE5BaB28b983c7F3f152032e7a3e);

        wallet = msg.sender;
        tokenBUSD = IBEP20(_tokenBUSD);

        presaleCap =
            80000 *
            (10**uint256(IBEP20Extended(_tokenBUSD).decimals()));
        investorMinCap =
            4 *
            (10**uint256(IBEP20Extended(_tokenBUSD).decimals()));
        rate = 10**uint256(decimal_); //4busd == 1TOKEN

        presaleTokens = cap().div(100).mul(20); //or compute the value from cap
        _mint(address(this), presaleTokens);

        // mint the 80% to owner wallet
        uint256 remainingSupply = cap().div(100).mul(80); //or compute the value from cap
        _mint(owner(), remainingSupply);
    }

    //// -----------------------------------------
    // Crowdsale Public interface
    // -----------------------------------------

    /**
     * @dev Returns the amount contributed so far by a sepecific user.
     * @param _beneficiary Address of contributor
     * @return User contribution so far
     */
    function getUserContribution(address _beneficiary)
        public
        view
        returns (uint256)
    {
        return contributions[_beneficiary];
    }

    /**
    Function that returns amount of token left to be sold
     */
    function tokensLeft() public view returns (uint256) {
        return presaleTokens.sub(tokenSold);
    }

    /**
     * @dev low level token purchase ***DO NOT OVERRIDE***
     * @param _beneficiary Address performing the token purchase
     */
    function buyTokens(address _beneficiary, uint256 _busdAmount)
        public
        presaleOngoing
    {
        require(_beneficiary != address(0), "Zero Address");
        require(busdRaised.add(_busdAmount) <= presaleCap, "Cap exceeded");

        uint256 _existingContribution = contributions[_beneficiary];
        uint256 _newContribution = _existingContribution.add(_busdAmount);
        require(
            _newContribution >= investorMinCap,
            "User must have at least 4BUSD contribution to be able to buy lower"
        );
        contributions[_beneficiary] = _newContribution;

        // calculate token amount to be created
        uint256 tokens = busdToToken(_busdAmount);

        // update state
        busdRaised = busdRaised.add(_busdAmount);

        //Send tokens to buyer
        _transfer(address(this), _beneficiary, tokens);

        tokenSold = tokenSold.add(tokens);

        //emit an event
        emit TokenPurchase(msg.sender, _beneficiary, _busdAmount, tokens);

        //Forward BUSD to the contract so users can get refund if presale goal isn't reached
        tokenBUSD.transferFrom(msg.sender, address(this), _busdAmount);
    }

    // Function to claim dividend from dividend pool, only a holder can call this function
    function claimDividend() public onlyHolder returns (bool) {
        //only if presale ends, not quite neccessary but....
        require(block.timestamp > presaleEnds, "No dividend during presale");
        require(
            totalDividend.sub(userLastDividened[msg.sender]) > 0,
            "No token in the pool, come back later"
        );

        uint256 amount = calculateDividends(msg.sender);

        _transfer(address(this), msg.sender, amount);
        userLastDividened[msg.sender] = totalDividend;
        emit ClaimedDividend(msg.sender, amount);
    }

    // Helper function to calculate users reward in proportion to their balance
    function calculateDividends(address user) public view returns (uint256) {
        // substract last value user has taken
        uint256 dividendToBeShared = totalDividend.sub(userLastDividened[user]);
        uint256 userBalance = balanceOf(user);
        uint256 totalSupply_ =
            totalSupply().sub(tokensLeft()).sub(totalDividend);

        //Calculate how many token a user gets, FORMULA balance*tokenToBeShared / totalSupply(minus presale unsold token and total token in the dividend pool)
        uint256 usersShare =
            (userBalance.mul(dividendToBeShared).div(totalSupply_));

        return usersShare;
    }

    // function that allows users to get a refund if presale doesn't succeed
    function getRefund() public presaleEnded onlyInvestor returns (bool) {
        require(busdRaised < presaleCap, "Goal was reached");
        uint256 _contribution = getUserContribution(msg.sender);
        uint256 amount = busdToToken(_contribution);
        _transfer(msg.sender, wallet, amount);
        tokenBUSD.transfer(msg.sender, _contribution);
        return true;
    }

    // function to get the whole BUSD from contract when presale has ended and goal was reached
    function forwardFunds() public onlyOwner goalReached {
        tokenBUSD.transfer(wallet, tokenBUSD.balanceOf(address(this)));
    }

    function busdToToken(uint256 _busdAmount) public view returns (uint256) {
        // amount/(investorMin/rate) // so as to deal with decimals of tokens
        return _busdAmount.div(investorMinCap.div(rate));
    }

    // -----------------------------------------
    // Presale external interface
    // -----------------------------------------

    /**
     * @dev fallback function ***DO NOT OVERRIDE***
     */
    receive() external payable {
        //Send 0 BNB to claim dividends...
        claimDividend();
        if (msg.value > 0) {
            //Won't stop you from sending more tho :)
            payable(wallet).transfer(msg.value);
        }
    }
}
