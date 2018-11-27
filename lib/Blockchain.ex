defmodule Blockchain do

  defstruct blockchain: nil ,difficulty: 2, pending: [], reward: 100

  def createchain do
    newchain=[Block.genblock]
  newchain
  end

  def add_signed_but_pending(blockchain,transaction) do
    if(transaction.from == "") do
      verify = Wallet.verifytransaction(transaction.to,transaction,transaction.signature)
    else
      verify = Wallet.verifytransaction(transaction.from,transaction,transaction.signature)
    end
    newlist = List.insert_at(blockchain.pending, -1, transaction)
    blockchain = Map.put(blockchain,:pending,newlist)
    blockchain
  end

  def getlatestblock(chain) do
    lastblock = List.last(chain.blockchain)
  lastblock
  end

  def addblock(mainblockchain,newblock) do
    newlist = List.insert_at(mainblockchain.blockchain, -1, newblock)
    blockchain = Map.put(mainblockchain,:blockchain,newlist)
  blockchain
  end

  def minepending(mainblockchain,wallet) do
    transaction = %Transaction{from: "" ,to: wallet.publickey ,amount: mainblockchain.reward, timestamp: System.system_time(:second)}
    transaction = Wallet.signtransaction(wallet.privatekey,transaction)
    newchain = add_signed_but_pending(mainblockchain,transaction)
    newvalidblock=mineblock(newchain,0)
    updatedchain = addblock(newchain,newvalidblock)
    latestchain = Map.put(updatedchain,:pending,[])
  latestchain
  end






  def mineblock(newchain,nonce) do
    latest_block = getlatestblock(newchain)
    newblock = Block.createnewblock(newchain.pending,latest_block,nonce)
    numz_len = String.duplicate("0",newchain.difficulty)
    numz_hashed_data = String.slice(newblock.hash,0,newchain.difficulty)
    return = cond do
      numz_hashed_data === numz_len -> newblock
      true -> mineblock(newchain,nonce+1)
    end
  return
  end





def checkblockchain(mainblockchain) do
  if((Enum.at(Map.get(Enum.at(mainblockchain.blockchain,0), :data),0).from) === "Genesis_sender") do
    false
  end
  for i <- 1..(length(mainblockchain.blockchain)-1) do
    if (!(Map.get(Enum.at(mainblockchain.blockchain,i), :hash)) === Block.calchash(Enum.at(mainblockchain.blockchain,i))) do
       false
    end
    if (!(Map.get(Enum.at(mainblockchain.blockchain,i), :previoushash)) === Block.calchash(Enum.at(mainblockchain.blockchain,i-1))) do
      false
    end
    for j <- 0..length(Map.get(Enum.at(mainblockchain.blockchain,i), :data))-1 do
      if(!Wallet.verifytransaction(Enum.at(Map.get(Enum.at(mainblockchain.blockchain,i), :data),j).to,Enum.at(Map.get(Enum.at(mainblockchain.blockchain,i), :data),j),Enum.at(Map.get(Enum.at(mainblockchain.blockchain,i), :data),j).signature)) do
        false
      end
    end

  end
  true
end



end
