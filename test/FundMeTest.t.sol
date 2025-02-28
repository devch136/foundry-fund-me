// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;
import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    uint256 public constant ETHVALUE = 0.1 ether;
    address public USER = makeAddr("user");

    function setUp() external {
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        fundMe = new DeployFundMe().run();
        vm.deal(USER, 10 ether);
    }

    function testMinUSDIsFive() public view {
        assertEq(fundMe.MIN_USD(), 5e18);
    }

    function testIsOwner() public view {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testVersion() public view {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFails() public {
        vm.expectRevert();
        fundMe.fund();
    }

    modifier userFunded {
        vm.prank(USER);
        fundMe.fund{value: ETHVALUE}();
        _;
    }

    function testFundWorks() public {
        vm.prank(USER);
        fundMe.fund{value: ETHVALUE}();
        assertEq(USER, fundMe.funders(0));
        assertEq(ETHVALUE, fundMe.addressToAmount(USER));
    }

    function testOnlyOwnerCanWithdrawFails() public  userFunded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testOnlyOwnerCanWithdrawWorks() public  userFunded {
        address owner  = fundMe.i_owner();
        uint256 ownerBalanceBefore = owner.balance;
        uint256 contractBalanceBefore = address(fundMe).balance;
        vm.prank(owner);
        fundMe.withdraw();
        uint256 ownerBalanceAfter = owner.balance;
        uint256 contractBalanceAfter = address(fundMe).balance;

        assertEq(0, contractBalanceAfter);
        assertEq(ownerBalanceBefore + contractBalanceBefore, ownerBalanceAfter);
    }

    function testWithdrawMultipleFunders() public {
        address owner  = fundMe.i_owner();
        
        for(uint160 i = 1; i < 10; i++){
            hoax(address(i), 1 ether);
            fundMe.fund{value: ETHVALUE}();
        }

        uint256 ownerBalanceBefore = owner.balance;
        uint256 contractBalanceBefore = address(fundMe).balance;

        // uint256 gasStart = gasleft();
        // vm.txGasPrice(1e10);
        vm.prank(owner);
        fundMe.withdraw();
        // uint256 gasEnd = gasleft();
        // console.log((gasStart - gasEnd) * tx.gasprice);

        uint256 ownerBalanceAfter = owner.balance;
        uint256 contractBalanceAfter = address(fundMe).balance;

        assertEq(0, contractBalanceAfter);
        assertEq(ownerBalanceBefore + contractBalanceBefore, ownerBalanceAfter);
    }

        function testCheapWithdrawMultipleFunders() public {
        address owner  = fundMe.i_owner();
        
        for(uint160 i = 1; i < 10; i++){
            hoax(address(i), 1 ether);
            fundMe.fund{value: ETHVALUE}();
        }

        uint256 ownerBalanceBefore = owner.balance;
        uint256 contractBalanceBefore = address(fundMe).balance;

        // uint256 gasStart = gasleft();
        // vm.txGasPrice(1e10);
        vm.prank(owner);
        fundMe.cheapWithdraw();
        // uint256 gasEnd = gasleft();
        // console.log((gasStart - gasEnd) * tx.gasprice);

        uint256 ownerBalanceAfter = owner.balance;
        uint256 contractBalanceAfter = address(fundMe).balance;

        assertEq(0, contractBalanceAfter);
        assertEq(ownerBalanceBefore + contractBalanceBefore, ownerBalanceAfter);
    }
}