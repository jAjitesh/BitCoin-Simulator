defmodule Blockchain do
  use GenServer
  @doc "Create a new blockchain with a first block"
  def new do
    [put_hash(Block.genesis)]
  end
  @hash_fields [:id, :prev_hash, :transactions, :magic_num]
  def hash(%{} = block) do
    id = block.id
    prev_hash = block.prev_hash
    magic_num = block.magic_num
    message = Block.cal_message(id, prev_hash, magic_num)
    find_hash(message)
  end

  def find_hash(message) do
    :crypto.hash(:sha256, message) |> Base.encode16 |> String.downcase
  end
  def cal_message(id, prev_hash, magic_num) do
    message = "#{id}#{prev_hash}#{magic_num}"
  end
  def insert(blockchain, data) when is_list(blockchain) do
    %Block{hash: prev} = hd(blockchain)
    block =
      data
      |> Block.new(prev)
      |> put_hash
    [ block | blockchain ]
  end

  def put_hash(%{} = block) do
    %{ block | hash: hash(block) }
  end

  @doc "Validate the complete blockchain"
  def valid?(blockchain) when is_list(blockchain) do
    zero = Enum.reduce_while(blockchain, nil, fn prev, current ->
      cond do
        current == nil ->
          {:cont, prev}

        Block.valid?(current, prev) ->
          {:cont, prev}

        true ->
          {:halt, false}
      end
    end)

    if zero, do: Block.valid?(zero), else: false
  end
  
  def addTransToNode(nodes, chain, t1)do
    [%{} = head | tail] = chain
    transactions = head.transactions
    y = transactions ++ [t1]
    b = %{head | transactions: y}
    chain = [b | tail]
    Worker.updateChain(nodes, chain)
  end
end
