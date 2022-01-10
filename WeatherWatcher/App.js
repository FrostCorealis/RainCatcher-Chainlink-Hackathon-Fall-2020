import { ethers } from "ethers";
import React, { useEffect, useState } from "react";
import './styles/App.css';
import Weather from './utils/Weather.json';

const BUILDSPACE_LINK = 'https://buildspace.so';
const CHAINLINK_LINK = 'https://docs.chain.link';
const REPLIT_LINK = 'https://replit.com'
const TWITTER_HANDLE = 'FrostCorealis';
const TWITTER_LINK = `https://twitter.com/${TWITTER_HANDLE}`;
const RARIBLE_LINK = 'https://rinkeby.rarible.com/collection/0x3788bc99b6b4039d8e6040b1a47eab88e586f753/items';
const OPENSEA_LINK = 'https://testnets.opensea.io/collection/weather-gmyljrowu0';
const CONTRACT_ADDRESS = '0x3788bC99B6b4039D8E6040B1a47eaB88E586F753';
//const TOTAL_MINT_COUNT = 101;

const App = () => {
  const [currentAccount, setCurrentAccount] = useState("");
    
  const checkIfWalletIsConnected = async () => {
    const { ethereum } = window;

    if (!ethereum) {
      console.log("Make sure you have metamask!");
      return;
    } else {
      console.log("We have the ethereum object.", ethereum);
    }

    const accounts = await ethereum.request({ method: "eth_accounts" });

    if (accounts.length !== 0) {
      const account = accounts[0];
      console.log("Found an authorized account:", account);
      setCurrentAccount(account)
      setupEventListener()
   } else {
     console.log("No authorized account found.")
   }
};

  /*
  * Implement your connectWallet method here
  */
const connectWallet = async () => {
  try {
    const { ethereum } = window;

    if (!ethereum) {
      alert("Get MetaMask!");
      return;
    }
    /*
     * Fancy method to request access to account.
     */
    const accounts = await ethereum.request({ method: "eth_requestAccounts" });

    console.log("Connected", accounts[0]);
    setCurrentAccount(accounts[0]);
    setupEventListener() 
  } catch (error) {
    console.log(error)
  }
};

  // Setup our listener.
  const setupEventListener = async () => {
    // Most of this looks the same as our function askContractToMintNft
    try {
      const { ethereum } = window;

      if (ethereum) {
        // Same stuff again
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, Weather.abi, signer);


        console.log("Setup event listener!")

      } else {
        console.log("Ethereum object doesn't exist!");
      }
    } catch (error) {
      console.log(error)
    }
  }

const askContractToMintNft = async () => {
  
  try {
    const { ethereum } = window;

    if (ethereum) {
      const provider = new ethers.providers.Web3Provider(ethereum);
      const signer = provider.getSigner();
      const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, Weather.abi, signer);

      console.log("Taking care of gas fees...")
      let nftTxn = await connectedContract.predictWeather();

      console.log("Contacting the VRF to get today's weather for you...")
      await nftTxn.wait();
        
      console.log(`Today's random weather is ready for you! See transaction: https://rinkeby.etherscan.io/tx/${nftTxn.hash}`);

    } else {
      console.log("Ethereum object doesn't exist!");
    }
  } catch (error) {
    console.log(error)
 }
}  

// Render Methods
  const renderNotConnectedContainer = () => (
    <button onClick={connectWallet} className="cta-button connect-wallet-button">
      Connect to Wallet
    </button>
  );

useEffect(() => {
  checkIfWalletIsConnected();
}, [])


return (
  <div className="App">
    <div className="container">
      <div className="header-container">
        <p className="header gradient-text">Weather Watcher</p>
        <p className="sub-text">What will the weather be today?</p>
        <p className="sub-sub-text">Mint a Weather NFT to find out! 🌧️ </p>
        {currentAccount === "" ? (
          renderNotConnectedContainer()
        ) : (
          <button onClick={askContractToMintNft}className="cta-button connect-wallet-button">
            Mint Weather NFT
          </button>
          )}

          <p className="spacer-text">{' '}</p>

            <button className="opensea-button"><a 
            href={OPENSEA_LINK}
            target="_blank"
            rel="noreferrer">
              🌊 {' '} View Collection on OpenSea
            </a></button>

            <button className="opensea-button"><a 
            href={RARIBLE_LINK}
            target="_blank"
            rel="noreferrer">
              💛 {' '} View Collection on Rarible
            </a></button>

        </div>

        <div className="footer-container">
          <p className="footer-text">created by    
          <a
            className="footer-text"
            href={TWITTER_LINK}
            target="_blank"
            rel="noreferrer"
          >{' '}Storm & Frost Corealis</a>
           <p className="footer-text"> special thanks to{' '}<a
            className="footer-text"
            href={CHAINLINK_LINK}
            target="_blank"
            rel="noreferrer"
          >{' '}chainlink</a>,{' '}<a
            className="footer-text"
            href={BUILDSPACE_LINK}
            target="_blank"
            rel="noreferrer"
          >{' '}buildspace</a>,{' '}and{' '}<a
            className="footer-text"
            href={REPLIT_LINK}
            target="_blank"
            rel="noreferrer"
          >{' '}replit</a></p>
           
          </p>
        </div>
      </div>
    </div>
  );
};

export default App;
