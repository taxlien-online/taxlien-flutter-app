import React from 'react';
import { createStackNavigator } from '@react-navigation/stack';
import Carousel from '../screens/CarouselScreen';
const Stack = createStackNavigator();

const CarouselRouter = () => (
  <Stack.Navigator>
    <Stack.Screen
      name="Carousel"
      component={Carousel}
      options={{
        headerShown: false
      }}
    />
  </Stack.Navigator>
);

export default CarouselRouter;