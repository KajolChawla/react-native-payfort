import { NativeModules, Platform } from 'react-native';
const BASE_URL = 'https://sbpaymentservices.payfort.com/FortAPI/paymentApi';

const LINKING_ERROR =
  `The package 'react-native-payfort' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const Payfort = NativeModules.Payfort
  ? NativeModules.Payfort
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export const getDeviceId = () =>
  new Promise(async (resolve: any, reject: any) => {
    try {
      await Payfort.getDeviceId((id: any) => resolve(id));
    } catch (ex) {
      reject(ex);
    }
  });
export const getSHA256 = (str: String) =>
  new Promise(async (resolve: any, reject: any) => {
    try {
      await Payfort.getSHA256(str, (strHash: String) => resolve(strHash));
    } catch (ex) {
      reject(ex);
    }
  });

export const payAmount = async (payConf: Object, success: any, error: any) => {
  try {
    let reqBody = await getValidRequest(payConf);
    console.log({reqBody})
    Payfort.Pay(reqBody, success, error);
  } catch (ex) {
    return ex;
  }
};

//Common funtions
const getMerchantRef = () => {
  return `${Math.random() * 4294967296}`;
};

const getValidRequest = async (data: any) => {
  const {
    command,
    access_code,
    merchant_identifier,
    sha_request_phrase,
    email,
    language,
    amount,
    currencyType,
  } = data ?? {};
  if (
    access_code &&
    merchant_identifier &&
    command &&
    sha_request_phrase &&
    email &&
    language &&
    amount &&
    currencyType
  ) {
    let reqBody = data;
    reqBody.merchant_reference = reqBody.merchant_reference ?? getMerchantRef();
    console.log({ reqBody });

    let SDK_TOKEN = await getSDKToken(reqBody);
    reqBody.sdk_token = SDK_TOKEN.sdk_token;
    return JSON.stringify(reqBody);
  }
  return false;
};

const getSDKToken = async (data: any) => {
  let access_code = data.access_code;
  let merchant_identifier = data.merchant_identifier;
  let language = data.language;
  let shaPhrase = data.sha_request_phrase;
  let deviceID = await getDeviceId();
  let signatureString = `${shaPhrase}access_code=${access_code}device_id=${deviceID}language=${language}merchant_identifier=${merchant_identifier}service_command=SDK_TOKEN${shaPhrase}`;
  let hash256 = await getSHA256(signatureString);
  // console.log({ hash256, signatureString });

  let postBody = {
    service_command: 'SDK_TOKEN',
    merchant_identifier: merchant_identifier,
    language: language,
    device_id: deviceID,
    access_code: access_code,
    signature: hash256,
  };
  const response = await fetch(BASE_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Content-Length': `${Object.keys(postBody).length}`,
    },
    body: JSON.stringify(postBody),
  });
  // .then((response) => response.text())
  // .then((result) => console.log(result))
  // .catch((error) => console.log('error', error));
  return response.json();
};
