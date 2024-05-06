/**
 * @file Paywall Screen.
 * @author Vadim Savin
 */

import React, { useEffect, useState } from 'react';
import { View, Text, FlatList, Alert } from 'react-native';
import Purchases from 'react-native-purchases';
import { PackageItem } from '../../components';
import {TouchableOpacity, Linking} from 'react-native';
import styles from './styles.js';

/*
 An example paywall that uses the current offering.
 */
const PaywallScreen = () => {
  // - State for all available package
  const [packages, setPackages] = useState([]);

  // - State for displaying an overlay view
  const [isPurchasing, setIsPurchasing] = useState(false);

  useEffect(() => {
    // Get current available packages
    const getPackages = async () => {
      try {
        const offerings = await Purchases.getOfferings();
        if (offerings.current !== null && offerings.current.availablePackages.length !== 0) {
          setPackages(offerings.current.availablePackages);
        }
      } catch (e) {
        Alert.alert('Error getting offers', e.message);
      }
    };

    getPackages();
  }, []);

  const header = () => <Text style={styles.text}>Quickex Exchange</Text>;

  const PrivacyClick = () => {
    Linking.openURL('https://www.privacypolicies.com/live/064296a8-e682-4587-807e-845b695f0af1');
  };
  const footer = () => {
    return (
      <Text style={styles.text}>
        В нашем приложении присутствует Месячная автоматически возобновляемая подписка на контент предоставляемый в приложении (полный доступ):

• продолжительность 1 месяц ($9,99) или эквивалентно в другой валюте.

• Ваша подписка будет списана с вашей учетной записи iTunes при подтверждении покупки и будет автоматически продлена (на месяц), если автоматическое продление не будет отключено по крайней мере за 24 часа до окончания текущего периода.

• Текущая подписка не может быть отменена в течение активного периода подписки; однако вы можете управлять своей подпиской и / или отключить автоматическое продление, посетив настройки своей учетной записи iTunes после покупки.

<TouchableOpacity onPress={PrivacyClick} >
      <Text  style={styles.privacy}>• Privacy Policy: https://www.privacypolicies.com/live/064296a8-e682-4587-807e-845b695f0af1</Text>
</TouchableOpacity>
      </Text>
    );
  };

  return (
    <View style={styles.page}>
      {/* The paywall flat list displaying each package */}
      <FlatList
        data={packages}
        renderItem={({ item }) => <PackageItem purchasePackage={item} setIsPurchasing={setIsPurchasing} />}
        keyExtractor={(item) => item.identifier}
        ListHeaderComponent={header}
        ListHeaderComponentStyle={styles.headerFooterContainer}
        ListFooterComponent={footer}
        ListFooterComponentStyle={styles.headerFooterContainer}
      />

      {isPurchasing && <View style={styles.overlay} />}
    </View>
  );
};

export default PaywallScreen;
