
import 'package:flutter/material.dart';
import 'package:login_facebook_app/utils/colors.dart';
import 'menu.dart';
import 'dart:async';
import 'dart:convert' show json;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'DetailedScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

GoogleSignIn _googleSignIn = new GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
//
//Future<void> _handleSignIn() async{
//  try{
//    await _googleSignIn.signIn();
//    print("CORREO"+_googleSignIn.currentUser.displayName);
//  }catch(error){
//    print(error);
//  }
//}



class _LoginPageState extends State<LoginPage> {
  GoogleSignInAccount _currentUser;
  String _contactText;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact();
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = "Cargando Informacion del contacto...";
    });
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "o hay contactos para mostrar.";
      }
    });
  }

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
          (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
            (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
  }


  static final FacebookLogin facebookSignIn = new FacebookLogin();

  //my code
  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  //end my code

  Future<FirebaseUser> _signIn(BuildContext context) async {


    final FacebookLoginResult result =
    await facebookSignIn.logInWithReadPermissions(['email']);

    FirebaseUser user =
    await _fAuth.signInWithFacebook(accessToken: result.accessToken.token);
    //Token: ${accessToken.token}

    ProviderDetails userInfo = new ProviderDetails(
        user.providerId, user.uid, user.displayName, user.photoUrl, user.email);

    List<ProviderDetails> providerData = new List<ProviderDetails>();
    providerData.add(userInfo);

    UserInfoDetails userInfoDetails = new UserInfoDetails(
        user.providerId,
        user.uid,
        user.displayName,
        user.photoUrl,
        user.email,
        user.isAnonymous,
        user.isEmailVerified,
        providerData);

    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new DetailedScreen(detailsUser: userInfoDetails),
      ),
    );

    return user;
  }

  @override
  Widget build(BuildContext context) {

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo_oficial.jpeg'),
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
            _handleSignIn();
           // MaterialPageRoute(builder: (context) => Menu());
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
          onPressed: () => _signIn(context)
              .then((FirebaseUser user) => print(user))
              .catchError((e) => print(e)),
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

class UserInfoDetails {
  UserInfoDetails(this.providerId, this.uid, this.displayName, this.photoUrl,
      this.email, this.isAnonymous, this.isEmailVerified, this.providerData);

  /// The provider identifier.
  final String providerId;

  /// The provider’s user ID for the user.
  final String uid;

  /// The name of the user.
  final String displayName;

  /// The URL of the user’s profile photo.
  final String photoUrl;

  /// The user’s email address.
  final String email;

  // Check anonymous
  final bool isAnonymous;

  //Check if email is verified
  final bool isEmailVerified;

  //Provider Data
  final List<ProviderDetails> providerData;
}

class ProviderDetails {
  final String providerId;

  final String uid;

  final String displayName;

  final String photoUrl;

  final String email;

  ProviderDetails(
      this.providerId, this.uid, this.displayName, this.photoUrl, this.email);
}