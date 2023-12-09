import React from 'react'
import { useSignAndExecuteTransactionBlock, useSuiClient } from '@mysten/dapp-kit';
import { TransactionBlock } from '@mysten/sui.js/transactions';

import { UDEMYHUB_PACKAGE_ID } from './constants';
const BET_AMOUNT = "20000";
function CreateCategory() {
  const suiClient = useSuiClient();
  const { mutate: signAndExecute } = useSignAndExecuteTransactionBlock();
  return (
      <div>
          <button
              onClick={() => {
                  create();
              }}
          >
              Create Category
          </button>
      </div>
  );

  function create() {
    const txb = new TransactionBlock();
    const udemyhub = txb.object("0x411716059ff5f57ea977cd14557d3e9594f5a4259b8da1d60f66f7ffa6d72425")
    const coursehub = txb.object("0x3736da3ee17b05aa76b9e265655fba29d7f7bcba936382c0d0311b79a1b70d14")
    let coin = txb.splitCoins(txb.gas, [txb.pure(Number(BET_AMOUNT))]);
    txb.moveCall({
        arguments: [
          txb.pure.string('Matt Patt'), // name
          txb.pure.string('Frontend Developer'), // title
          txb.pure.string(
           'https://example_url.png',
          ), // img_url 
          txb.pure.string('JavaScript, Typescript, Next.js, Node.js'), // technologies
          txb.pure.string('https://mattpatt.dev'), // portfolio
          txb.object(udemyhub),
          txb.object(coursehub),
          coin
        ],
        target: `${UDEMYHUB_PACKAGE_ID}::udemyapp::create_courseCategory`,
    });

    signAndExecute(
        {
            transactionBlock: txb,
            options: {
                showEffects: true,
            },
        },
        {
            onSuccess: (tx) => {
                suiClient
                    .waitForTransactionBlock({
                        digest: tx.digest,
                    })
                    .then(() => {
                        const objectId = tx.effects?.created?.[0]?.reference?.objectId;
                        if (objectId) {
                            console.log(objectId);
                        }
                    });
            },
            onError: (err) => {
              console.log(err.message);
          },
        },
    );
}
}

export default CreateCategory