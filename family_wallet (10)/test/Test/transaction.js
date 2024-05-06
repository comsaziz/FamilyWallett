const Transaction = artifacts.require("Transaction");
const truffleAssert = require('truffle-assertions');

contract("Transaction", accounts => {
    const [deployerAccount, recipientAccount] = accounts;

    beforeEach(async () => {
        // Reset the maxTransferAmount to a known value for each test
        this.instance = await Transaction.new();
        await this.instance.setMaxTransferAmount(web3.utils.toWei('100', 'ether'), {from: deployerAccount});
    });

    it("should set the initial maximum transfer amount correctly", async () => {
        const maxTransferAmount = await this.instance.maxTransferAmount();
        assert.equal(maxTransferAmount.toString(), web3.utils.toWei('100', 'ether'), "The max transfer amount should initially be 100 ether");
    });

    it("should allow updating the maxTransferAmount", async () => {
        const newMaxAmount = web3.utils.toWei('50', 'ether');
        await this.instance.setMaxTransferAmount(newMaxAmount, {from: deployerAccount});
        const updatedMaxTransferAmount = await this.instance.maxTransferAmount();
        assert.equal(updatedMaxTransferAmount.toString(), newMaxAmount, "The max transfer amount should be updated to 50 ether");
    });

    it("should transfer ether if the amount is within the limit", async () => {
        const sendAmount = web3.utils.toWei('1', 'ether');
        const initialBalance = await web3.eth.getBalance(recipientAccount);
        const result = await this.instance.transferEther(recipientAccount, "normal transfer", {
            from: deployerAccount,
            value: sendAmount
        });
        const finalBalance = await web3.eth.getBalance(recipientAccount);
        const newBalance = BigInt(finalBalance) - BigInt(initialBalance);
        assert.equal(newBalance.toString(), sendAmount, "The recipient should receive 1 ether");
        truffleAssert.eventEmitted(result, 'EtherTransferred', (ev) => {
            return ev.from === deployerAccount && ev.to === recipientAccount && ev.amount.toString() === sendAmount && ev.category === "normal transfer";
        }, "EtherTransferred event should be emitted with correct parameters");
    });

    it("should fail to transfer ether if the amount exceeds the limit", async () => {
        const sendAmount = web3.utils.toWei('101', 'ether');
        await truffleAssert.reverts(
            this.instance.transferEther(recipientAccount, "excessive transfer", {from: deployerAccount, value: sendAmount}),
            "You have exceeded the maximum transfer amount"
        );
    });

    it("should fail if sender does not have enough balance", async () => {
        // Ensuring the transfer amount is realistic given typical test account balances
        const sendAmount = web3.utils.toWei('90', 'ether'); // More realistic and under the limit
        await this.instance.setMaxTransferAmount(web3.utils.toWei('100', 'ether'), {from: deployerAccount}); // Reset if needed

        // Assuming deployerAccount does not have more than 90 ether in this test case setup
        await truffleAssert.reverts(
            this.instance.transferEther(recipientAccount, "over-balance transfer", {from: deployerAccount, value: sendAmount}),
            "You don't have enough balance"
        );
    });
});
