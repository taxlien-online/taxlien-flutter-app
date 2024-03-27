import React,{useState, useRef} from 'react';
import { StyleSheet, Text, View, SafeAreaView} from 'react-native';
import { WebView } from 'react-native-webview';
import NavigationView from './NavigationView';


var referer = "-";
/*
        ref={(ref) => { this.webview = ref; }}
*/
export default function VedicGamesScreen() {
  const webViewRef= useRef()
  const uri = 'https://quickex.io/';
  const [canGoBack, setCanGoBack] =useState(false);
  const [canGoForward, setCanGoForward] =useState(false);
  const handleBackPress =() => {
    webViewRef.current.goBack()
  }
  const handleForwardPress =() => {
    webViewRef.current.goForward()
  }

  return (
    
    <SafeAreaView style={{flex:1}}>
      <WebView 
        ref={webViewRef}
        allowFileAccess={true}
        scalesPageToFit={true}
        originWhitelist={['*','tel:+972547474151']}
        source={{uri}}
        startInLoadingState={true}
        bounces={false}
        domStorageEnabled={true}
        javaScriptEnabled={true}
        geolocationEnabled={true}
        saveFormDataDisabled={true}
        allowFileAccessFromFileURLS={true}
        allowUniversalAccessFromFileURLs={true}
        onNavigationStateChange={state =>{
          
        }}/>
         
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#000',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
