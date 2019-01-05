defmodule Mining_test do
    use ExUnit.Case
  
    doctest BitcoinAjitesh

   
    test "Checking the block with 1 difficulty" do
    nodes = Worker.create_nodes(5)
    genesisBlock = Block.create_block
    Worker.updateChainInNodes(nodes, genesisBlock)
    Wallet.wallet(nodes)
    Enum.each(1..20, fn x ->
      sender = Enum.random(nodes)
      receiver = Enum.random(nodes)
      transaction =  Transactions.createTrans(sender, receiver) 
      Transactions.check(sender, transaction)
      chain = Worker.getChain(sender)
      new_chain = Worker.addBlock(chain, 20,x)
      Blockchain.addTransToNode(nodes, new_chain, transaction)
      Enum.each(nodes, fn x->
          GenServer.cast(x, {:mining})
      end)
    end)
    sample = Enum.random(nodes)
    chain = Worker.getChain(sample)
    # IO.inspect chain
    target = String.duplicate("0", 1)
    block = Enum.at(chain, 0)
    # IO.inspect block
    hash = block.hash
    # IO.inspect hash
    str = String.slice(hash,0, 1)

    assert target == str
    end

    test "Checking the block with 2 difficulty" do
        nodes = Worker.create_nodes(5)
        genesisBlock = Block.create_block
        Worker.updateChainInNodes(nodes, genesisBlock)
        Wallet.wallet(nodes)
        Enum.each(1..20, fn x ->
          sender = Enum.random(nodes)
          receiver = Enum.random(nodes)
          transaction =  Transactions.createTrans(sender, receiver) 
          Transactions.check(sender, transaction)
          chain = Worker.getChain(sender)
          new_chain = Worker.addBlock(chain, 20,x)
          Blockchain.addTransToNode(nodes, new_chain, transaction)
          Enum.each(nodes, fn x->
              GenServer.cast(x, {:mining})
          end)
        end)
        sample = Enum.random(nodes)
        chain = Worker.getChain(sample)
        # IO.inspect chain
        target = String.duplicate("0", 2)
        block = Enum.at(chain, 0)
        # IO.inspect block
        hash = block.hash
        # IO.inspect hash
        str = String.slice(hash,0, 2)
    
        assert target == str
        end

        test "Checking the block with 3 difficulty" do
            nodes = Worker.create_nodes(5)
            genesisBlock = Block.create_block
            Worker.updateChainInNodes(nodes, genesisBlock)
            Wallet.wallet(nodes)
            Enum.each(1..20, fn x ->
              sender = Enum.random(nodes)
              receiver = Enum.random(nodes)
              transaction =  Transactions.createTrans(sender, receiver) 
              Transactions.check(sender, transaction)
              chain = Worker.getChain(sender)
              new_chain = Worker.addBlock(chain, 20,x)
              Blockchain.addTransToNode(nodes, new_chain, transaction)
              Enum.each(nodes, fn x->
                  GenServer.cast(x, {:mining})
              end)
            end)
            sample = Enum.random(nodes)
            chain = Worker.getChain(sample)
            # IO.inspect chain
            target = String.duplicate("0", 3)
            block = Enum.at(chain, 0)
            # IO.inspect block
            hash = block.hash
            # IO.inspect hash
            str = String.slice(hash,0, 3)
        
            assert target == str
            end

            test "Checking the block with 4 difficulty" do
                nodes = Worker.create_nodes(5)
                genesisBlock = Block.create_block
                Worker.updateChainInNodes(nodes, genesisBlock)
                Wallet.wallet(nodes)
                Enum.each(1..20, fn x ->
                  sender = Enum.random(nodes)
                  receiver = Enum.random(nodes)
                  transaction =  Transactions.createTrans(sender, receiver) 
                  Transactions.check(sender, transaction)
                  chain = Worker.getChain(sender)
                  new_chain = Worker.addBlock(chain, 20,x)
                  Blockchain.addTransToNode(nodes, new_chain, transaction)
                  Enum.each(nodes, fn x->
                      GenServer.cast(x, {:mining})
                  end)
                end)
                sample = Enum.random(nodes)
                chain = Worker.getChain(sample)
                # IO.inspect chain
                target = String.duplicate("0", 4)
                block = Enum.at(chain, 0)
                # IO.inspect block
                hash = block.hash
                # IO.inspect hash
                str = String.slice(hash,0, 4)
            
                assert target == str
                end

end