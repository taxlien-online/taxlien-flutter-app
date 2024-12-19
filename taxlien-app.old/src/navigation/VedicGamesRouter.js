import React from 'react';
import { createStackNavigator } from '@react-navigation/stack';
import VedicGamesScreen from '../screens/VedicGamesScreen';

const Stack = createStackNavigator();

const VedicGamesRouter = () => (
  <Stack.Navigator>
    <Stack.Screen
      name="Weather"
      component={VedicGamesScreen}
      options={{
        title: '✨ TaxLien.online',
      }}
    />
  </Stack.Navigator>
);

export default VedicGamesRouter;