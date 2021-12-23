import 'dart:ui';
import 'package:crystal/controller/authController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterPage extends GetWidget<AuthController> {
  String _email;
  String _password;
  final GlobalKey<FormState>_formKey = GlobalKey<FormState>();
  final isHidden = true.obs; //For password view toggle

  final _isPswdEightCharacters = false.obs;
  final _isPswdaNumber = false.obs;
  final _isPswdUppper = false.obs;
  final _isPswdLower = false.obs;
  final _isPswdSpecialChar = false.obs;

 onPasswordChange(String password) {
   final numeriReg = RegExp(r'(?=.*?[0-9])');
   final upperReg = RegExp(r'(?=.*?[A-Z])');
   final lowerReg = RegExp(r'(?=.*?[a-z])');
   final specialReg = RegExp(r'(?=.*?[!@#\$&*~._-])');

   _isPswdEightCharacters.value = false;
   if(password.length >= 8)
     _isPswdEightCharacters.value = true;

   _isPswdaNumber.value = false;
   if(numeriReg.hasMatch(password))
     _isPswdaNumber.value = true;

   _isPswdUppper.value = false;
   if(upperReg.hasMatch(password))
     _isPswdUppper.value = true;

   _isPswdLower.value = false;
   if(lowerReg.hasMatch(password))
     _isPswdLower.value = true;

   _isPswdSpecialChar.value = false;
   if(specialReg.hasMatch(password))
     _isPswdSpecialChar.value = true;
 }

  void _togglePasswordView(){
    isHidden.value = !isHidden.value;
  }
  Widget _emailField () {
    return TextFormField(
      validator: (String value){
        if(value.isEmpty){
          return "Email is required";
        }
        if(!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+"
            r"(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@"
            r"(?:[a-z0-9]"
            r"(?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]"
            r"(?:[a-z0-9-]*[a-z0-9])?").hasMatch(value)){
          return "Please enter a valid email address";
        }
        return null;
      },
      onSaved: (String value){
        _email = value;
      },
      obscureText: false,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))
      ),
    );
  }
  Widget _passwordField () {
    return Obx(() => TextFormField(
        onChanged: (value){
        _password = value;
        onPasswordChange(value);
      },
      validator: (String pswd) {
        if(pswd.isEmpty){
          return "Password is required";
        }
         else {
          if(!RegExp(
         r'(?=.*?[0-9])'
          r'(?=.*?[A-Z])'
          r'(?=.*?[a-z])'
          r'(?=.*?[!@#\$&*~._-])'
          ).hasMatch(pswd) || pswd.length <8 ) {
            return "Please follow the password requirements";
          }
        }
        return null;
      },
      obscureText: isHidden.value,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          suffix: InkWell(
            onTap: _togglePasswordView,
            child: Icon(isHidden.value ? Icons.visibility_off : Icons.visibility, size: 16,),
          ),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))
      ),
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
                    SizedBox(height: h/30,),
                    _passwordField(),
                    SizedBox(height: 10,),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text("Password requirements:", style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Obx(() =>AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: _isPswdEightCharacters.value ?  Colors.green : Colors.transparent,
                                  border: _isPswdEightCharacters.value ? Border.all(color: Colors.transparent) :
                                  Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              child: Center(child: Icon(Icons.check, color: Colors.white, size: 15,),),
                            )),
                            SizedBox(width: 10,),
                            Text("at least 8 characters")
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Obx(() =>AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: _isPswdaNumber.value ?  Colors.green : Colors.transparent,
                                  border: _isPswdaNumber.value ? Border.all(color: Colors.transparent) :
                                  Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              child: Center(child: Icon(Icons.check, color: Colors.white, size: 15,),),
                            )),
                            SizedBox(width: 10,),
                            Text("at least 1 number")
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Obx(() =>AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: _isPswdUppper.value ?  Colors.green : Colors.transparent,
                                  border: _isPswdUppper.value ? Border.all(color: Colors.transparent) :
                                  Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              child: Center(child: Icon(Icons.check, color: Colors.white, size: 15,),),
                            )),
                            SizedBox(width: 10,),
                            Text("at least 1 uppercase")
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Obx(() =>AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: _isPswdLower.value ?  Colors.green : Colors.transparent,
                                  border: _isPswdLower.value ? Border.all(color: Colors.transparent) :
                                  Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              child: Center(child: Icon(Icons.check, color: Colors.white, size: 15,),),
                            )),
                            SizedBox(width: 10,),
                            Text("at least 1 lowercase")
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          children: [
                            Obx(() =>AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: _isPswdSpecialChar.value ?  Colors.green : Colors.transparent,
                                  border: _isPswdSpecialChar.value ? Border.all(color: Colors.transparent) :
                                  Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              child: Center(child: Icon(Icons.check, color: Colors.white, size: 15,),),
                            )),
                            SizedBox(width: 10,),
                            Text("at least 1 special character")
                          ],
                        ),
                      ],
                    ), //Validation
                    SizedBox(height: h/60,),
                    Material(borderRadius: BorderRadius.circular(30),
                      color: Colors.orangeAccent,
                      child: MaterialButton(
                        minWidth: w,
                        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        onPressed: () {
                          if(!_formKey.currentState.validate()){
                            return ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("invalid email or password")),
                            );
                          }_formKey.currentState.save();
                          controller.SignUp(email: _email, password: _password);
                        },
                        child: Text("Create Account", textAlign: TextAlign.center,
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
                                child: Text('Already have an account? Login'),
                                onTap: () {Get.back();}
                            )
                        )
                      ],
                    ),
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }
}
