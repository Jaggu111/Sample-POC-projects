import React, { Component } from 'react';
import { Button, StyleSheet,NativeModules, View, Text, Image, TouchableOpacity } from 'react-native';

const LogIt = require('./resources/images/LogIt.png');
const submitButton = require('./resources/images/Submit_Button.png');
const pressedSubmitButton = require('./resources/images/Pressed_Submit_Button.png');

export default class ButtonBasics extends Component {
  constructor(props) {
    super(props);
    this.state = { vendorID: null, test: "ABCD", submitted: false, submitMessage : "" };
    this.updateStatus();
  }
  enableSDk = () => {
    NativeModules.BrightDiagnosticsNative.enableSDK();
  }
  collect = () => {
    NativeModules.BrightDiagnosticsNative.collect();
  }
  disableSDk= () => {
    NativeModules.BrightDiagnosticsNative.disableSDK();
  }

  updateStatus = () => {
    NativeModules.BrightDiagnosticsNative.getVendorID( (error, vendorID)=>{
      this.setState({ vendorID: vendorID});
    })  
  }

  onSubmit = () => {
    this.collect();
    this.setState({ submitted: true, submitMessage : "Thank you for submitting your log information. We will use this data to improve AT&T network coverage."});
  }

  render() {
    var {submitted, submitMessage} = this.state;
    return (
      <View style={styles.container}>
        <Image source = {LogIt} style={{ width: 400, height: 400 }}/>
        <TouchableOpacity activeOpacity = { .6 } onPress={this.onSubmit}>
          <Image source = {submitted ? pressedSubmitButton : submitButton} style={{ width: 105, height: 40 }}/>
        </TouchableOpacity>
        <Text style={styles.submitMessage}>{submitMessage}</Text>

        {/* <Text style={styles.welcome}>Welcome to ReactNative App!!</Text>
        <View style={styles.buttonContainer}>
          <Button
            onPress={this.enableSDk}
            title="EnableSDK"
          />
        </View>
        <View style={styles.buttonContainer}>
          <Button
            onPress={this.collect}
            title="CollectMetrics"
            color="#9E1A1A"
          />
        </View>
        <View style={styles.buttonContainer}>
          <Button
            onPress={this.disableSDk}
            title="DisableSDK"
            color="#841584"
          />
        </View>
        <Text style={styles.vendor}>{this.state.vendorID}</Text> */}
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
   flex: 1,
   alignItems: 'center',
  //  marginTop: 100,
  backgroundColor: 'white'
  },
  welcome: {
    margin: 20,
    fontSize: 20,
  },
  vendor: {
    margin: 20
  },
  buttonContainer: {
    margin: 20
  },
  alternativeLayoutButtonContainer: {
    margin: 20,
    flexDirection: 'row',
    justifyContent: 'space-between'
  },
  submitMessage: {
    margin: 12,
    marginTop: 25,
    fontSize: 15
  }
});
