/**
 * @file Home Tab Navigator.
 * @author Vadim Savin
 */

import React, { useState, useEffect, useLayoutEffect } from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import Ionicons from 'react-native-vector-icons/Ionicons';

import VedicGamesRouter from './VedicGamesRouter';
//import WeatherRouter from './WeatherRouter';
import CarouselRouter from './CarouselRouter';
import { View } from 'react-native';

const Tab = createBottomTabNavigator();

const TabNavigator = () => {

  const [bottomTabNavigatorHeight, setBottomTabNavigatorHeight] = useState(0);

  const bottomTabNavigatorRef = React.createRef();

  useLayoutEffect(() => {
    if (bottomTabNavigatorRef.current) {
      bottomTabNavigatorRef.current.measure((x, y, width, height) => {
        setBottomTabNavigatorHeight(height);
      });
    }
  }, []);


  return (
    <Tab.Navigator ref={bottomTabNavigatorRef}>
      <Tab.Screen
        name="Home"
        component={VedicGamesRouter}
        options={{
          headerShown: false,
          tabBarIcon: ({ focused, color, size }) => (
            <Ionicons name={focused ? 'ios-apps' : 'ios-apps'} color={color} size={size} />
          ),
        }}
      />
      <Tab.Screen 
        name="Rules"
        component={CarouselRouter}
        options={{
          overflow: 'hidden',
          headerShown: false,
          tabBarIcon: ({ focused, color, size }) => (
            <Ionicons name={focused ? 'ios-book' : 'ios-book'} color={color} size={size} />
          ),
        }}
      />
      
    </Tab.Navigator>
  );
};


export default TabNavigator;

