import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Custom_Widget/Buttons.dart';
import '../screens/home.dart';
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  final passwordFocusNode = FocusNode();

  bool _isHidden = true;
  bool _isHidden2 = true;
  void _toggleObscured() {
    setState(() {
      _isHidden = !_isHidden;
      if (passwordFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      passwordFocusNode.canRequestFocus = false; // Prevents focus if tap on eye
    });
  }
  void _toggleObscured2() {
    setState(() {
      _isHidden2 = !_isHidden2;
      if (passwordFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      passwordFocusNode.canRequestFocus = false; // Prevents focus if tap on eye
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        iconTheme: const IconThemeData(color: Color.fromRGBO(215, 190, 105, 1),size: 30),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context).register,
                  style: TextStyle(color: Theme.of(context).textTheme.titleLarge!.color,
                  fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                  fontWeight: Theme.of(context).textTheme.titleLarge!.fontWeight,),),
                SizedBox(height: 50,),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).username,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.person_outline,
                        ),
                      suffixIcon: InkWell(
                        child: Icon(Icons.clear),
                        onTap: (){
                          nameController.clear();
                        },
                      )
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).email,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none),
                        // fillColor: Color(0xFFFCE4EC),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.email_outlined,
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
                  child: TextField(
                    controller: passwordController,
                    obscureText: _isHidden,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).password,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                      ),
                      suffixIcon: InkWell(
                        child: Icon(
                          _isHidden ? Icons.visibility : Icons.visibility_off,
                        ),
                        onTap: _toggleObscured,
                      ),
                    ),
                  ),
                ),SizedBox(height: 20,),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: confirmPassController,
                    obscureText: _isHidden2,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).confirmpassword,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                      ),
                      suffixIcon: InkWell(
                        child: Icon(
                          _isHidden2 ? Icons.visibility : Icons.visibility_off,
                        ),
                        onTap: _toggleObscured2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                ButtonAsText(
                    text: AppLocalizations.of(context).register,
                    onPressed: (){
                      FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text).then((value){
                        print("Account Created");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home(email: '${emailController.text}', userName: '')),
                        );
                      }).onError((error, stackTrace) {
                        print("Error ${error.toString()}");
                      });
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
