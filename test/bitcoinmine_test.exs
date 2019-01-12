defmodule BitcoinTest do
  use ExUnit.Case
  doctest Bitcoin

  test "greets the world" do
    assert Bitcoin.hello() == :world
  end

   ## Blockchain tests
   test "create_blockchain" do
    newchain = %Blockchain{blockchain: [Block.genblock], difficulty: 2, pending: [], reward: 100}
    mainblockchain =  Blockchain.createchain
    assert mainblockchain == newchain
  end

  test "get_latest_block_initial" do
    newchain = %Blockchain{blockchain: [Block.genblock], difficulty: 2, pending: [], reward: 100}
    genblock = Blockchain.getlatestblock(newchain)
    assert genblock === Block.genblock
  end

  test "add_new_block" do
    #create input
    newchain = %Blockchain{blockchain: [Block.genblock], difficulty: 2, pending: [], reward: 100}
    transaction = %Transaction{from: "sender1" ,to: "sender2"  ,amount: 20, timestamp: System.system_time(:second)}
    randomblock = %Block{ index: 12,previousHash: "",timestamp: System.system_time(:second),data: [transaction],nonce: 5} |> Block.calchash
    newerchain = Map.put(newchain,:blockchain,[Block.genblock] ++ [randomblock])


    #run unit
    obtainedchain = Blockchain.addblock(newchain,randomblock)

    #check success
    assert obtainedchain === newerchain
  end

  test "add_signed_but_pending" do
    newchain = %Blockchain{blockchain: [Block.genblock], difficulty: 2, pending: [], reward: 100}
    privkey = Wallet.create_keys
    transaction = %Transaction{from: "sender1",to: "sender2",amount: 20,timestamp: 0}
    signedtransaction = Wallet.signtransaction(privkey,transaction)
    newerchain = Map.put(newchain,:pending, newchain.pending ++ [signedtransaction])

    obtainedchain = Blockchain.add_signed_but_pending(newchain,signedtransaction)

    assert newerchain === obtainedchain


  end

  test "minepending" do
  wallet1 = Wallet.create_wallet
  wallet2 = Wallet.create_wallet
  transaction1 = %Transaction{from: wallet1.publickey ,to: wallet2.publickey ,amount: 0, timestamp: 0}
  transaction2 = %Transaction{from: wallet2.publickey ,to: wallet1.publickey,amount: 20,timestamp: 0}
  mainblockchain = %Blockchain{blockchain: [Block.genblock], difficulty: 2, pending: [transaction1,transaction2], reward: 100}


  newblockchain = Blockchain.minepending(mainblockchain,wallet1)


  assert length(newblockchain.blockchain) === 2
  addedblock = Blockchain.getlatestblock(newblockchain)
  assert addedblock.index === 1
  assert length(addedblock.data) === 3
  assert newblockchain.pending === []

  end

  test "mineblock" do
  wallet1 = Wallet.create_wallet
  wallet2 = Wallet.create_wallet
  transaction1 = %Transaction{from: wallet1.publickey ,to: wallet2.publickey ,amount: 0, timestamp: 0}
  transaction2 = %Transaction{from: wallet2.publickey ,to: wallet1.publickey,amount: 20,timestamp: 0}
  transaction3 = %Transaction{from: "" ,to: wallet1.publickey,amount: 100,timestamp: 0}
  mainblockchain = %Blockchain{blockchain: [Block.genblock], difficulty: 2, pending: [transaction1,transaction2,transaction3], reward: 100}

  newvalidblock=Blockchain.mineblock(mainblockchain,0)

  assert newvalidblock.nonce
  assert newvalidblock.index === 1
  end

  test "checkblockchain" do
    wallet1 = Wallet.create_wallet
    wallet2 = Wallet.create_wallet
    mainblockchain =  Blockchain.createchain
    newblockchain = Wallet.send(wallet1,wallet2.publickey,60,mainblockchain)
    newblockchain = Wallet.send(wallet2,wallet1.publickey,20,newblockchain)
    newchain= Blockchain.minepending(newblockchain,wallet1)

    assert Blockchain.checkblockchain(newchain)

  end


  ## WALLET TESTS
  test "check_create_keys" do
    privatekey = Wallet.create_keys
    assert IO.puts privatekey
  end

  #check if wallet is created and initialized with a balance of 100 bitcoins
  test "create_wallet" do
    wallet1 = Wallet.create_wallet
    assert wallet1.balance == 100
    assert wallet1.publickey
    assert wallet1.privatekey
  end

  test "signtransaction" do


    privkey = Wallet.create_keys
    transaction = %Transaction{from: "sender1",to: "sender2",amount: 20,timestamp: 0}
    signedtransaction = Wallet.signtransaction(privkey,transaction)
    assert signedtransaction.signature

  end


   test "sendtransaction" do
     wallet1 = Wallet.create_wallet
     wallet2 = Wallet.create_wallet
     mainblockchain = %Blockchain{blockchain: [Block.genblock], difficulty: 2, pending: [], reward: 100}
     transaction1   = %Transaction{from: wallet1.publickey ,to: wallet2.publickey  ,amount: 20 , timestamp: System.system_time(:second)}
     transaction1   = Wallet.signtransaction(wallet1.privatekey,transaction1)
     new_mainblockchain = Blockchain.add_signed_but_pending(mainblockchain,transaction1)

     newchain = Wallet.send(wallet1,wallet2.publickey,20,mainblockchain)

     assert length(new_mainblockchain.pending) === length(newchain.pending)
   end

   test "getbalance" do
    wallet1 = Wallet.create_wallet
    wallet2 = Wallet.create_wallet
    mainblockchain =  Blockchain.createchain
    newblockchain = Wallet.send(wallet1,wallet2.publickey,60,mainblockchain)
    newblockchain = Wallet.send(wallet2,wallet1.publickey,20,newblockchain)
    newchain= Blockchain.minepending(newblockchain,wallet1)

    assert Wallet.getbal(newchain,wallet1.publickey) == 160
    assert Wallet.getbal(newchain,wallet2.publickey) == 140



   end

   test "findbalforblock" do
    wallet1 = Wallet.create_wallet
    wallet2 = Wallet.create_wallet
    mainblockchain =  Blockchain.createchain
    newblockchain = Wallet.send(wallet1,wallet2.publickey,60,mainblockchain)
    newblockchain = Wallet.send(wallet2,wallet1.publickey,20,newblockchain)
    newchain= Blockchain.minepending(newblockchain,wallet1)

    assert Wallet.findbalforblock(newchain.blockchain,1,length(newchain.blockchain)-1,wallet1.publickey) == 60

   end



   test "verifytransaction" do
    wallet1 = Wallet.create_wallet
    wallet2 = Wallet.create_wallet
    pubkey = Wallet.get_public_key(wallet1.privatekey|> Base.decode16!)
    transaction = %Transaction{from: wallet1.publickey,to: wallet2.publickey,amount: 20,timestamp: 0}
    transaction2 = Wallet.signtransaction(wallet1.privatekey,transaction)
    verify3 = Wallet.verifytransaction(pubkey,transaction2)
    assert verify3 == true
    end





