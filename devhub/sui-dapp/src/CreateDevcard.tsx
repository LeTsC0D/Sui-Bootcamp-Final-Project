// import logo from './logo.svg';
// import './App.css';
// import { getFullnodeUrl, SuiClient } from '@mysten/sui.js/client';
import { TransactionBlock } from '@mysten/sui.js/transactions';
// import { useWalletKit } from '@mysten/wallet-kit';
import { useSuiClient, useSignAndExecuteTransactionBlock} from '@mysten/dapp-kit';
import { useEffect } from 'react';

type parameterType = {
  setDevStatus: (status:boolean) => void;
  devstatus:boolean
};

function CreateDevcard({setDevStatus,devstatus}:parameterType) {
  const { mutate: signAndExecute } = useSignAndExecuteTransactionBlock();
  const suiClient = useSuiClient();
  const tx = new TransactionBlock();
  const devhub = tx.object("0xeb694d2cf8240f2d2d554fb804428f306d85176fd5eb0fd3422f276abbb71f8d")
  
  useEffect(()=>{
    // setDevStatus(false)
    try {
      // const [coin] = tx.splitCoins(tx.gas, [1]) // define payment coin
      // Calls the create_card function from the devcard package
      tx.moveCall({
      target: "0xeb694d2cf8240f2d2d554fb804428f306d85176fd5eb0fd3422f276abbb71f8d::devcard::create_card",
      arguments: [
        tx.pure.string('Matt Patt'), // name
        tx.pure.string('Frontend Developer'), // title
        tx.pure.string(
        'https://example_url.png',
        ), // img_url 
        tx.pure.u8(3), // years_of_experience
        tx.pure.string('JavaScript, Typescript, Next.js, Node.js'), // technologies
        tx.pure.string('https://mattpatt.dev'), // portfolio
        tx.pure.string('matt.patt@dev.com'), // contact
        devhub, // devhub obj
      ],
      });
    signAndExecute(
      {
        transactionBlock: tx,
        options: {
          showEffects: true,
        },
      },
      {
        onSuccess: (tx) => {
          console.log("success",tx)
          suiClient
            .waitForTransactionBlock({
              digest: tx.digest,
            })
            .then(() => {
              const objectId = tx.effects?.created?.[0]?.reference?.objectId;
              console.log("created devcard",objectId)
            });
        },
        onError: (err) => {
          console.log("error",err.message);
          },        
      },
    );
    } catch (error) {
      // Handle the error
      console.error("error",error);
    }  
    // setDevStatus(false)
    // ()=>{
    //   setDevStatus(false)
    // }
  },[devstatus])


return(

  <div>

  </div>
)
}

export default CreateDevcard;