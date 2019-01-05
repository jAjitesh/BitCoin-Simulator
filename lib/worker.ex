defmodule Worker do
  use GenServer
  def main(numNodes, trans) do
    nodes = create_nodes(numNodes)
    genesisBlock = Block.create_block
    updateChainInNodes(nodes, genesisBlock)
    Wallet.wallet(nodes)
    Enum.each(1..trans, fn x ->
      sender = Enum.random(nodes)
      receiver = Enum.random(nodes)
      transaction =  Transactions.createTrans(sender, receiver) 
      Transactions.check(sender, transaction)
      chain = getChain(sender)
      new_chain = addBlock(chain, trans,x)
      Blockchain.addTransToNode(nodes, new_chain, transaction)
      Enum.each(nodes, fn x->
          GenServer.cast(x, {:mining})
      end)
    end)
    sample = Enum.random(nodes)
    c = getChain(sample)
    IO.inspect c
    Enum.each(nodes, fn x->
      w1 = getWallet(x)
      # w1 = Wallet.update_balance(w1)
      IO.inspect w1
    end)
  end



  def addBlock(chain, trans, x)do
    if(rem(x,10) == 0) do
      message_num = :random.uniform(trans)
      chain = Blockchain.insert(chain,  "message #{message_num}")
    else
      chain
    end
  end
  def updateChainInNodes(nodes, chain) do
    Enum.each(nodes, fn (x) ->
      GenServer.cast(x, {:updateChainInNodes,chain})
    end)
  end
  
  def handle_cast({:updateChainInNodes, chain}, state) do
    {wallet,blockchain} = state
    new_state = {wallet, chain}
    {:noreply, new_state}
  end
  def updateWallet(pid,wallet) do
    GenServer.cast(pid, {:updateWallet,wallet})
  end
  def handle_cast({:updateWallet,w}, state) do
      {wallet, chain} = state
      new_state = {w,chain}
      {:noreply, new_state}
  end
  def getWallet(pid) do
    GenServer.call(pid, {:getWallet})
  end
  def handle_call({:getWallet}, __from, state) do
    {wallet,blockchain} = state
    {:reply, wallet, state}
  end
  def update_trans(pid, trans) do
    GenServer.cast(pid, {:update_trans, trans})
  end
  def handle_cast({:update_trans, trans}, state) do
    {%{}=wallet,blockchain} = state
    final = %{wallet | transactions: trans}
    new_state = {wallet,final}
    {:noreply, new_state}
  end
  def handle_cast({:mining}, state) do
    {wallet,blockchain} = state
    [chain | tail] = blockchain
    current = chain
    mine_block = Block.mine(current, 4)
    # IO.inspect mine_block
    final = [mine_block | tail]
    # IO.inspect final
    new_state = {wallet,final}
    {:noreply, new_state}
  end
  def updateChain(nodes, chain) do
    Enum.each(nodes, fn(x) ->
      GenServer.call(x, {:updateChain,chain})
    end)
  end
  def handle_call({:updateChain, chain}, __from, state) do
    {wallet,blockchain} = state
    new_state = {wallet, chain}
    {:reply, blockchain, new_state}
  end
  def getChain(pid) do
    GenServer.call(pid, {:getChain})
  end
  def handle_call({:getChain}, __from, state) do
    {wallet,blockchain} = state
    {:reply, blockchain, state}
  end
  
  def update_block(%{} = block, curr_trans) do
    new_trans = block.transactions
      final = new_trans ++ [curr_trans]
      %{block | transactions: final}
  end
  def create_nodes(numNodes) do
    Enum.map((1..numNodes),fn(x) ->
        pid = start_node()
        pid
    end)
  end
  def start_node() do
      {:ok,pid} = GenServer.start_link(__MODULE__, :ok, [])
      pid
  end
  def init(:ok) do
      {:ok, {0,[]}}
  end
end

# Worker.main(5,6)
