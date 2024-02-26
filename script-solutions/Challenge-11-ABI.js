export const ABI = [
	{
		"inputs": [
			{
				"internalType": "bytes32",
				"name": "_slotValue",
				"type": "bytes32"
			}
		],
		"name": "breakit",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_target",
				"type": "address"
			}
		],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"inputs": [],
		"name": "target",
		"outputs": [
			{
				"internalType": "contract Privacy",
				"name": "",
				"type": "address"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
] 