import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:test_web/screens/auth/login_screen.dart';
import 'package:test_web/services/auth_services.dart';
import 'package:test_web/utilites/constants.dart';
import 'package:test_web/utilites/helper.dart';
import 'package:test_web/widget/custom_button.dart';
import 'package:test_web/widget/custom_text.dart';
import 'package:test_web/widget/custom_textfield.dart';

import '../../provider/main_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController realTimeTextCtr = TextEditingController();
  TextEditingController fireBaseStoreCtr = TextEditingController();

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
        appBar: AppBar(
          backgroundColor: kGreenColor,
          title: CustomText(
            title: "Home Screen",
          ),
          actions: [
            Container(
                margin: EdgeInsets.only(right: 20),
                child: IconButton(
                    onPressed: () async {
                      provider.changeIsLoading(true);
                      await AuthServices.logout();
                      provider.changeIsLoading(false);
                      Helper.toRemoveUntiScreen(context, LoginScreen());
                    },
                    icon: Icon(Icons.logout)))
          ],
        ),
        body: Container(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              ListTile(
                leading: CustomText(
                  title: "Enter RealTime Text",
                  fontWeight: FontWeight.w500,
                  color: kBlackColor,
                  maxLines: 1,
                ),
                title: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: CustomTextField(
                    controller: realTimeTextCtr,
                    fillColor: kGreyLightColor,
                    isFilled: true,
                    textFontSize: 14,
                    hintFontSize: 14,
                    hintText: "Enter data Realtime",
                    cursorColor: kBlackColor,
                    hintTextColor: kGreyColor,
                  ),
                ),
                trailing: CustomButton(
                  title: "Send",
                  onPressed: () {
                    if (realTimeTextCtr.text.isEmpty) {
                      Helper.showSnack(context, "Enter some text");
                    } else {
                      provider.changeIsLoading(true);
                      AuthServices.postDB
                          .child(
                              DateTime.now().millisecondsSinceEpoch.toString())
                          .set({"name": realTimeTextCtr.text});

                      provider.changeIsLoading(false);
                      realTimeTextCtr.clear();
                    }
                  },
                  textColor: kMainColor,
                  fontWeight: FontWeight.w600,
                  btnWidth: 100,
                  btnHeight: 60,
                  btnColor: kSecondaryColor,
                  btnRadius: 100,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.32,
                child: FirebaseAnimatedList(
                  query: FirebaseDatabase.instance.ref('post'),
                  shrinkWrap: true,
                  reverse: false,
                  itemBuilder: (context, snapshot, animation, index) {
                    Map RealTimeData = snapshot.value as Map;
                    RealTimeData['key'] = snapshot.key;
                    return RealTimeData['name'] == null
                        ? Container(
                            height: Helper.setHeight(context, height: 0.4),
                            alignment: Alignment.center,
                            child: CustomText(title: "No data found"),
                          )
                        : Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin:const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: kGreyLightColor),
                              child: ListTile(
                                visualDensity: VisualDensity(vertical: -4),
                                title: Text(
                                  RealTimeData['name'],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: kBlackColor),
                                ),
                              ),
                            ),
                          );
                  },
                ),
              ),
             const SizedBox(
                height: 20,
              ),
              ListTile(
                leading: CustomText(
                  title: "Enter FireStore Text",
                  fontWeight: FontWeight.w500,
                  color: kBlackColor,
                  maxLines: 1,
                ),
                title: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: CustomTextField(
                    controller: fireBaseStoreCtr,
                    fillColor: kGreyLightColor,
                    isFilled: true,
                    hintFontSize: 14,
                    textFontSize: 14,
                    hintText: "Enter data firestore",
                    cursorColor: kBlackColor,
                    hintTextColor: kGreyColor,
                  ),
                ),
                trailing: CustomButton(
                  title: "Send",
                  onPressed: () {
                    if (fireBaseStoreCtr.text.isEmpty) {
                      Helper.showSnack(context, "Enter some text");
                    } else {
                      provider.changeIsLoading(true);
                      AuthServices.postRef
                          .doc(DateTime.now().millisecondsSinceEpoch.toString())
                          .set({"name": fireBaseStoreCtr.text});
                      provider.changeIsLoading(false);
                      fireBaseStoreCtr.clear();
                    }
                  },
                  textColor: kMainColor,
                  fontWeight: FontWeight.w600,
                  btnWidth: 100,
                  btnHeight: 60,
                  btnColor: kSecondaryColor,
                  btnRadius: 100,
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("post").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: kSecondaryColor,
                      ),
                    );
                  }
                  return snapshot.data!.docs.isEmpty
                      ? Container(
                          height: Helper.setHeight(context, height: 0.4),
                          alignment: Alignment.center,
                          child: CustomText(title: "No data found"),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            reverse: false,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: kGreyLightColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    visualDensity: VisualDensity(vertical: -4),
                                    title: CustomText(
                                      title: snapshot.data!.docs[index]["name"],
                                      fontSize: 14,
                                      color: kBlackColor,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
