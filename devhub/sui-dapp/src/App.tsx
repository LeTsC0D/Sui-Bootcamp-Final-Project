import { ConnectButton } from "@mysten/dapp-kit";
import { Box, Container, Flex, Heading } from "@radix-ui/themes";
import { WalletStatus } from "./WalletStatus";
import { useState } from "react";
import CreateDevcard from "./CreateDevcard";
function App() {
  const [devstatus,setDevStatus]=useState(false);
  return (
    <>
      <Flex
        position="sticky"
        px="4"
        py="2"
        justify="between"
        style={{
          borderBottom: "1px solid var(--gray-a2)",
        }}
      >
        <Box>
          <Heading>dApp Starter Template</Heading>
        </Box>

        <Box>
          <ConnectButton />
        </Box>
      </Flex>
      <Container>
        <Container
          mt="5"
          pt="2"
          px="4"
          style={{ background: "var(--gray-a2)", minHeight: 500 }}
        >
          <WalletStatus />
            <CreateDevcard setDevStatus={setDevStatus} devstatus={devstatus}/>
            <br/>
            <button onClick={() => setDevStatus(!devstatus)}>Create Devcard</button>
            <br/>  
        </Container>
      
      </Container>
    </>
  );
}

export default App;