### BLOCK TESTS

  test "create genblock" do
    genesisblock = Block.genblock
    assert Enum.at(genesisblock.data,0).from == "Genesis_sender"
    assert Enum.at(genesisblock.data,0).to == "Genesis_destination"
    assert Enum.at(genesisblock.data,0).amount == 0
    assert genesisblock.index == 0
    assert genesisblock.previousHash == ""
    assert genesisblock.nonce == 0
  end

  test "create new block" do
  #prepare input
  transaction = %Transaction{from: "sender1" ,to: "sender2"  ,amount: 20, timestamp: System.system_time(:second)}
  oldblock = %Block{ index: 12,previousHash: "",timestamp: System.system_time(:second),data: [transaction],nonce: 5} |> Block.calchash
  transaction_new = %Transaction{from: "sender3" ,to: "sender4"  ,amount: 50, timestamp: System.system_time(:second)}
  # run unit
  newblock = Block.createnewblock([transaction_new],oldblock,123)
  #check success
  assert newblock.index == 13
  assert newblock.previousHash == oldblock.hash
  assert newblock.data === [transaction_new]
  assert newblock.nonce == 123
  end

  test "calculate hash" do
  #prepare input
  transaction = %Transaction{from: "sender1" ,to: "sender2"  ,amount: 20, timestamp: System.system_time(:second),signature: ""}
  transaction_new = %Transaction{from: "sender3" ,to: "sender4"  ,amount: 50, timestamp: System.system_time(:second),signature: ""}
  block = %Block{ index: 12,previousHash: "",timestamp: 0,data: [transaction,transaction_new],nonce: 5}
  trans = Enum.reduce(block.data,"",fn transaction, acc -> acc <> (transaction.from <> transaction.to <> Integer.to_string(transaction.amount) <> Integer.to_string(transaction.timestamp) <> transaction.signature) end)
  input = "12" <> "" <>  "0" <> trans <> "5"
  blockhash = :crypto.hash(:sha256,input) |> Base.encode16
  hashedblock = Map.put(block,:hash,blockhash)
  #run unit
  testhashedblock = Block.calchash(block)
  #check success
  assert testhashedblock === hashedblock
  end






end




