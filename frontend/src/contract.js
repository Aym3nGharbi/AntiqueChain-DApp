import { ethers } from "ethers"; import info from "./contract-info.json";
export const rpc = new ethers.JsonRpcProvider("http://127.0.0.1:8545");
export const short=a=>a ? `${a.slice(0,6)}…${a.slice(-4)}` : "—";
export const eth=n=>Number(ethers.formatEther(n)).toLocaleString("fr-FR",{maximumFractionDigits:4});
/** Convertit une URI IPFS immuable en URL de passerelle affichable par le navigateur. */
export const imageUrl = value => value?.startsWith("ipfs://") ? `https://gateway.pinata.cloud/ipfs/${value.slice(7)}` : value;
export async function readContract(){ if(!info.address) throw Error("Contrat non déployé : lancez npm run deploy puis npm run seed."); return new ethers.Contract(info.address,info.abi,rpc); }
export async function walletContract(){ if(!window.ethereum) throw Error("MetaMask est introuvable."); const provider=new ethers.BrowserProvider(window.ethereum); const signer=await provider.getSigner(); return { contract:new ethers.Contract(info.address,info.abi,signer), signer, provider }; }
export async function ensureHardhat(){ const chain="0x7a69"; try { await window.ethereum.request({method:"wallet_switchEthereumChain",params:[{chainId:chain}]}); } catch(e) { if(e.code===4902) await window.ethereum.request({method:"wallet_addEthereumChain",params:[{chainId:chain,chainName:"Hardhat Local",rpcUrls:["http://127.0.0.1:8545"],nativeCurrency:{name:"ETH",symbol:"ETH",decimals:18}}]}); else throw e; } }
