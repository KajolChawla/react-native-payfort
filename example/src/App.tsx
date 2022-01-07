import React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import { applePayAmmount } from 'react-native-payfort';
export default function App() {
  const pay = () => {
    applePayAmmount(
      {
        command: 'PURCHASE',
        access_code: 'rYsi47ajRWvPeDcWOq8o',
        merchant_identifier: 'LYlVIrli',
        sha_request_phrase: 'O@kmnbvc234',
        amount: '100',
        currencyType: 'SAR',
        currencyCode: 'SAR',
        language: 'en',
        email: 'shubham.d@sankeysolutions.com',
        isProduction: false,
        countryCode: 'SA',
        summaryLabel: 'hello',
      },
      (success: any) => console.log({ success }),
      (error: any) => console.log({ error })
    );
    // payAmount(
    //   {
    //     command: 'PURCHASE',
    //     access_code: 'rYsi47ajRWvPeDcWOq8o',
    //     merchant_identifier: 'LYlVIrli',
    //     sha_request_phrase: 'O@kmnbvc234',
    //     amount: '100',
    //     currencyType: 'SAR',
    //     currencyCode: 'SAR',
    //     language: 'en',
    //     email: 'shubham.d@sankeysolutions.com',
    //     isProduction: false,
    //     countryCode: 'SA',
    //     summaryLabel: 'hello',
    //   },
    //   (success: any) => console.log({ success }),
    //   (error: any) => console.log({ error })
    // );
  };

  return (
    <View style={styles.container}>
      <Text onPress={pay}>Pay</Text>
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
