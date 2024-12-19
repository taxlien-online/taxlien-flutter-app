// import React from "react";
// import { Animated, Dimensions, StatusBar, StyleSheet, Text, View, Pressable} from 'react-native';
// import { useNavigation } from "@react-navigation/native";
// import { useEffect } from 'react';
// import TabNavigator from '../../navigation/TabNavigator';


// const { width } = Dimensions.get('screen')
// const height = height;

// const items = [{
//   id: 1,
//   image: require('./TestImages/1.jpeg'),
// },
// {
//   id: 2,
//   image: require('./TestImages/2.jpeg'),
  
// },
// {
//   id: 3,
//   image: require('./TestImages/3.jpeg'),
// }
// ]


// const Carousel = () => {
//   const { TabNavigator: Navigator, bottomTabNavigatorHeight } = TabNavigator(); 
//   const navigation = useNavigation();
//   const scrollAnimation = React.useRef(new Animated.Value(0)).current;
//   return (
//     <View style={styles.carousel}>
//       <StatusBar hidden />
//       <Animated.FlatList
//         data={items}
//         bounces={false}
//         horizontal
//         pagingEnabled
//         onScroll={Animated.event([{ nativeEvent: { contentOffset: { x: scrollAnimation } } }], { useNativeDriver: true })}
//         showsHorizontalScrollIndicator
//         keyExtractor={item => item.id}
//         renderItem={({ item, index }) => {
//           const inputRange = [
//             width * (index-1),
//             width * index,
//             width * (index + 0.5)
//           ];
          
//           function moveToAnotherPage() {

//             navigation.navigate('MainScreen')
//           }

//           return (
            
//             <View style={styles.item}>
//               <Animated.Image source={item.image} style={[styles.image, {
//                 transform: [{
//                   translateX: scrollAnimation.interpolate({
//                     inputRange: [width * (index - 1), width * index, width * (index + 1)],
//                     outputRange: [-width * 0.5, 0, width * 0.5]
//                   })
//                 }]
//               }]}></Animated.Image>
//               <Animated.View style={styles.titleContainer}>
//               <Text style={styles.title}>{item.title}</Text>
//               </Animated.View>
//               <Animated.View style={styles.space}>
//               {/* <Pressable onPress={moveToAnotherPage} style={styles.button}><Text>Finish</Text></Pressable> */}
//               </Animated.View>
              
//             </View>
//           )
//         }}
//       >
//       </Animated.FlatList>
      
//     </View>
//   );
// };

// const styles = StyleSheet.create({
//   carousel: {
//     overflow: 'hidden',
//     flex: 1
//   },
//   space:{
//     position: 'absolute',
//     right:30,
//     marginTop:20,
//     backgroundColor:'red'
//   },
//   item: {
//     flexDirection: "row",
//     justifyContent: 'center',
//     overflow: 'hidden',
//     width,
//     height
//   },
//   image: {
//     width,
//     height,
//     resizeMode: 'cover'
//   },
//   titleContainer: {
//     position: 'absolute',
//     bottom: 60,
//   },
//   title: {
//     fontSize: 24,
//     color: '#fff'
//   },
//   button: {
    
//     backgroundColor:'red',
//     alighItems: 'center',
//     justifyContent: 'flex-start',
//   }
// });

// export default Carousel;




import React from 'react';
import { View, ScrollView, Image, StyleSheet, Dimensions, StatusBar } from 'react-native';

const images = [
  require('./TestImages/1.jpeg'),
  require('./TestImages/2.jpeg'),
  require('./TestImages/3.jpeg'),
];

const { width} = Dimensions.get('window');
const imageWidth = width ;
const height = height;

const Carousel = () => {
  return (
    <View style={styles.container}>
      <StatusBar hidden={true} />
      <ScrollView horizontal pagingEnabled>
        {images.map((image, index) => (
          <Image key={index} style={[styles.image, { width: imageWidth, height: height }]} source={image} />
        ))}
      </ScrollView>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
  image: {
    resizeMode: 'cover',
  },
  
});
export default Carousel;