import 'package:flutter/material.dart';

import 'package:login_facebook_app/utils/colors.dart';
import 'package:login_facebook_app/screens/menu.dart';

class OptionPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _OptionPageState createState() => new _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo_login.png'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      // initialValue: 'alucard@gmail.com',
      decoration: InputDecoration(
        hintText: 'Correo',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      //initialValue: 'some password',
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Contraseña',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final loginCorreo = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        color: canchaPrimaryLight,
        shadowColor: Colors.green.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Menu()),
          ),

          // color: canchaPrimaryLight,
          child: Text('Iniciar Sesión', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
    final loginGmail = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        color: colorGoogle,
        shadowColor: Colors.green.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            MaterialPageRoute(builder: (context) => Menu());
          },
          // color: canchaPrimaryLight,
          child: Text('Gmail', style: TextStyle(color: Colors.black)),
        ),
      ),
    );
    final loginFacebook = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        color: colorFacebook,
        shadowColor: Colors.green.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            null; //Navigator.of(context).pushNamed(HomePage.tag);
          },
          // color: canchaPrimaryLight,
          child: Text('Facebook', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        '¿Olvidó su Contraseña?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginCorreo,
            forgotLabel,
            loginGmail,
            loginFacebook
          ],
        ),
      ),
    );
  }
}
