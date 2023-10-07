import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:test_web/screens/auth/sign_up_screen.dart';
import 'package:test_web/screens/home/home_screen.dart';
import 'package:test_web/utilites/helper.dart';

import '../../provider/main_provider.dart';
import '../../services/auth_services.dart';
import '../../utilites/constants.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text.dart';
import '../../widget/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailCtr = TextEditingController();
  TextEditingController passwordCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<MainProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: Provider.of<MainProvider>(context).isLoading,
      progressIndicator: CircularProgressIndicator(
        color: kSecondaryColor,
        strokeWidth: 5,
      ),
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: kGreyLightColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.5,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: kMainColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      title: "Login",
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: kGreenColor,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    CustomTextField(
                        controller: emailCtr,
                        fillColor: kGreyLightColor,
                        isFilled: true,
                        hintText: "Email",
                        cursorColor: kBlackColor,
                        hintTextColor: kGreyColor,
                        suffixIcon: Icon(Icons.email)),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: passwordCtr,
                      fillColor: kGreyLightColor,
                      isFilled: true,
                      hintText: "Password",
                      obscureText: true,
                      cursorColor: kBlackColor,
                      hintTextColor: kGreyColor,
                      suffixIcon: Icon(Icons.lock),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    CustomButton(
                      onPressed: () async {
                        try {
                          String pattern =
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regExp = RegExp(pattern);
                          if (emailCtr.text.isEmpty &&
                              passwordCtr.text.isEmpty) {
                            Helper.showSnack(context,
                                "Please fill all the fields to continue");
                          } else if (!regExp.hasMatch(emailCtr.text)) {
                            Helper.showSnack(context, "Invalid Email");
                          } else if (passwordCtr.text.length < 8) {
                            Helper.showSnack(context,
                                "Password must be at least 8 characters long");
                          } else {
                            provider.changeIsLoading(true);
                            var result = await AuthServices.signIn(
                              email: emailCtr.text,
                              password: passwordCtr.text,
                            );
                            if (result == "Success") {
                              var user = await AuthServices.auth.currentUser;
                              // var userMap =
                              //     await AuthServices.getUserDetails(user!.uid);
                              provider.changeIsLoading(false);
                              Helper.toRemoveUntiScreen(context, HomeScreen());
                            } else {
                              // if it is not registered successfully we need to show an error from firebase may be user is already registered that's why it is causing issue
                              provider.changeIsLoading(false);
                              Helper.showSnack(context, result);
                            }
                          }
                        } catch (e) {
                          provider.changeIsLoading(false);
                          Helper.showSnack(context, e.toString());
                        }
                      },
                      title: "Login",
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      btnRadius: 100,
                      btnColor: kGreenColor,
                      textColor: kMainColor,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: InkWell(
                            onTap: () {
                              Helper.toScreen(context, SignUpScreen());
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: kGreenColor))),
                              child: CustomText(
                                title: "Go to Signup Page",
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: kGreenColor,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
