defmodule Wallet do
  defstruct publickey: nil, privatekey: nil, balance: 100

def init(arguments) do
  create_keys()
end

def create_keys() do
  {public_key,private_key} = :crypto.generate_key(:ecdh,:secp256k1)
Base.encode16(private_key)
end

def create_keys(testPID) do
  {public_key,private_key} = :crypto.generate_key(:ecdh,:secp256k1)
  send(testPID, {:key, Base.encode16(private_key)})
  # Base.encode16(private_key)
end

def get_public_key(privkey) do

{public_key, _} = :crypto.generate_key(:ecdh, :secp256k1, privkey )
public_key|>Base.encode16
end

def signtransaction(privkey,transaction) do
  signature =:crypto.sign(:ecdsa,:sha256,Transaction.makestring(transaction),[privkey |> Base.decode16!, :secp256k1]) |> Base.encode16
                          #algorithm, #digesttype #msg #key
  transaction = Map.put(transaction,:signature,signature)
transaction
end

def verifytransaction(publickey,transaction,signature) do
verify = :crypto.verify(:ecdsa,:sha256,Transaction.makestring(transaction),signature|>Base.decode16!,[publickey |> Base.decode16!, :secp256k1])
end

def send(wallet1,wallet2,sendamount,mainblockchain) do
  mainblockchain=cond do
    wallet1.balance >= sendamount -> createtrans(wallet1,wallet2,sendamount,mainblockchain)
    true                  -> IO.puts("Not enough balance")
  end
mainblockchain
end

def createtrans(wallet1,wallet2,sendamount,mainblockchain) do
 transaction1   = %Transaction{from: wallet1.publickey ,to: wallet2.publickey  ,amount: sendamount , timestamp: System.system_time(:second)}
 transaction1   = Wallet.signtransaction(wallet1.privatekey,transaction1)
 mainblockchain = Blockchain.add_signed_but_pending(mainblockchain,transaction1)
 mainblockchain
end



def getbalance(mainblockchain,walletaddress,original_bal) do


listofblocks = mainblockchain.blockchain
size = length(listofblocks)

  transactlist = Enum.at(listofblocks,size-1).data
  balance=
  for j <- 0..length(transactlist)-1 do
    cond do
    Enum.at(transactlist,j).from === walletaddress -> Enum.at(transactlist,j).amount*-1
    Enum.at(transactlist,j).to === walletaddress -> Enum.at(transactlist,j).amount
    true -> 0
    end
  end
  bal=Enum.reduce(balance,original_bal,fn x, acc -> acc+x end)


end





def create_address(privkey) do
  {public_key, _} = :crypto.generate_key(:ecdh, :secp256k1, privkey )
  firsthash =  :crypto.hash(:sha256,public_key)
  secondhash = :crypto.hash(:ripemd160,firsthash)
  thirdhash  =  prepend_version_byte(secondhash)
  IO.inspect secondhash
  IO.inspect thirdhash
  fourthhash=  :crypto.hash(:sha256, thirdhash)
  fifthhash=  :crypto.hash(:sha256, fourthhash)
  check=  checksum(fifthhash)
  sixthhash =  thirdhash <> check
  IO.inspect sixthhash
  seventhhash = Encode.call(sixthhash)
  IO.inspect seventhhash

end





def prepend_version_byte(public_hash) do
  prepended = <<0x00>>|> Kernel.<>(public_hash)
prepended
end




    defp checksum(<<checksum::bytes-size(4), _::bits>>), do: checksum


    end




