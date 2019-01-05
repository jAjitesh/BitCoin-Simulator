defmodule Transactions do
  defstruct [:id, :pk_sender, :pk_receiver, :money, :flag, :signature]

  def createTransaction(sender, receiver, money) do
    %Transactions{
      id: sha256_string("#{sender}#{receiver}#{money}"),
      pk_sender: sender,
      pk_receiver: receiver,
      flag: 0,
      money: money,
    }
  end
  def check(sender, trans) do
    message = trans.id
    senderWallet = Worker.getWallet(sender)
    sign = trans.signature
    sender_pub_key = senderWallet.public_key
    if(!Transactions.verify(sender_pub_key, sign, message)) do
      IO.puts "Invalid transaction detected!!!"
      remove(trans, sender)
    end
  end
  def remove(trans, sender) do
    senderWallet = Worker.getWallet(sender)
    s_trans = senderWallet.transactions
    [head|tail] = Enum.reverse(s_trans)
    s_trans = tail
    Worker.update_trans(sender,s_trans)
  end
  def createTrans(sender, receiver) do
    senderWallet = Worker.getWallet(sender)
    receiverWallet = Worker.getWallet(receiver)
    sender_pub_key = senderWallet.public_key
    receiver_pub_key = receiverWallet.public_key
    money = :rand.uniform(99)
    sender_amt = -money
    receiver_amt = money
    trans = Transactions.createTransaction(sender_pub_key, receiver_pub_key, money)
    secret_key = Transactions.signature(trans.id, senderWallet.private_key)
    trans = Transactions.updateSignature(trans,secret_key)
    if(senderWallet.balance < money) do
      # IO.puts "The money #{money} cant be sent as you only have #{senderWallet.balance}"
    else
      Wallet.updateTransInWallet(sender,senderWallet,trans,0,sender_amt)
      Wallet.updateTransInWallet(receiver,receiverWallet,trans,1,receiver_amt)
    end
    trans
  end
  def sha256_string(string) do
    :crypto.hash(:sha256, string) |> Base.encode16
  end


  # def makeTransactions(numNodes, pidList, transactions, pidMappings, blockSize, difficulty) do
  #   Enum.each((1..transactions), fn(num)->
  #       senderId=:rand.uniform(numNodes);
  #       # rcvrId=getRcvr(senderId, numNodes);
  #       # IO.puts("senderId: #{senderId}");
  #       # IO.puts("rcvrId: #{rcvrId}");
  #       # senderPid=Map.get(pidMappings, senderId);
  #       # rcvrPid=Map.get(pidMappings, rcvrId);
  #       # IO.inspect(senderPid);
  #       # IO.inspect(rcvrPid);
  #       # senderState=GenServer.call(senderPid, :get_state);
  #       # rcvrState=GenServer.call(rcvrPid, :get_state);
  #       # rcvrPubKey=senderState.pubKey;
  #       # senderPubKey=rcvrState.pubKey;
  #       # senderPrivKey=senderState.privKey;
  #       # senderMoney=senderState.money;
  #       # randomMoney=:rand.uniform(senderMoney)-1;
  #       # transObject=Transaction.createTransaction(senderId, rcvrId, randomMoney, senderPubKey, rcvrPubKey);
  #       # sign=Transaction.signTransaction(transObject.transactionHash, senderPrivKey);
  #       # # IO.inspect(sign);
  #       # verify=Transaction.verifyTransaction(rcvrPubKey, sign, transObject.transactionHash);
  #       # Enum.each((1.. numNodes),fn(num)-> 
  #       #     GenServer.cast(Map.get(pidMappings, num-1), {:writeTransaction, transObject});
  #       # end)
  #       # senderState=%{senderState| money: senderState.money-randomMoney};
  #       # rcvrState=%{rcvrState| money: rcvrState.money+randomMoney};
  #       # rcvrState.money=rcvrState.money-randomMoney;
  #       # GenServer.cast(rcvrPid,{:set_state, rcvrState});
  #       # GenServer.cast(senderPid, {:set_state, senderState});
  #       # if(rem(num,blockSize) == 0) do
  #       #     Enum.each((1..numNodes), fn(num)->
  #       #         if(rem(num,3) == 0) do
  #       #             currPid=Map.get(pidMappings, num);
  #       #             state=GenServer.call(currPid, :get_state);
  #       #             # GenServer.cast(currPid,{:calcNonce, currPid, difficulty});
  #       #             Mining.calculateNonce(state, difficulty);
  #       #         end
  #       #     end)
  #           # Mining.calcNonce();
  #           # GenServer.cast(rcvrPid, :mergeBlock);
  #           # GenServer.cast(senderPid, :mergeBlock);
  #       end

  #   end)

# end
  def updateSignature(%{} = tx,sign) do
    %{tx | signature: sign}
  end

  def signature(message, private_key) do
    {:ok, sign} = RsaEx.sign(message, private_key)
    sign
  end
  def verify(public_key, signature, message) do
    {:ok, valid} = RsaEx.verify(message, signature, public_key)
    valid
  end

end

