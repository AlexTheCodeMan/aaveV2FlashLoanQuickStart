// SPDX-License-Identifier: agpl-3.0
pragma solidity 0.6.12;

import "./aaveV2/FlashLoanReceiverBase.sol";
import "./aaveV2/ILendingPool.sol";
import "./aaveV2/ILendingPoolAddressesProvider.sol";
import "./aaveV2/IERC20.sol";
import "./aaveV2/SafeMath.sol";


contract FLExample is FlashLoanReceiverBase {
    using SafeMath for uint256;

    constructor() FlashLoanReceiverBase(ILendingPoolAddressesProvider(0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5)) public {}

    /**
        This function is called after your contract has received the flash loaned amount
     */
    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    )
        external
        override
        returns (bool)
    {
        //
        // This contract now has the funds requested.
        // Your logic goes here.
        //

        // At the end of your logic above, this contract owes
        // the flashloaned amounts + premiums.
        // Therefore ensure your contract has enough to repay
        // these amounts.

        // Approve the LendingPool contract allowance to *pull* the owed amount
        for (uint i = 0; i < assets.length; i++) {
            uint amountOwing = amounts[i].add(premiums[i]);
            IERC20(assets[i]).approve(address(LENDING_POOL), amountOwing);
        }

        return true;
    }

    function myFlashLoanCall() public returns(address) {
        address receiverAddress = address(this);

        address[] memory assets = new address[](1);
        assets[0] = address(0x6B175474E89094C44Da98b954EedeAC495271d0F); //mainnet DAI
        //can have multiple assets

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 10000 * 10**18;

        // 0 = no debt, 1 = stable, 2 = variable
        uint256[] memory modes = new uint256[](1);
        modes[0] = 0;

        address onBehalfOf = address(this);
        bytes memory params = "";
        uint16 referralCode = 0;

        LENDING_POOL.flashLoan(
            receiverAddress,
            assets,
            amounts,
            modes,
            onBehalfOf,
            params,
            referralCode
        );

    }
}
