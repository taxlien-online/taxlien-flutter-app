/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow strict-local
 * @author Vadim Savin
 */

import React, { useEffect } from 'react';
import { StatusBar } from 'react-native';
import 'react-native-gesture-handler';
//import Purchases from 'react-native-purchases';
import Router from './src/navigation/Router';
//import { API_KEY } from './src/constants';
import SplashScreen from "react-native-splash-screen"; 
import SpInAppUpdates, {
  NeedsUpdateResponse,
  IAUUpdateKind,
  StartUpdateOptions,
} from 'sp-react-native-in-app-updates';

const App: () => React$Node = () => {
  useEffect(() => {
    SplashScreen.hide(); //hides the splash screen on app load.
  }, []);
  useEffect(() => {

    const inAppUpdates = new SpInAppUpdates(
      false // isDebug
    );
    // curVersion is optional if you don't provide it will automatically take from the app using react-native-device-info
    inAppUpdates.checkNeedsUpdate({ curVersion: '0.0.8' }).then((result) => {
      if (result.shouldUpdate) {
        let updateOptions: StartUpdateOptions = {};
        if (Platform.OS === 'android') {
          // android only, on iOS the user will be promped to go to your app store page
          updateOptions = {
            updateType: IAUUpdateKind.FLEXIBLE,
          };
        }
        inAppUpdates.startUpdate(updateOptions); // https://github.com/SudoPlz/sp-react-native-in-app-updates/blob/master/src/types.ts#L78
      }
    });

    /* Enable debug logs before calling `setup`. */
    //Purchases.setDebugLogsEnabled(true);

    /*
      Initialize the RevenueCat Purchases SDK.

      - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids

      - observerMode is false, so Purchases will automatically handle finishing transactions. Read more about Observer Mode here: https://docs.revenuecat.com/docs/observer-mode

      - useAmazon is false, so it will use the Play Store in Android and App Store in iOS by default.
      */
    //Purchases.configure({ apiKey: API_KEY, appUserID: null, observerMode: false, useAmazon: false });
  }, []);

  return (
    <>
      <StatusBar barStyle="light-content" />
      <Router />
      
    </>
  );
};

export default App;
