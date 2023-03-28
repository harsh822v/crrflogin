import 'dart:convert';
// import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
//import package file manually

void main() => runApp(const MyApp());
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        theme: ThemeData(
          primarySwatch:Colors.blue,
        ),
        home: const WriteSQLdata()
    );
  }
}

class WriteSQLdata extends StatefulWidget{
  const WriteSQLdata({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WriteSQLdataState();
  }
}

class WriteSQLdataState extends State<WriteSQLdata>{

  TextEditingController stuid = TextEditingController();
  TextEditingController namectl = TextEditingController();
  TextEditingController addressctl = TextEditingController();
  TextEditingController classctl = TextEditingController();
  TextEditingController rollnoctl = TextEditingController();

  bool error= false, sending = false, success = false;
  String msg = "";

  String phpurl = "http://localhost/login_api/write.php";
  // String phpurl = "http://192.168.43.240/login_api/write.php";
  // String phpurl = "http://100.96.203.115/login_api/write.php";


  @override
  void initState() {
    error = false;
    sending = false;
    success = false;
    msg = "";
    super.initState();
  }

  Future<void> sendData() async {

    // try {
    var res = await http.post(Uri.parse(phpurl),
        body: {
          "student_id": stuid.text,
          "name": namectl.text,
          "address": addressctl.text,
          "class": classctl.text,
          "rollno": rollnoctl.text,
        });

    if (res.statusCode == 200) {
      //print(res.body); //print raw response on console
      // Toast.show("Error :: $msg res.body" , duration: Toast.lengthShort, gravity:  Toast.bottom);
      var data = json.decode(res.body); //decoding json to array
      //Toast.show("Error :: $msg and data = $data" , duration: Toast.lengthShort, gravity:  Toast.bottom);

      if (data["error"]) {
        setState(() { //refresh the UI when error is recieved from server
          sending = false;
          error = true;
          msg = data["message"]; //error message from server
          //Toast.show("Error :: $msg" , duration: Toast.lengthShort, gravity:  Toast.bottom);
        });
      } else {
        stuid.text = "";
        namectl.text = "";
        addressctl.text = "";
        classctl.text = "";
        rollnoctl.text = "";
        //after write success, make fields empty

        setState(() {
          sending = false;
          success = true; //mark success and refresh UI with setState
        });
      }
    } else {
      //there is error
      setState(() {
        error = true;
        msg = "Error in sending data";
        sending = false;


        //mark error and refresh UI with setState
      });

      if (kDebugMode) {
        print(msg);
      }
    }
    // }on SocketException catch(e){
    // Toast.show("Error fhbgngn:: $e" , duration: Toast.lengthShort, gravity:  Toast.bottom);
    // }

    //Toast.show("Error :: $msg" , duration: Toast.lengthShort, gravity:  Toast.bottom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:const Text("hello  this first insert operation"),
          backgroundColor:Colors.blueAccent
      ), //appbar

      body: SingleChildScrollView( //enable scrolling, when keyboard appears,
        // hight becomes small, so prevent overflow
          child:Container(
              padding: const EdgeInsets.all(20),
              child: Column(children: <Widget>[

                Container(
                  child:Text(error?msg:"Enter Student Information"),
                  //if there is error then sho msg, other wise show text message
                ),

                Container(
                  child:Text(success?"Write Success":"send data"),
                  // child:Text(success?"":""),
                  //is there is success then show "Write Success" else show "send data"
                ),

                Container(
                  child: TextField(
                    controller: stuid,
                    decoration: const InputDecoration(
                        labelText: "student id:",
                        hintText: "enter student id"
                    ),
                  ),
                ),

                Container(
                    child: TextField(
                      controller: namectl,
                      decoration: const InputDecoration(
                        labelText:"Full Name:",
                        hintText:"Enter student full name",
                      ),
                    )
                ), //text input for name

                Container(
                    child: TextField(
                      controller: addressctl,
                      decoration: const InputDecoration(
                        labelText:"Address:",
                        hintText:"Enter student address",
                      ),
                    )
                ), //text input for address

                Container(
                    child: TextField(
                      controller: classctl,
                      decoration: const InputDecoration(
                        labelText:"Class:",
                        hintText:"Enter student class",
                      ),
                    )
                ), //text input for class

                Container(
                    child: TextField(
                      controller: rollnoctl,
                      decoration: const InputDecoration(
                        labelText:"Roll No:",
                        hintText:"Enter student rollno",
                      ),
                    )
                ), //text input for roll no

                Container(
                    margin: const EdgeInsets.only(top:20),
                    child:SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:(){ //if button is pressed, setstate sending = true, so that we can show "sending..."

                            setState(() {
                              sending = true;
                              sendData();

                            });
                            Toast.show("Error :: $msg" , duration: Toast.lengthShort, gravity:  Toast.bottom);
                          },
                          child: Text(
                            sending?"Pending...":"SEND DATA",
                            //if sending == true then show "Sending" else show "SEND DATA";
                          ),
                          //background of button is darker color, so set brightness to dark
                        )
                    )
                )
              ],)
          )
      ),
    );
  }
}