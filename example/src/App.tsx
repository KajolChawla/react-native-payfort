import React, { useEffect } from 'react';

import { StyleSheet, View, Text } from 'react-native';
import { multiply, getDeviceId, payAmount } from 'react-native-payfort';

export default function App() {
  const [result, setResult] = React.useState<number | undefined>();

 const temp = async ()=> {
   let id = await getDeviceId();
  //  console.log(id)
 }
  const pay =() => {
    // multiply(3, 7).then(setResult);
    payAmount(
      {
        command: 'AUTHORIZATION',
        access_code: 'rYsi47ajRWvPeDcWOq8o',
        merchant_identifier: 'LYlVIrli',
        sha_request_phrase: 'O@kmnbvc234',
        amount: '100',
        currencyType: 'SAR',
        language: 'en',
        email: 'shubham.d@sankeysolutions.com',
        isProduction: false,
      },
      (success) => console.log({success}),
      (error) => console.log({error})
    );
  };
  // useEffect(() => {
  //   pay();
  //   return () => {
      
  //   }
  // }, [])

  return (
    <View style={styles.container}>
      <Text onPress={pay}>Result: {result}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
