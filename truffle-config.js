module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*",

    }
  },
  contracts_directory: './contracts',
  compilers: {
    solc: {
      version: "0.8.15",
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  db: {
    enabled: false
  },
  mocha: {
    reporter: 'spec', // Giảm thông tin log trong quá trình chạy test
  },

};
