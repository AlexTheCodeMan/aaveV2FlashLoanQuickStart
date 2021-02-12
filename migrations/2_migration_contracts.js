const FLExample = artifacts.require("./FLExample.sol");


module.exports = function(deployer) {
    deployer.deploy(FLExample);
}
