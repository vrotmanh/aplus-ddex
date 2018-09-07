const HDWalletProvider = require("truffle-hdwallet-provider-privkey");

var infura_apikey = "7hgs130LuoqNAlWKkBqm";

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 7545,
      network_id: "*" // Match any network id
    },
    ropsten: {
      provider: new HDWalletProvider("93031A5BC9A7E8F7F6EAA23406DB6FB77B2FBBDE5CDE72E491B1CD5C489B31CF", "https://ropsten.infura.io/"+infura_apikey),
      network_id: 4,
      gas: 4000000,
      gasPrice: 1,
    }
  }
};