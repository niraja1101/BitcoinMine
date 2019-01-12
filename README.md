GROUP INFORMATION:

Number     Member names         UFID
 1        Niraja Ganpule      17451951
 2        Harshal Patil       55528581

Project Description 
The Project contains an implementation of the features described in the bitcoin whitepaper by Satoshi. 
The concepts implemented are:
1. Bitcoin transaction
2. Bitcoin wallet
3. Bitcoin mining or Proof of work

The concepts implemented as a part of the bonus are :
1. Creating the bitcoin address as done by the real Bitcoin System based on steps           described here
   https://en.bitcoin.it/wiki/Technical_background_of_version_1_Bitcoin_addresses
2. Creating a blockchain with a genesis block, adding a new block to the blockchain         after a node mines pending transactions,checking authenticity of the blockchain and      maintaining synchronization between successive blocks.
3. Signing transactions with private key of the wallet and verifying them with public       key at any point for security and authentication
4. Finding the balance of a user wallet by the same user or any other user using only       the current blockchain as input. Here, computations are made based on transactions       recorded in every block in the blockchain to find the balance of a particular user.

Test Description :

BLOCKCHAIN TESTS 

1. test "create_blockchain" 
   This test verifies the creation of a blockchain with a chain containing a single genesis block, a difficuly, an empty list of pending transactions and a reward for mining a block

2. test "get_latest_block_initial"
   This test verifies the functionality for retrieving the latest block in the blockchain. 

3. test "add_new_block"
   This test verifies the functionality for adding a newly mined block to the existing blockchain

4. test "add_signed_but_pending"
   This test checks the functionality for adding transactions that have been initiated as well as signed to the list of pending transacations in the blockchain

5. test "mineblock"
   This test checks the ability of the node to perform proof of work computations, to calculate a nonce that matches the requirement set by the difficulty in the blockchain, create a new valid block with this nonce and return this new block.

6. test "minepending"
   This test checks the functionality for creating a rewarding transaction to a node when a node mines a block, adding this transaction to the list of pending transactions. It also tests the functionality for initiating the proof of work computation,   adding the newly mined block (returned after proof of work) to the main blockchain and emptying the list of pending transactions in the blockchain

7. test "checkblockchain"  
   This test verifies the authenticity of the blockchain by checking the presence of the genesis block,verifying the authenticity of each block and the synchronization between successive blocks. 


WALLET TESTS


1. test "check_create_keys" 
   This test checks the creation of private key and corresponding public key for a wallet

2. test "create_wallet" 
   This test checks the creation of a wallet object with bitcoin address (as per real Bitcoin algorithm), private key and a basic balance of 100 BTC

3. test "signtransaction" 
   This test checks the functionality for signing a transaction initiated by the user and adding this signature to the transaction so that it can be verified at any point for security and authentication

4. test "sendtransaction" 
   This test verifies the creation of a new transaction with the corresponding addresses and amount when a send request is initiated by one user to another. It also checks whether the transaction is successfully added to the list of pending transactions in the blockchain that need to be confirmed by the nodes as a part of proof of work.

5. test "getbalance" 
    This test verifies the functionality for getting the balance of a wallet at any point of time using a stable blockchain.
    A series of transactions between two wallets are made and the appropriate corressponding balance of each user wallet involved is verified

6. test "findbalforblock" 
    This test verifies the functionality for finding the net balance of a user wallet in a particular block, that is how much difference the transactions in that particular block made to the user balance. A series of transactions between two wallets were made and added to a single block in the blockchain to test and verify this.

7. test "verifytransaction"
     This test verifies the functionality for verifying a transaction that was signed using the private key, the verification is done using the public key.

BLOCK TESTS

1. test "create genblock" 
   This test verifies the functionality for creating a genesis block that is the first block in the blockchain

2. test "create new block"
   This test checks the functionality for constructing the structure of the newly mined block to be added to the blockchain when a node completes the proof of work computations, checking authenticity of this block and synchronization of this block with the latest block in the blockchain

3. test "calculate hash" 
   This test verifies the calculation of the hash of a block and insertion of this hash in the right field in the block,

Execution Instructions

To compile :
In the main folder, on the commandline, run the command  : mix escript.build

To run a demonstration of the built-in functionalities in the application :
In the main folder, on the commandline, run the command  : escript bitcoinmine

To run the tests
In the main folder, on the commandline run the command : mix test
