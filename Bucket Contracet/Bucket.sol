// SPDX-License-Identifier: UNLICENSED
// built from a contract created during a _buildspace workshop
// this is the first RainCatcher contract.  it mints a bucket and allows users to stake

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";


contract Bucket is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  constructor() ERC721 ("Bucket", "BKT") {
    console.log("It's Bucket Time!^^");
  }

  // mint Bucket
  function makeBucket() public {
    uint256 newItemId = _tokenIds.current();

    _safeMint(msg.sender, newItemId);

    // sets the Temporary Bucket data
    _setTokenURI(newItemId, "data:application/json;base64,ewogICAgIm5hbWUiOiAiWW91ciBUZW1wb3JhcnkgQnVja2V0IiwKICAgICJkZXNjcmlwdGlvbiI6ICJTdGFrZSB5b3VyIEJ1Y2tldCBvbiBhIGNpdHkgdG8gY29sbGVjdCBSQUlOLiIsCiAgICAiaW1hZ2UiOiAiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQSE4yWnlCNGJXeHVjejBpYUhSMGNEb3ZMM2QzZHk1M015NXZjbWN2TWpBd01DOXpkbWNpSUhCeVpYTmxjblpsUVhOd1pXTjBVbUYwYVc4OUluaE5hVzVaVFdsdUlHMWxaWFFpSUhacFpYZENiM2c5SWpBZ01DQXpOVEFnTXpVd0lqNEtJQ0FnSUR4emRIbHNaVDR1WW1GelpTQjdJR1pwYkd3NklIZG9hWFJsT3lCbWIyNTBMV1poYldsc2VUb2djMkZ1Y3lCelpYSnBaanNnWm05dWRDMXphWHBsT2lBek1uQjRPeUI5UEM5emRIbHNaVDRLSUNBZ0lEeHlaV04wSUhkcFpIUm9QU0l4TURBbElpQm9aV2xuYUhROUlqRXdNQ1VpSUdacGJHdzlJblJsWVd3aUlDOCtDaUFnSUNBOGRHVjRkQ0I0UFNJMU1DVWlJSGs5SWpVd0pTSWdZMnhoYzNNOUltSmhjMlVpSUdSdmJXbHVZVzUwTFdKaGMyVnNhVzVsUFNKdGFXUmtiR1VpSUhSbGVIUXRZVzVqYUc5eVBTSnRhV1JrYkdVaVBsUmxiWEJ2Y21GeWVTQkNkV05yWlhROEwzUmxlSFErQ2p3dmMzWm5QZz09Igp9");
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    // increment the counter for when the next Bucket is minted
    _tokenIds.increment();
  }


 // stake Bucket

}
