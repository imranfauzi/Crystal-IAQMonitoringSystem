import 'package:crystal/controller/authController.dart';
import 'package:crystal/view/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends GetWidget<AuthController> {
  String _email;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final isHidden = true.obs;

  void _togglePasswordView(){
    isHidden.value = !isHidden.value;
  }
  Widget _emailField() {
    return TextFormField(
      validator: (String value) {
        if (value.isEmpty) {
          return "Email is required";
        }
        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+"
                r"(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@"
                r"(?:[a-z0-9]"
                r"(?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]"
                r"(?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return "Please enter a valid email address";
        }
        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
      obscureText: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
    );
  }

  Widget _passwordField() {
    return Obx(() => TextFormField(
      validator: (String value) {
        if (value.isEmpty) {
          return "Password is required";
        }
        return null;
      },
      onSaved: (String value) {
        _password = value;
      },
      obscureText: isHidden.value,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          suffixStyle: TextStyle(color: Colors.orange),
          suffix: InkWell(
            onTap: _togglePasswordView,
            child: Icon(isHidden.value ? Icons.visibility_off : Icons.visibility, size: 16,),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Container(
              padding: EdgeInsets.all(36),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(image: AssetImage('assets/images/logo_white.gif')),
                    _emailField(),
                    SizedBox(height: h / 30,),
                    _passwordField(),
                    SizedBox(height: h / 30,),
                    Material(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.orangeAccent,
                      child: MaterialButton(
                        minWidth: w,
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        onPressed: () {
                          if (!_formKey.currentState.validate()) {
                            return
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Invalid email or password")),
                              );}_formKey.currentState.save();
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if(!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          controller.SignIn(email: _email, password: _password);
                        },
                        child: Text("Login", textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: h / 30,
                        ),
                        Center(
                            child: GestureDetector(
                                child: Text('New User? Create Account'),
                                onTap: () {
                                  FocusScopeNode currentFocus = FocusScope.of(context);
                                  if(!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }
                                  Get.to(RegisterPage());
                                }
                            ))
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
