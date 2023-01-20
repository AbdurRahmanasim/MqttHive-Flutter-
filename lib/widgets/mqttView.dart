
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:mqtthive/mqtt/MQTTManager.dart';
import 'package:mqtthive/mqtt/state/MQTTAppState.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter__app/mqtt/state/MQTTAppState.dart';
// import 'package:flutter_mqtt_app/mqtt/MQTTManager.dart';

class MQTTView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MQTTViewState();
  }
}

class _MQTTViewState extends State<MQTTView> {
  final TextEditingController _hostTextController = TextEditingController();
  final TextEditingController _messageTextController = TextEditingController();
  final TextEditingController _topicTextController = TextEditingController();
  late MQTTAppState currentAppState;
  late MQTTManager manager;

  @override
  void initState() {
    super.initState();

    /*
    _hostTextController.addListener(_printLatestValue);
    _messageTextController.addListener(_printLatestValue);
    _topicTextController.addListener(_printLatestValue);
     */
  }

  @override
  void dispose() {
    _hostTextController.dispose();
    _messageTextController.dispose();
    _topicTextController.dispose();
    super.dispose();
  }

  /*
  _printLatestValue() {
    print("Second text field: ${_hostTextController.text}");
    print("Second text field: ${_messageTextController.text}");
    print("Second text field: ${_topicTextController.text}");
  }
   */

  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    // Keep a reference to the app state.
    currentAppState = appState;
    // final Scaffold scaffold = Scaffold(body: _buildColumn());
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
      title : Center(child: Text("MQTT DASHBOARD")),
      ),
      body: SingleChildScrollView(child: _buildColumn()),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('MQTT'),
      backgroundColor: Colors.greenAccent,
    );
  }

  Widget _buildColumn() {
    return Column(
      children: <Widget>[
        _buildConnectionStateText(
            _prepareStateMessageFrom(currentAppState.getAppConnectionState)),
        _buildEditableColumn(),
        
      ],
    );
  }

  Widget _buildEditableColumn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal : 20.0),
      child: Column(
        children: <Widget>[
          Container(
           decoration: BoxDecoration(
    color: Colors.grey[700],
      
      borderRadius: BorderRadius.circular(25)
    ),  


            width: MediaQuery.of(context).size.width,
            height: 230,
            // color: Colors.brown,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  children: [
  _buildTextFieldWith(_hostTextController, 'Enter BROKER',
                  currentAppState.getAppConnectionState),
          const SizedBox(height: 10),
          _buildTextFieldWith(
                  _topicTextController,
                  'Enter Topic to Subscribe or Listen',
                  currentAppState.getAppConnectionState),
          const SizedBox(height: 10),
          _buildConnecteButtonFrom(currentAppState.getAppConnectionState),
                  ],
                ),
              ),
            ),
          ),
        
          const SizedBox(height: 10),
          _buildPublishMessageRow(),
          
        ],
      ),
    );
  }

  Widget _buildPublishMessageRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
        color: Colors.grey[700],
          borderRadius: BorderRadius.circular(20)
        ),
        // height: 250,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text("Messages for Publishing and Listening" , style: TextStyle(fontSize: 14 , color: Colors.white, fontWeight: FontWeight.bold ) , ),
              // SizedBox(height: 10, ) ,
              _buildTextFieldWith(_messageTextController, "Messages to Publish & Listen",
                  currentAppState.getAppConnectionState),
              SizedBox(height: 20,),
                  _buildSendButtonFrom(currentAppState.getAppConnectionState),
              SizedBox(height: 10,),

        _buildScrollableTextWith(currentAppState.getHistoryText)


            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionStateText(String status) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
  decoration: BoxDecoration(
    color: Colors.grey[700],
      
      borderRadius: BorderRadius.circular(25)
    ),  

        margin: const EdgeInsets.all(20),
        height: 80,
        width: MediaQuery.of(context).size.width,
            // color: Colors.lime,
            child: Center(child: Text("Connection Status : " + status,style : TextStyle( color: Colors.white ,fontWeight: FontWeight.bold , fontSize: 16 ), textAlign: TextAlign.center))),
    );
  }

  Widget _buildTextFieldWith(TextEditingController controller, String hintText,
      MQTTAppConnectionState state) {
    bool shouldEnable = false;
    if (controller == _messageTextController &&
        state == MQTTAppConnectionState.connected) {
      shouldEnable = true;
    } else if ((controller == _hostTextController &&
            state == MQTTAppConnectionState.disconnected) ||
        (controller == _topicTextController &&
            state == MQTTAppConnectionState.disconnected)) {
      shouldEnable = true;
    }
    return TextField(
      style: TextStyle(color: Colors.white),
        controller: controller,
      decoration: InputDecoration(
        labelText: hintText,
         enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
          ),
        labelStyle: TextStyle(
      color: Colors.white, //<-- SEE HERE
    ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
        enabled: shouldEnable,
     ));
  }

  Widget _buildScrollableTextWith(String text) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        color: Colors.grey[700],
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
  
          children:[
            SizedBox(height: 2,),
            SingleChildScrollView(
            
            child: Text("RESPONSE FROM SERVER" , style: TextStyle(color: Colors.white, fontSize: 18 ,fontWeight: FontWeight.bold),),
          ),
          SizedBox(height: 10,) ,
          
           SingleChildScrollView(
            
            child: Column(
              children: [
                // Container(

                //   child: Text("Andriod", style: TextStyle( fontSize: 12, color: Colors.white),)
                //   ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(child: Text(text, style: TextStyle(color: Colors.white),)),
                ),
                 
              ],
            ),
          ),]
        ),
      ),
    );
  }

  Widget _buildConnecteButtonFrom(MQTTAppConnectionState state) {
    return Row(
      children: <Widget>[
        Expanded(
          // ignore: deprecated_member_use
          child: ElevatedButton(
             style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, foregroundColor: Colors.white),
            child: const Text('Connect'),
            onPressed: state == MQTTAppConnectionState.disconnected
                ? _configureAndConnect
                : null, //
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          // ignore: deprecated_member_use
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700], foregroundColor: Colors.white),
            child: const Text('Disconnect'),
            onPressed: state == MQTTAppConnectionState.connected
                ? _disconnect
                : null, //
          ),
        ),
      ],
    );
  }

  Widget _buildSendButtonFrom(MQTTAppConnectionState state) {
    // ignore: deprecated_member_use;
    // return ElevatedButton(
    //    style: ElevatedButton.styleFrom(
                
    //             padding:
    //                 const EdgeInsets.symmetric(horizontal: 130),
    //             textStyle:
    //                 const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
    //   // color: Colors.green,
    //   child: const Text('Send'),
    //   onPressed: state == MQTTAppConnectionState.connected
    //       ? () {
    //           _publishMessage(_messageTextController.text);
    //         }
    //       : null, //
    // );
    return InkWell(
      onTap: state == MQTTAppConnectionState.connected
          ? () {
              _publishMessage(_messageTextController.text);
            }
          : null,
      child: (
       Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        color: Colors.deepOrange,
        ),
        width: MediaQuery.of(context).size.width,
        height: 40,
        child: Center(child: Text("Send", style: TextStyle(fontSize: 20 , color: Colors.white),)),
       )
      ),
    );

  }

  // Utility functions
  String _prepareStateMessageFrom(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        return 'Connected';
      case MQTTAppConnectionState.connecting:
        return 'Connecting';
      case MQTTAppConnectionState.disconnected:
        return 'Disconnected';
    }
  }

  void _configureAndConnect() {
    // ignore: flutter_style_todos
    // TODO: Use UUID
    String osPrefix = 'Flutter_iOS';
    // if (Platform.isAndroid) {
    // }
    if (defaultTargetPlatform == TargetPlatform.android){
      osPrefix = 'Flutter_Android';
    }
    manager = MQTTManager(
        host: _hostTextController.text,
        topic: _topicTextController.text,
        identifier: osPrefix,
        state: currentAppState);
    manager.initializeMQTTClient();
    manager.connect();
  }

  void _disconnect() {
    manager.disconnect();
  }

 void _publishMessage(String text) {
    String osPrefix = 'IOS : ';
    if (Platform.isAndroid) {
      osPrefix = 'Android : ';
    }
    final String message = text;
    manager.publish(message);
    _messageTextController.clear();
  }

}