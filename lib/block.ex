defmodule Block do
  defstruct [:id, :prev_hash, :hash, :transactions, :magic_num]

  @hash_fields [:id, :prev_hash, :transactions, :magic_num]
  def hash(%{} = block) do
    id = block.id
    prev_hash = block.prev_hash
    magic_num = block.magic_num
    message = Block.cal_message(id, prev_hash, magic_num)
    find_hash(message)
  end
  def create_block do
    block = Blockchain.new
    block
  end
  def find_hash(message) do
    :crypto.hash(:sha256, message) |> Base.encode16 |> String.downcase
  end
  def cal_message(id, prev_hash, magic_num) do
    message = "#{id}#{prev_hash}#{magic_num}"
  end

  def new(data, prev_hash) do
    %Block{
      id: data,
      prev_hash: prev_hash,
      magic_num: "qwert",
      transactions: [],
    }
  end

  def update_hash(%{} = block) do
    %{ block | hash: hash(block)}
  end

  @doc "Build the initial block of the chain"
  def genesis do
    %Block{
      id: "gensisblock",
      prev_hash: "genesishash",
      magic_num: "abcde",
      transactions: [],
    }
  end

  def update_magic_num(%{} = block, magic_num) do
    %{ block | magic_num: magic_num}
  end
  # .@flag true;
  def mine(%{} = block, difficulty) do
    target = String.duplicate("0", difficulty)
    temp = block.hash
    str = String.slice(temp,0, difficulty)
    y = randomizer(9)
    block_1 = update_magic_num(block, y)
    b1 = update_hash(block_1)
    if(target === str) do
      b1 = update_magic_num(block, y)
      b1
    else
      mine(b1, difficulty)
    end
  end

  def calculateNonce(state, consecZeros) do
    target=String.duplicate("0", consecZeros);
    block=state.currBlock;
    blockStr=inspect(block);
    # IO.inspect(blockStr);
    blockHash=:crypto.hash(:sha256, blockStr) |> Base.encode16 |> String.downcase;
    IO.puts("Block hash");
    IO.inspect(blockHash);
    
    # mine(state, block, blockHash, consecZeros);
  end


  def randomizer(l) do
    :crypto.strong_rand_bytes(l) |> Base.url_encode64 |> binary_part(0, l) |> String.downcase
  end

  def add_transaction(%{} = block, transaction) do
    y = block.transactions
    d = y ++ [transaction]
    %{ block | transactions: d}
  end

  def valid?(%Block{} = block) do
    hash(block) == block.hash
  end

  def valid?(%Block{} = block, %Block{} = prev_block) do
    (block.prev_hash == prev_block.hash) && valid?(block)
  end
  def getBlock(pid) do
    GenServer.call(pid, {:getBlock})
  end
  def handle_call({:getBlock}, __from, state) do
    {a,b} = state
    block =  Enum.at(b, -1)
    {:reply, block, state}
  end
end
