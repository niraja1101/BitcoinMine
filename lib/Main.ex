defmodule Bitcoin do

 def hello do
 :world
 end

 def main(arguments) do
   privatekey_1 = Wallet.create_keys
   #IO.inspect privatekey_1
   wallet_addr1 = Wallet.get_public_key(privatekey_1 |> Base.decode16!)
   #IO.inspect wallet_addr1

   wallet1 = %Wallet{publickey: wallet_addr1, privatekey: privatekey_1}

    IO.inspect wallet1


    privatekey_2 = Wallet.create_keys
  #  IO.inspect privatekey_2  |> Base.encode16
    wallet_addr2 = Wallet.get_public_key(privatekey_2 |> Base.decode16!)
  #  IO.inspect wallet_addr2  |> Base.encode16

   wallet2 = %Wallet{publickey: wallet_addr2, privatekey: privatekey_2}
   IO.inspect wallet2
   mainblockchain = %Blockchain{blockchain: Blockchain.createchain, difficulty: 2, pending: [], reward: 100}


  #  IO.inspect Wallet.getbalance(mainblockchain,wallet1.publickey)
  #  IO.inspect Wallet.getbalance(mainblockchain,wallet2.publickey)

  #  transaction1 = %Transaction{from: wallet1.publickey ,to: wallet2.publickey  ,amount: 20, timestamp: System.system_time(:second)}
  #  transaction1 = Wallet.signtransaction(privatekey_1  ,transaction1)
  #  verify = Wallet.verifytransaction(wallet1.publickey,transaction1,transaction1.signature)
  #  IO.puts "First"
  #  IO.inspect verify
  #  IO.inspect transaction1

  IO.puts "Create send transaction and add to blockchain pending after signing"

   newblockchain = Wallet.send(wallet1,wallet2,20,mainblockchain)
   IO.puts "NEW chain *************************"
   IO.inspect newblockchain

   #First transact + rewarding transact

   newchain= Blockchain.minepending(newblockchain,wallet1)
   newbal=Wallet.getbalance(newchain,wallet1.publickey,wallet1.balance)
   wallet1=Map.put(wallet1,:balance,newbal)
   newbal2=Wallet.getbalance(newchain,wallet2.publickey,wallet2.balance)
   wallet2=Map.put(wallet2,:balance,newbal2)
   IO.puts "New WAllet1"
   IO.inspect wallet1
   IO.inspect "New Wallet2"
   IO.inspect wallet2


   newblockchain = Wallet.send(wallet2,wallet1,50,newchain)
   IO.puts "NEW chain *************************"
   IO.inspect newblockchain
   newchain= Blockchain.minepending(newblockchain,wallet2)
   newbal=Wallet.getbalance(newchain,wallet1.publickey,wallet1.balance)
   wallet1=Map.put(wallet1,:balance,newbal)
   newbal2=Wallet.getbalance(newchain,wallet2.publickey,wallet2.balance)
   wallet2=Map.put(wallet2,:balance,newbal2)
   IO.puts "New WAllet1_test2"
   IO.inspect wallet1
   IO.inspect "New Wallet2_test2"
   IO.inspect wallet2

   IO.puts "New chain"
   IO.inspect newchain


  #  mainblockchain = Blockchain.add_signed_but_pending(mainblockchain,transaction1)

  #  :timer.sleep(1000)



  #  mainblockchain = Blockchain.minepending(mainblockchain,wallet1.publickey,wallet1.privatekey)


  #  IO.inspect Wallet.getbalance(mainblockchain,wallet1.publickey)
  #  IO.inspect Wallet.getbalance(mainblockchain,wallet2.publickey)

  # :timer.sleep(2000)

  # mainblockchain = Blockchain.minepending(mainblockchain,wallet_addr1)

  # :timer.sleep(1000)

  # balance=Wallet.getbalance(mainblockchain,wallet_addr1)
  # IO.puts "The wallet balance for #{wallet_addr1} is @@@@@@@@@@@@@@@@@@@ #{balance}"



 end



end
