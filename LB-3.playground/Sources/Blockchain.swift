final class Blockchain {

    private(set) var coinDatabase: [String: Int] = [:]  // accountID -> баланс
    private(set) var blockHistory: [Block] = []
    private(set) var txDatabase: [String: Transaction] = [:]  // transactionID -> Transaction

    var faucetCoins: Int

    init(faucetCoins: Int = 100) {
        self.faucetCoins = faucetCoins
        initBlockchain()
    }

    // Генезис-блок
    private func initBlockchain() {
        let genesisTx = Transaction.createTransaction(operations: [], nonce: 0)!
        let genesisBlock = Block.createBlock(transactions: [genesisTx], prevHash: "0")
        blockHistory.append(genesisBlock)
    }

    // Отримання тестових монет
    func getTokenFromFaucet(for account: Account, amount: Int) {
        guard amount <= faucetCoins else {
            print("Not enough faucet coins")
            return
        }
        faucetCoins -= amount
        account.updateBalance(amount: amount)
        coinDatabase[account.accountID] = account.getBalance()
    }

    // Перевірка блоку
    func validateBlock(_ block: Block) -> Bool {

        // 1. Перевірка посилання на останній блок
        guard block.prevHash == blockHistory.last?.blockID else {
            print("Invalid previous hash")
            return false
        }

        // 2. Перевірка транзакцій на дублювання
        for tx in block.setOfTransactions {
            if txDatabase[tx.transactionID] != nil {
                print("Duplicate transaction detected: \(tx.transactionID)")
                return false
            }
        }

        // 3. Перевірка операцій у всіх транзакціях
        for tx in block.setOfTransactions {
            for op in tx.setOfOperations {
                if !op.verifyOperation() {
                    print("Invalid operation in transaction \(tx.transactionID)")
                    return false
                }
                // Перевірка балансу відправника
                let senderID = op.sender.accountID
                let senderBalance = coinDatabase[senderID] ?? op.sender.getBalance()
                if senderBalance < op.amount {
                    print("Insufficient balance for sender \(senderID)")
                    return false
                }
            }
        }

        return true
    }

    // Додавання блоку
    func addBlock(_ block: Block) {
        guard validateBlock(block) else {
            print("Block validation failed")
            return
        }

        // Оновлення бази балансів
        for tx in block.setOfTransactions {
            for op in tx.setOfOperations {
                let senderID = op.sender.accountID
                let receiverID = op.receiver.accountID

                // Оновлення балансу відправника
                coinDatabase[senderID, default: op.sender.getBalance()] -= op.amount
                op.sender.updateBalance(amount: -op.amount)

                // Оновлення балансу отримувача
                coinDatabase[receiverID, default: op.receiver.getBalance()] += op.amount
                op.receiver.updateBalance(amount: op.amount)

                // Додавання транзакції до бази
                txDatabase[tx.transactionID] = tx
            }
        }

        // Додавання блоку до історії
        blockHistory.append(block)
        print("Block \(block.blockID) added successfully")
    }

    // Debug
    func printBlockchain() {
        print("Blockchain contains \(blockHistory.count) blocks")
        for block in blockHistory {
            block.printBlock()
        }
        print("Coin balances:")
        for (accountID, balance) in coinDatabase {
            print("\(accountID): \(balance)")
        }
    }
}
