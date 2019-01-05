
defmodule Block_test do
    use ExUnit.Case
  
    doctest BitcoinAjitesh

    
    # setup do
    #     nodes = Worker.create_nodes(3)
    #     Wallet.wallet(nodes)
    #     sender = Enum.random(nodes)
    #   receiver = Enum.random(nodes)
    #   wa1 = Worker.getWallet(sender)
    #   wal1 = Worker.getWallet(receiver)
    #   transaction =  Transactions.createTrans(sender, receiver)
    #   amount  = transaction.amount
    #   wallet1 = Worker.getWallet(sender)
    #   wallet2 = Worker.getWallet(receiver)
    # #   IO.inspect wallet1
    #   %{wallet1: wallet1, amount: amount, wa1: wa1, wal1: wal1, wallet2: wallet2}
    # end

    test "Create blockchain" do
        blockchain = Blockchain.new
        assert Blockchain.valid?(blockchain)
    end

    test "Blockchain length" do
        block1 = Blockchain.new
        block1 = Blockchain.insert(block1, "abc")
        block1 = Blockchain.insert(block1, "msg2")
        block1 = Blockchain.insert(block1, "msg3")
        assert length(block1) == 4
      
    end

    test "Block's prev hash == prev Block current hash" do
        block1 = Blockchain.new
        block1 = Blockchain.insert(block1, "abc")
        b1 = Enum.at(block1,0)
        b2 = Enum.at(block1,1)
        assert b2.hash == b1.prev_hash
        
    end




end    

