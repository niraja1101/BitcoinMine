defmodule MinerTest do

  use ExUnit.Case

  doctest Bitcoin

  test "check_key_base16" do
    privatekey = Wallet.create_keys
    assert IO.puts privatekey
  end

  test "create_wallet" do
   privatekey_1 = Wallet.create_keys
   wallet_addr1 = Wallet.get_public_key(privatekey_1 |> Base.decode16!)
   wallet1 = %Wallet{publickey: wallet_addr1, privatekey: privatekey_1}

   privatekey_2 = Wallet.create_keys
   wallet_addr2 = Wallet.get_public_key(privatekey_2 |> Base.decode16!)
   wallet2 = %Wallet{publickey: wallet_addr2, privatekey: privatekey_2}
  end



end
