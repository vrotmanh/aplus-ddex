const AplusEscrows = artifacts.require("./AplusEscrows.sol");
const AplusListings = artifacts.require("./AplusListings.sol");
const linniaHub = "0x177bf15e7e703f4980b7ef75a58dc4198f0f1172"

module.exports = (deployer, network, accounts) => {
  let aplusListingsInstance;

  deployer.deploy(AplusListings, linniaHub).then(() => {
    return AplusListings.deployed()
  }).then((_aplusListingsInstance) => {
    aplusListingsInstance = _aplusListingsInstance;
    return deployer.deploy(AplusEscrows, _aplusListingsInstance.address, linniaHub)
  }).then((_aplusEscrowsInstance) => {
    aplusListingsInstance.setupEscrowContract(_aplusEscrowsInstance.address)
  })
};
