defmodule Blockchain_test do
    use ExUnit.Case
  
    doctest BitcoinAjitesh

    setup do
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
    %{chain: chain}
    end

test "Checking the blockchain length for 20 transactions with 9 in each block", %{chain: chain} do
    assert length(chain) == 3
end

end