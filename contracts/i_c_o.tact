import "@stdlib/deploy";

const JettonTransferGas: Int = ton("0.05");
// 1 ton = 1 000 000 000

contract ICO with Deployable {
    // ICO
    icoWalletAddress: Address;

    // ICO additional data
    icoCode: Cell;
    icoMasterAddress: Address;

    // Status
    owner: Address;
    onSelling: Bool = false;
    cost: Int as coins;

    init(jettonWalletCode: Cell, jettonMasterAddress: Address, cost_per_one: Int) {
        self.icoWalletAddress = calculateJettonWalletAddress(
            myAddress(),
            jettonMasterAddress,
            jettonWalletCode,
        );
        self.icoCode = jettonWalletCode;
        self.icoMasterAddress = jettonMasterAddress;
        self.owner = sender();
        self.cost = cost_per_one;
    }

    // Buy
    receive() {
        require(self.onSelling == true, "Selling not started");
        let tokensToSend: Int = (context().value * self.cost) / 1000000000; // Correct calculation of tokens to send
        let senderJettonAddress: Address = calculateJettonWalletAddress(sender(), self.icoMasterAddress, self.icoCode);
        send(SendParameters{
            to: self.icoWalletAddress,
            value: JettonTransferGas,
            body: JettonTransfer{
                queryId: 42,
                amount: tokensToSend, // Send the correct number of tokens 2000000000
                destination: sender(),
                responseDestination: sender(),
                customPayload: null,
                forwardTonAmount: 1,
                forwardPayload: rawSlice("F")
            }.toCell(),
        });
    }

    receive("stop") {
        require(sender() == self.owner, "Only owner command");
        self.onSelling = false;
    }

    receive("open") {
        require(sender() == self.owner, "Only owner command");
        self.onSelling = true;
    }

    receive(msg: Widthrow) {
        require(sender() == self.owner, "Only owner command");
        require(self.onSelling == false, "Only if ICO stoped");
        send(SendParameters{
            to: self.icoWalletAddress,
            value: JettonTransferGas,
            body: JettonTransfer{
                queryId: 42,
                amount: msg.jettons_amount, // Send the correct number of tokens 2000000000
                destination: self.owner,
                responseDestination: self.owner,
                customPayload: null,
                forwardTonAmount: 1,
                forwardPayload: rawSlice("F")
            }.toCell(),
        });
        send(SendParameters{
            to: self.owner,
            bounce: true,
            value: 0,
            mode: SendRemainingBalance + SendIgnoreErrors
        });
    }

    get fun owner(): Address {
        return self.owner;
    }

    get fun selling_status(): Bool {
        return self.onSelling;
    }

    get fun cost(): Int {
        return self.cost;
    }
}

message Widthrow {
    jettons_amount: Int as coins;
}

message(0xf8a7ea5) JettonTransfer {
    queryId: Int as uint64;
    amount: Int as coins;
    destination: Address;
    responseDestination: Address?;
    customPayload: Cell? = null;
    forwardTonAmount: Int as coins;
    forwardPayload: Slice as remaining;
}

struct JettonWalletData {
    balance: Int as coins;
    ownerAddress: Address;
    jettonMasterAddress: Address;
    jettonWalletCode: Cell;
}

fun calculateJettonWalletAddress(
    ownerAddress: Address,
    jettonMasterAddress: Address,
    jettonWalletCode: Cell
): Address {
    let initData = JettonWalletData{
        balance: 0,
        ownerAddress,
        jettonMasterAddress,
        jettonWalletCode,
    };

    return contractAddress(StateInit{
        code: jettonWalletCode,
        data: initData.toCell(),
    });
}
