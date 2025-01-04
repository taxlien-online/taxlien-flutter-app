/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 */

import React,{useState, useRef} from 'react';

import type {PropsWithChildren} from 'react';
import {
  SafeAreaView,
  StyleSheet,
/*
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  useColorScheme,
  View,*/
} from 'react-native';

import { WebView } from 'react-native-webview';

/*
import {
  Colors,
  DebugInstructions,
  Header,
  LearnMoreLinks,
  ReloadInstructions,
} from 'react-native/Libraries/NewAppScreen';
*/

/*
type SectionProps = PropsWithChildren<{
  title: string;
}>;

function Section({children, title}: SectionProps): React.JSX.Element {
  const isDarkMode = useColorScheme() === 'dark';
  return (
    <View style={styles.sectionContainer}>
      <Text
        style={[
          styles.sectionTitle,
          {
            color: isDarkMode ? Colors.white : Colors.black,
          },
        ]}>
        {title}
      </Text>
      <Text
        style={[
          styles.sectionDescription,
          {
            color: isDarkMode ? Colors.light : Colors.dark,
          },
        ]}>
        {children}
      </Text>
    </View>
  );
}

function App(): React.JSX.Element {
  const isDarkMode = useColorScheme() === 'dark';

  const backgroundStyle = {
    backgroundColor: isDarkMode ? Colors.darker : Colors.lighter,
  };

  return (
    <SafeAreaView style={backgroundStyle}>
      <StatusBar
        barStyle={isDarkMode ? 'light-content' : 'dark-content'}
        backgroundColor={backgroundStyle.backgroundColor}
      />
      <ScrollView
        contentInsetAdjustmentBehavior="automatic"
        style={backgroundStyle}>
        <Header />
        <View
          style={{
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
          }}>
          <Section title="Step One">
            Edit <Text style={styles.highlight}>App.tsx</Text> to change this
            screen and then come back to see your edits.
          </Section>
          <Section title="See Your Changes">
            <ReloadInstructions />
          </Section>
          <Section title="Debug">
            <DebugInstructions />
          </Section>
          <Section title="Learn More">
            Read the docs to discover what to do next:
          </Section>
          <LearnMoreLinks />
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  sectionContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
  },
  sectionDescription: {
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
  },
  highlight: {
    fontWeight: '700',
  },
});

export default App;
*/





var referer = "-";
/*
        ref={(ref) => { this.webview = ref; }}
*/
export default function MainScreen() {
  //const webViewRef= useRef()
  const uri = 'https://app.taxlien.online/';
  const [canGoBack, setCanGoBack] =useState(false);
  const [canGoForward, setCanGoForward] =useState(false);
  /*
  const handleBackPress =() => {
    webViewRef.current.goBack()
  }
  const handleForwardPress =() => {
    webViewRef.current.goForward()
  }
  */

  return (
    
    <SafeAreaView style={{flex:1}}>
      <WebView 
        //ref={webViewRef}
        allowFileAccess={true}
        scalesPageToFit={true}
        originWhitelist={['*','tel:+972547474151']}
        source={{uri}}
        style={{ flex: 1 }}
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