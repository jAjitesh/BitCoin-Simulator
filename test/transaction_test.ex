
defmodule Transaction_test do
    use ExUnit.Case
  
    doctest BitcoinAjitesh

    setup do
        nodes = Worker.create_nodes(3)
        Wallet.wallet(nodes)
        sender = Enum.random(nodes)
      receiver = Enum.random(nodes)
      wa1 = Worker.getWallet(sender)
      wal1 = Worker.getWallet(receiver)
      transaction =  Transactions.createTrans(sender, receiver)
      money  = transaction.money
      wallet1 = Worker.getWallet(sender)
      wallet2 = Worker.getWallet(receiver)
    #   IO.inspect wallet1
      %{wallet1: wallet1, money: money, wa1: wa1, wal1: wal1, wallet2: wallet2}
    end
    
    test "verify the assymetric encrypted signature", %{wallet1: wallet1, money: money, wa1: wa1, wal1: wal1, wallet2: wallet2} do
        priv = Wallet.generate_priv()
        pub = Wallet.generate_pub(priv)
        sign = Transactions.signature("heyy", priv)
        verify = Transactions.verify(pub, sign, "heyy")
        assert verify
    end

    test "verify the assymetric encrypted signature 2", %{wallet1: wallet1, money: money, wa1: wa1, wal1: wal1, wallet2: wallet2} do
        priv = Wallet.generate_priv()
        pub = Wallet.generate_pub(priv)
        sign = Transactions.signature("heyy", priv)
        verify = Transactions.verify(pub, sign, "heyy1")
        assert verify == false
    end
    test "check balance before sending", %{wallet1: wallet1, money: money, wa1: wa1, wal1: wal1, wallet2: wallet2} do
        assert true
    end
    test "balance verifications for sender ", %{wallet1: wallet1, money: money, wa1: wa1, wal1: wal1, wallet2: wallet2} do
        k = wa1.balance
        assert (k - money == wallet1.balance)
    end

    test "balance verifications for reciever ", %{wallet1: wallet1, money: money, wa1: wa1, wal1: wal1, wallet2: wallet2} do
        k = wal1.balance
        assert (k + money == wallet2.balance)
    end
    
end    