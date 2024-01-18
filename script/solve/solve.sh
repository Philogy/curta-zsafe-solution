#!/bin/bash


source .env
forge script script/solve/Step1.s.sol --broadcast --rpc-url $ETH_RPC_URL
forge script script/solve/Step2.s.sol --broadcast --rpc-url $ETH_RPC_URL
forge script script/solve/Step3.s.sol --broadcast --rpc-url $ETH_RPC_URL
forge script script/solve/Step4.s.sol --broadcast --rpc-url $ETH_RPC_URL
forge script script/solve/Step5.s.sol --broadcast --rpc-url $ETH_RPC_URL
forge script script/solve/Step6.s.sol --broadcast --rpc-url $ETH_RPC_URL
forge script script/solve/Step7.s.sol --broadcast --rpc-url $ETH_RPC_URL
