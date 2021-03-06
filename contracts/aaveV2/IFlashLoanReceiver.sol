pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "./ILendingPoolAddressesProvider.sol";
import "./ILendingPool.sol";


interface IFlashLoanReceiver {
  function executeOperation(
    address[] calldata assets,
    uint256[] calldata amounts,
    uint256[] calldata premiums,
    address initiator,
    bytes calldata params
  ) external returns (bool);

  function ADDRESSES_PROVIDER() external view returns (ILendingPoolAddressesProvider);

  function LENDING_POOL() external view returns (ILendingPool);
}
