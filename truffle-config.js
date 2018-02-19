module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  require('babel-register')
module.exports = {
  networks: {
    development: {
      host: 'localhost',
      port: 7545,
      network_id: '*' // Match any network id
    }
  }
}

};
