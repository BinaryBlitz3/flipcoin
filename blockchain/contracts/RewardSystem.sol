// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Achievement.sol";

contract RewardSystem {
    address public owner;
    mapping(address => uint256) public userBalances;
    Achievement[] public achievements;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can call this function"
        );
        _;
    }

    function addAchievement(
        string memory title,
        string memory desc,
        int256 reward
    ) external onlyOwner {
        achievements.push(new Achievement(title, desc, reward));
    }

    function addToBalance(address user, uint256 amount) external onlyOwner {
        userBalances[user] += amount;
    }

    function claimReward(
        uint256 rewardAmount,
        uint256 nonce,
        bytes memory signature
    ) external {
        require(rewardAmount > 0, "Reward amount must be greater than 0");

        // Calculate the message hash
        bytes32 messageHash = keccak256(
            abi.encodePacked(msg.sender, rewardAmount, nonce, address(this))
        );

        // Verify the signature
        require(
            verifySignature(msg.sender, messageHash, signature),
            "Invalid signature"
        );

        // Perform the reward claim
        require(
            token.balanceOf(address(this)) >= rewardAmount,
            "Insufficient contract balance"
        );
        token.transfer(msg.sender, rewardAmount);

        emit RewardClaimed(msg.sender, rewardAmount, nonce);
    }

    function verifySignature(
        address signer,
        bytes32 messageHash,
        bytes memory signature
    ) internal pure returns (bool) {
        bytes32 ethSignedMessageHash = messageHash.toEthSignedMessageHash();
        address recoveredSigner = ethSignedMessageHash.recover(signature);
        return recoveredSigner == signer;
    }

    event RewardClaimed(
        address indexed user,
        uint256 rewardAmount,
        uint256 nonce
    );
}
