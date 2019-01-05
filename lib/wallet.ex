defmodule Wallet do
  
  @upperLimit :binary.decode_unsigned(<<
          0xFF,
          0xFF,
          0xFF,
          0xFF,
          0xFF,
          0xFF,
          0xFF,
          0xFF,
          0xFF,
          0xFF,
          0xFF,
          0xFF,
          0xFF,
          0xFF,
          0xFF,
          0xFE,
          0xBA,
          0xAE,
          0xDC,
          0xE6,
          0xAF,
          0x48,
          0xA0,
          0x3B,
          0xBF,
          0xD2,
          0x5E,
          0x8C,
          0xD0,
          0x36,
          0x41,
          0x41
        >>)
  
  defstruct [:public_key, :private_key, :balance, :transactions]

  def createWallet() do
    %Wallet{
      balance: 100,
      transactions: [],
    }
  end

  def put_key(%{} = wallet) do
    {:ok, {priv, pub}} = RsaEx.generate_keypair
    %{wallet| public_key: pub, private_key: priv}
  end

  def generate_priv()do
    {:ok, priv} = RsaEx.generate_private_key
    priv
  end
  #flag == 0 sender, flag == 1 reeciver

  def generate_pub(priv)do
    {:ok, pub} = RsaEx.generate_public_key(priv)
    pub
  end

  defp hash(data, algorithm)
    
    def createPublicHash(pubKeyBin) do
     tempHash=:crypto.hash(:sha256, pubKeyBin);
     finalHash=:crypto.hash(:ripemd160, tempHash);
     finalHash;
    end
    
    
    def generatePrivKey(pid) do
     privKey=:crypto.strong_rand_bytes(32);
     case validPrivKey(privKey) do
       true->privKey;
       false->generatePrivKey(pid);
     end
    
    end
    def getRcvr(senderId, numNodes) do
      rcvrId=:rand.uniform(numNodes);
      result=if(senderId==rcvrId) do
          getRcvr(senderId, numNodes);
      else
          rcvrId;
      end
      result;
  end
    defp validPrivKey(privKey) when is_binary(privKey) do  
     privKey|> :binary.decode_unsigned |>validPrivKey;
    end
    
    defp validPrivKey(privKey) when privKey>1 and privKey<@upperLimit, do: true;
    
    defp validPrivKey(privKey), do: false;

    def printVals do
      str=%Wallet{};
      str=Map.put(str, :name, "jane");
      str=Map.put(str, :name2, "jane2");
     #  IO.inspect(str.name);
    end

    def generatePubKey(privKey)do
     :crypto.generate_key(:ecdh, :crypto.ec_curve(:secp256k1), privKey) |> elem(0);
    end
    def wallet(numNodes) do
      Enum.each(numNodes, fn x ->
        wallet = Wallet.createWallet()
        wallet = Wallet.put_key(wallet)
        Worker.updateWallet(x, wallet)
      end)
    end
    def updateTransInWallet(pid,%{} = wallet, %{} = trans, f,amount) do
      curr_trans = wallet.transactions
      balance = wallet.balance
      trans = %{trans | flag: f}
      # IO.inspect trans
      final = curr_trans ++ [trans]
      w1 = %{wallet | transactions: final, balance: balance + amount}
      Worker.updateWallet(pid, w1)
    end
    def update_balance(pid, amount)do
      GenServer.cast(pid, {:update_balance, amount})
    end
    def handle_cast({:update_balance, amount}, state) do
      {%{}=a,b} = state
      final = a.balance+amount
      wallet = %{a | balance: final }
      new_state = {wallet,b}
      {:noreply, new_state}
    end
end


