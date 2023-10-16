import 'package:calender_project/Auth/Register.dart';
import 'package:calender_project/Custom_Widget/Buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '../provider/provider.dart';
import '../screens/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  GlobalKey<FormState> formkey = GlobalKey< FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final passwordFocusNode = FocusNode();
  bool isButtonActivePass = false;
  bool isButtonActiveEmail = false;
  var errorpass = '';
  var erroremail = '';

  bool _isHidden = true;
  void _toggleObscured() {
    setState(() {
      _isHidden = !_isHidden;
      if (passwordFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      passwordFocusNode.canRequestFocus = false; // Prevents focus if tap on eye
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  String languageChange = 'en';

  @override
  Widget build(BuildContext context) {
    Prov chprov = Provider.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Row(
                      children: [
                        SizedBox(width: 20,),
                        Text(AppLocalizations.of(context).lang,style: TextStyle(color: Colors.grey.shade700),),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            items: [
                              DropdownMenuItem<String>(value: 'en',child: Text("english")),
                              DropdownMenuItem<String>(value: 'ar',child: Text("عربي"))
                            ],
                            onChanged: (String? newvalue) {
                              chprov.changeLang(newvalue!);
                              if (kDebugMode) {
                                print(chprov.currentLang);
                              }
                              setState(() {
                                languageChange = newvalue;
                              });
                            },
                            dropdownColor: Theme.of(context).backgroundColor,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ),
                    ],
                    ),
                  ),
                  SizedBox(height: 50,),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 20,right: 20),
                  //   child: ListTile(
                  //     title: Text(AppLocalizations.of(context).lang,style: TextStyle(color: Colors.grey.shade700),),
                  //     trailing: DropdownButtonHideUnderline(
                  //       child: DropdownButton<String>(
                  //         items: [
                  //           DropdownMenuItem<String>(value: 'en',child: Text("english")),
                  //           DropdownMenuItem<String>(value: 'ar',child: Text("عربي"))
                  //         ],
                  //         onChanged: (String? newvalue) {
                  //           chprov.changeLang(newvalue!);
                  //           if (kDebugMode) {
                  //             print(chprov.currentLang);
                  //           }
                  //           setState(() {
                  //             languageChange = newvalue;
                  //           });
                  //         },
                  //         dropdownColor: Theme.of(context).backgroundColor,
                  //         style: TextStyle(color: Colors.grey.shade700),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Text(AppLocalizations.of(context).login,
                    style: TextStyle(color: Theme.of(context).textTheme.titleLarge!.color,
                  fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                  fontWeight: Theme.of(context).textTheme.titleLarge!.fontWeight,),),
                  SizedBox(height: 50,),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: emailController,
                      onChanged: (val)async {
                        isButtonActiveEmail = formkey
                            .currentState!
                            .validate();
                        isButtonActiveEmail
                            ? setState(() {})
                            : null;
                      },
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                          // return "name is required";
                        }
                        else {
                          setState(() {
                            erroremail = 'n';
                          });
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context).email,
                          errorStyle: TextStyle(color: erroremail==''?Colors.red:Colors.green,),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(25)),
                            borderSide: erroremail=='n'?
                            const BorderSide(
                                color: Colors.transparent)
                                : const BorderSide(
                                color: Colors.redAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(25)),
                            borderSide: erroremail=='n'
                                ? const BorderSide(
                                color: Colors.transparent):
                            const BorderSide(
                                color: Colors.transparent),
                          ),
                          // fillColor: Color(0xFFFCE4EC),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.person_outline,
                            // color: Color(0xFFF48FB1),
                          ),
                          suffixIcon: InkWell(
                            child: Icon(Icons.clear),
                            onTap: (){
                              emailController.clear();
                            },
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      obscureText: _isHidden,
                      onChanged: (val)async {
                        isButtonActivePass = formkey
                            .currentState!
                            .validate();
                        isButtonActivePass
                            ? setState(() {})
                            : null;
                      },
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                                .hasMatch(value)) {
                          // return "password is required";
                        } else {
                          setState(() {
                            errorpass = 'n';
                          });
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context).password,
                          errorStyle: TextStyle(color: errorpass==''?Colors.red:Colors.green,),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.lock_outline,),
                          suffixIcon: InkWell(
                          child: Icon(
                            _isHidden ? Icons.visibility : Icons.visibility_off,
                          ),
                          onTap: _toggleObscured,
                        ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(25)),
                            borderSide: errorpass=='n'?
                            const BorderSide(
                                color: Colors.transparent)
                                : const BorderSide(
                                color: Colors.redAccent),
                          ),
                          enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(25)),
                          borderSide: errorpass=='n'
                              ? const BorderSide(
                              color: Colors.transparent):
                          const BorderSide(
                              color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  ButtonAsText(
                      text: AppLocalizations.of(context).login,
                      onPressed: (){
                        FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text).then((value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home(email: '${emailController.text}', userName: '')),
                          );
                        }).onError((error, stackTrace) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${error.toString()}")));
                          print("Error ${error.toString()}");
                        });
                      }),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 0.5,
                        color: Color.fromRGBO(215, 190, 105, 1)
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Text(AppLocalizations.of(context).or),
                      ),
                      Container(
                        width: 100,
                        height:0.8,
                        color: Color.fromRGBO(215, 190, 105, 1)
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  ButtonAsIcon(
                      icon: Icons.fingerprint,
                      onPressed: _authenticate),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Image.asset(
                          'assets/images/google.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.fill,
                        ),
                        onTap: ()async{
                          // AuthService().signInWithGoogle();
                            final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
                            final GoogleSignInAuthentication gAuth = await gUser!.authentication;
                            final credential = GoogleAuthProvider.credential(
                              accessToken: gAuth.accessToken,
                              idToken: gAuth.idToken,
                              );
                            await FirebaseAuth.instance.signInWithCredential(credential);
                            print('email: '+gUser.email);
                            print('email: '+gUser.displayName!);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Home(email: '${gUser.email}', userName: '${gUser.displayName}')),
                            );
                        },
                      ),
                      SizedBox(width: 40,),
                      GestureDetector(
                        child: Image.asset(
                          'assets/images/facebook.png',
                          width: 45,
                          height: 45,
                          fit: BoxFit.fill,
                        ),
                        onTap: (){},
                      ),
                    ],
                  ),
                  // SizedBox(height: 20,),
                  Divider(
                    indent: 40,
                    endIndent: 40,
                      color: Color.fromRGBO(215, 190, 105, 1)
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context).donotaccount),
                      TextButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Register()),
                            );
                          },
                          child:Text(AppLocalizations.of(context).register,style: TextStyle(color: Color.fromRGBO(215, 190, 105, 1),fontWeight: FontWeight.bold,fontSize:20),),

                      )
                    ],
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }

  final LocalAuthentication auth = LocalAuthentication();
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
            () => _authorized = authenticated ?
        // 'Authorized'
        // '${Navigator.of(context).pushNamed("home")}'
        '${Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  Home(email: '', userName: '')),
        )}'
            : 'Not Authorized');
  }
}
