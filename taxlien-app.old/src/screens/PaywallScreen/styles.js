import { StyleSheet } from 'react-native';

const styles = StyleSheet.create({
  page: {
    padding: 16,
  },
  text: {
    color: 'lightgrey',
    fontSize: 12
  },
  headerFooterContainer: {
    marginVertical: 10,
  },
  privacy:{
    marginTop: 20,
    color: 'lightgrey',
    textDecorationLine: 'underline',
    textDecorationColor: '#FF8F3B',
    textDecorationStyle: 'dashed',
    fontSize: 12
  },
  terms:{
    marginTop: 5,
    color: 'lightgrey',
    textDecorationLine: 'underline',
    textDecorationColor: '#FF8F3B',
    textDecorationStyle: 'dashed',
    fontSize: 12
  },
  overlay: {
    flex: 1,
    position: 'absolute',
    left: 0,
    top: 0,
    right: 0,
    bottom: 0,
    opacity: 0.5,
    backgroundColor: 'black',
  },
});

export default styles;
