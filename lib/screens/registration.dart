// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:victu/objects/user_data.dart';
import 'package:victu/screens/registration/vendor_registration.dart';
import 'package:victu/screens/home_page.dart';
import 'package:victu/screens/registration/farmer_registration.dart';
import 'package:victu/screens/registration/user_registration.dart';
import 'package:victu/utils/database.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  //User Values
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  //Canteen Values
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController canteenNameController = TextEditingController();

  UserType? userType = UserType.consumer;
  var currentSelectedValue;
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    nameController.text = widget._user.displayName!;
    emailController.text = widget._user.email!;
  }

  void newUser(User user) {
    var userData = UserData(user.displayName!, true, 0, 0, 0);

    userData.isRegistered = true;
    userData.displayName = user.displayName!;
    userData.age = int.parse(ageController.text);
    userData.isMale = currentSelectedValue == "Male" ? true : false;
    userData.height = int.parse(heightController.text);
    userData.weight = int.parse(weightController.text);
    userData.type = "student";

    userData.setId(saveUser(user.uid, userData));

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(user: user),
      ),
    );
  }

  // Route _routeToSignInScreen() {
  //   return PageRouteBuilder(
  //     pageBuilder: (context, animation, secondaryAnimation) => const Login(),
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       var begin = const Offset(-1.0, 0.0);
  //       var end = Offset.zero;
  //       var curve = Curves.ease;

  //       var tween =
  //           Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  //       return SlideTransition(
  //         position: animation.drive(tween),
  //         child: child,
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffebebeb),
      body: SafeArea(
          child: Stepper(
        type: StepperType.horizontal,
        steps: getSteps(),
        currentStep: currentStep,
        onStepContinue: () {
          final isLastStep = currentStep == getSteps().length - 1;
          if (isLastStep) {
            // TODO: Save user to DB
          } else {
            currentStep < getSteps().length - 1
                ? setState(() => currentStep++)
                : null;
          }
        },
        onStepCancel: () {
          currentStep == 0 ? null : setState(() => currentStep--);
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 16, 15, 0),
              child: MaterialButton(
                onPressed: details.onStepContinue,
                color: const Color(0xff2d9871),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(16),
                textColor: const Color(0xffffffff),
                height: 45,
                minWidth: MediaQuery.of(context).size.width,
                child: currentStep == getSteps().length - 1
                    ? const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                      )
                    : const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 12),
                  foregroundColor: const Color.fromARGB(255, 90, 90, 90)),
              onPressed: currentStep == getSteps().length - 1
                  ? details.onStepCancel
                  : null,
              child: currentStep == getSteps().length - 1
                  ? const Text('Back')
                  : const Text(""),
            ),
          ]);
        },
      )),
    );
  }

  List<Step> getSteps() => [
        Step(
            isActive: currentStep >= 0,
            title: const Text("User Type"),
            content: Padding(
                padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
                child: Column(
                  children: <Widget>[
                    const Text(
                      "What would you like to register as?",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 18,
                        color: Color(0xff000000),
                      ),
                    ),
                    ListTile(
                      title: const Text('Consumer'),
                      leading: Radio<UserType>(
                        value: UserType.consumer,
                        groupValue: userType,
                        onChanged: (UserType? value) {
                          setState(() {
                            userType = value;
                          });
                        },
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                        child: Text(
                            "Consumers can view the menu for the week and reserve orders.")),
                    ListTile(
                      title: const Text('Vendor'),
                      leading: Radio<UserType>(
                        value: UserType.vendor,
                        groupValue: userType,
                        onChanged: (UserType? value) {
                          setState(() {
                            userType = value;
                          });
                        },
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                        child: Text(
                            "Vendors can curate their weekly menus and view reserved orders.")),
                    ListTile(
                      title: const Text('Farmer'),
                      leading: Radio<UserType>(
                        value: UserType.farmer,
                        groupValue: userType,
                        onChanged: (UserType? value) {
                          setState(() {
                            userType = value;
                          });
                        },
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                        child: Text(
                            "Farmers can list the crops they can provide to help canteens complete their dishes.")),
                  ],
                ))),
        Step(
            isActive: currentStep >= 1,
            title: const Text("User Registration"),
            content: userType == UserType.consumer
                ? UserRegistration(
                    nameController: nameController,
                    emailController: emailController,
                    ageController: ageController,
                    heightController: heightController,
                    weightController: weightController)
                : userType == UserType.vendor
                    ? VendorRegistration(
                        nameController: nameController,
                        emailController: emailController,
                        contactNumberController: contactNumberController,
                        canteenNameController: canteenNameController)
                    : FarmerRegistration(
                        nameController: nameController,
                        emailController: emailController))
      ];
}

enum UserType { consumer, vendor, farmer }
