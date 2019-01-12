defmodule Blockchain do

  defstruct blockchain: nil ,difficulty: 2, pending: [], reward: 100

  #initialize a new chain with only genesis block
  def createchain do
  newchain = %Blockchain{blockchain: [Block.genblock], difficulty: 2, pending: [], reward: 100}
  newchain
  end

  #verify signed transaction and add to the list of pending transactions in the blockchain
  def add_signed_but_pending(blockchain,transaction) do
      newlist    = List.insert_at(blockchain.pending, -1, transaction)
      blockchain = Map.put(blockchain,:pending,newlist)
  blockchain
  end

  # get the latest block in the blockchain
  def getlatestblock(chain) do
    lastblock = List.last(chain.blockchain)
  lastblock
  end

  # add a newly generated block to the blockchain
  def addblock(mainblockchain,newblock) do
    newlist = List.insert_at(mainblockchain.blockchain, -1, newblock)
    blockchain = Map.put(mainblockchain,:blockchain,newlist)
  blockchain
  end

  # add a rewarding transaction for mining, create new block with all the pending transactions and add the new block to the blockchain
  def minepending(mainblockchain,wallet) do
    transaction = %Transaction{from: "" ,to: wallet.publickey ,amount: mainblockchain.reward, timestamp: System.system_time(:second)}
    transaction = Wallet.signtransaction(wallet.privatekey,transaction)
    newchain = add_signed_but_pending(mainblockchain,transaction)
    newvalidblock=mineblock(newchain,0)
    updatedchain = addblock(newchain,newvalidblock)
    latestchain = Map.put(updatedchain,:pending,[])
  latestchain
  end

# perform computations for proof of work
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




#check if the blockchain is valid, i.e. valid genesis block, valid hash for each block
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
  end
  true
end



end

#Enum.at(Map.get(Enum.at(mainblockchain.blockchain,i), :data),j).signature)
