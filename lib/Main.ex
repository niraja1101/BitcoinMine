defmodule Bitcoin do


 def hello do
 :world
 end

 def main(arguments) do

   IO.puts "Create Wallet 1"
   wallet1 = Wallet.create_wallet
   IO.inspect wallet1

   IO.puts "Create Wallet 2"
   wallet2 = Wallet.create_wallet
   IO.inspect wallet2
   
   mainblockchain =  Blockchain.createchain


  IO.puts "Create send transaction and add to blockchain pending after signing"

   IO.puts "Wallet 1 sends 70 BTC to Wallet 2"
   newblockchain = Wallet.send(wallet1,wallet2.publickey,70,mainblockchain)
   IO.puts "Wallet 2 sends 50 BTC to Wallet 1"
   newblockchain = Wallet.send(wallet2,wallet1.publickey,50,newblockchain)

   IO.puts "Chain after initial transactions initiated "
   IO.inspect newblockchain


    IO.puts "Initiate proof of work for mining new block"
    newchain= Blockchain.minepending(newblockchain,wallet1)

    IO.puts "Chain after mining a new block"

    IO.inspect newchain

    IO.puts "Is blockchain authentic: "
    IO.inspect Blockchain.checkblockchain(newchain)


    IO.puts "The change in wallet balance as a result of the transactions"


     newbal=Wallet.getbal(newchain,wallet1.publickey)
     wallet1=Map.put(wallet1,:balance,newbal)
     newbal2=Wallet.getbal(newchain,wallet2.publickey)
     wallet2=Map.put(wallet2,:balance,newbal2)

    IO.puts "New Wallet1"
    IO.inspect wallet1
    IO.inspect "New Wallet2"
    IO.inspect wallet2








 end



end
