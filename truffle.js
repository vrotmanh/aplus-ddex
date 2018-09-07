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
      provider: new HDWalletProvider("493aaf95db30eb88f483cc317c19d3adb7745d2698b938ce547cbebf6851f990", "https://ropsten.infura.io/"+infura_apikey),
      network_id: 4,
      gas: 4000000,
      gasPrice: 1,
    }
  }
};