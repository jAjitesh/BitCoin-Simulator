defmodule Helper do

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
    
    defp validPrivKey(privKey) when is_binary(privKey) do                                               #Converts 32 bytes to unsigned integer.
     privKey|> :binary.decode_unsigned |>validPrivKey;
    end
    
    defp validPrivKey(privKey) when privKey>1 and privKey<@upperLimit, do: true;
    
    defp validPrivKey(privKey), do: false;
    
    def generatePubKey(privKey)do
     :crypto.generate_key(:ecdh, :crypto.ec_curve(:secp256k1), privKey) |> elem(0);
    end
end