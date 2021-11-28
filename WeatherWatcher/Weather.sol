// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import { Base64 } from "./libraries/Base64.sol";

contract Weather is ERC721URIStorage, VRFConsumerBase {
    using Strings for string;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(bytes32 => address) internal requestIdToSender;
    mapping(bytes32 => uint) internal requestIdToTokenId;
    mapping(uint => uint) internal tokenIdToRandomNumber;

    event requestedRandomSVG(bytes32 indexed requestId, uint indexed tokenId);
    event CreatedRSVGNFT(uint indexed tokenID, string tokenURI);
    event CreatedUnfinishedRandomSVG(uint indexed, uint randomness);


    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;
    address public vrfCoordinator;
    address public linkToken;

    // SVG parameters
    uint256 public maxNumberOfCircles;
    uint public size;
    string public svgPartOne;
    string public svgPartTwo;
    
    string[] weather = [
        "Rain", 
        "Snow", 
        "Sleet", 
        "Hail", 
        "Hurricane", 
        "Tornado", 
        "Sunshine", 
        "Partly Cloudy", 
        "Foggy", 
        "Drizzle", 
        "Freezing Rain", 
        "A Little Rain",
        "A Little Snow", 
        "Mostly Cloudy", 
        "Extemely Sunny", 
        "Thunderstorm", 
        "Blizzard", 
        "Ice Storm", 
        "Torrential Rain", 
        "Thundersnow",
        "Warm Breeze",
        "Cold Wind",
        "Fog and Rain"
    ];
    


      /**
      network: rinkeby
      vrf coordinator: 0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B
      link token: 0x01BE23585060835E02B77ef475b0Cc51aA1e0709
      key hash: 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311
      fee: 0.1 LINK

      network: mumbai
      vrf coordinator: 0x8C7382F9D8f56b33781fE506E897a4F1e2d17255
      link token address: 0x326C977E6efc84E512bB9C30f76E30c160eD06FB
      key hask: 0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4
      fee: 0.0001 LINK
      **/

    constructor()
        ERC721 ("Weather", "WTHR")
        VRFConsumerBase(
            0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B,
            0x01BE23585060835E02B77ef475b0Cc51aA1e0709)
         
    {
        vrfCoordinator = 0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B;
        linkToken = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10 ** 18;

        // initialize range of SVG Parameters to be chosen from
        
        svgPartOne = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: darkcyan; font-family: serif; font-size: 39px; }</style><rect width='100%' height='100%' fill='aquamarine' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
        svgPartTwo = "</text></svg>";

    }

    function predictWeather() public returns (bytes32 requestId){
    requestId = getRandomNumber();
    requestIdToSender[requestId] = msg.sender;
    uint tokenId = _tokenIds.current();
    requestIdToTokenId[requestId] = tokenId;
    emit requestedRandomSVG(requestId, tokenId);
    _tokenIds.increment();
  }

  // sends request for random number to Chainlink VRF node along with fee
  function getRandomNumber() internal returns (bytes32 requestId) {
    require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
    return requestRandomness(keyHash, fee);
  }

  // callback function called with the returning random value
  function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
    address nftOwner = requestIdToSender[requestId];
    uint tokenId = requestIdToTokenId[requestId];
    _safeMint(nftOwner, tokenId);
    tokenIdToRandomNumber[tokenId] = randomness;
    emit CreatedUnfinishedRandomSVG(tokenId, randomness);
  }

  function tokenURI(uint tokenId) public view override returns(string memory){
    string memory _tokenURI = "Token with that ID does not exist.";
    if (_exists(tokenId)){
      require(tokenIdToRandomNumber[tokenId] > 0, "Need to wait for Chainlink VRF");
      string memory svg = generateSVG(tokenIdToRandomNumber[tokenId]);
      string memory imageURI = svgToImageURI(svg);
      _tokenURI = formatTokenURI(imageURI);
    }
    return _tokenURI;
  }

  function generateSVG(uint _randomNumber) internal view returns(string memory finalSvg){

    uint grabIt = (_randomNumber % 23) + 1;
    string memory prediction = weather[grabIt];
    finalSvg = string(abi.encodePacked(svgPartOne, prediction, svgPartTwo));
  }

  
  function svgToImageURI(string memory svg) public pure returns(string memory){
    string memory baseURL = "data:image/svg+xml;base64,";
    string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
    return string(abi.encodePacked(baseURL, svgBase64Encoded));
  }

  function formatTokenURI(string memory imageURI) public pure returns(string memory){
    string memory baseURL = "data:application/json;base64,";
    return string(
      abi.encodePacked(
        baseURL,
        Base64.encode(
          bytes(
            abi.encodePacked(
              '{"name": "SVG NFT", ', 
              '"description": "An NFT with SVG on chain!", ',
              '"attributes":"", ',
              '"image": "',
              imageURI,
              '"}'
            )
          )
        )
      )
    );
  }
}
