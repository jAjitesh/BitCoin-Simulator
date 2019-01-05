
defmodule Wallet_test do
    use ExUnit.Case
  
    doctest BitcoinAjitesh

setup do
    users = Worker.create_nodes(3)
    Wallet.wallet(users)
    randUser = Enum.random(users)
    wallet = Worker.getWallet(randUser)
    %{wallet: wallet}
end

test "initial coinbase transaction", %{wallet: wallet} do
    assert wallet.balance == 100
    
end


    test "verify sign" do
        priv = Wallet.generate_priv()
        pub = Wallet.generate_pub(priv)
        sign = Transactions.signature("heyy", priv)
        verify = Transactions.verify(pub, sign, "heyy")
        assert verify
    end

    test "verify false sign" do
        priv = Wallet.generate_priv()
        pub = Wallet.generate_pub(priv)
        sign = Transactions.signature("heyy", priv)
        verify = Transactions.verify(pub, sign, "heyy1")
        assert verify == false
    end

    
end    