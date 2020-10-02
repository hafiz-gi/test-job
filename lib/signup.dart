import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_job/Home.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  List<String> interestedCategory=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select interested category',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            button('Funny', (){
              if(!interestedCategory.contains('funny')){
                interestedCategory.add('funny');
              }
            }),
            button('Football', (){
              if(!interestedCategory.contains('football')){
                interestedCategory.add('football');
              }
            }),
            button('Music', (){
              if(!interestedCategory.contains('music')){
                interestedCategory.add('music');
              }
            }),
            SizedBox(height: 20,),
            RaisedButton(
              child: Text('Sign up'),
              onPressed: ()async{
                if(interestedCategory.length!=0){
                print(interestedCategory.length);
                SharedPreferences prefs = await  SharedPreferences.getInstance();
                prefs.setStringList('interestedCategory', interestedCategory);
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Home()
                ));
                }
                else{
                    showDialog(
                        context: (context),
                        builder: (context)=>AlertDialog(
                          content: Text('please select at least one category'),
                        )
                    );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget button(String name, Function onTap){
   return Padding(
      padding: const EdgeInsets.all(10),
      child: MaterialButton(
        onPressed: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(20.0),
        ),
        minWidth: MediaQuery.of(context).size.width,
        height: 50,
        child: Text(
          name,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        color: Colors.blueAccent,
      ),
    );
  }
}
