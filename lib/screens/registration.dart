// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:victu/objects/userData.dart';
import 'package:victu/screens/home_page.dart';
import 'package:victu/screens/login.dart';
import 'package:victu/screens/userRegistration.dart';
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

  UserType? userType = UserType.student;
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

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Login(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffebebeb),
      body: Stepper(
        type: StepperType.horizontal,
        steps: getSteps(),
        currentStep: currentStep,
        onStepContinue: () {
          final isLastStep = currentStep == getSteps().length - 1;
          if (isLastStep) {
            print("Complete registration");
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
              onPressed: details.onStepCancel,
              child: const Text('Cancel'),
            ),
          ]);
        },
      ),
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
                      title: const Text('Student'),
                      leading: Radio<UserType>(
                        value: UserType.student,
                        groupValue: userType,
                        onChanged: (UserType? value) {
                          setState(() {
                            userType = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Canteen'),
                      leading: Radio<UserType>(
                        value: UserType.canteen,
                        groupValue: userType,
                        onChanged: (UserType? value) {
                          setState(() {
                            userType = value;
                          });
                        },
                      ),
                    ),
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
                  ],
                ))),
        Step(
          isActive: currentStep >= 1,
          title: const Text("User Registration"),
          content: userType == UserType.student
              ? UserRegistration(
                  nameController: nameController,
                  emailController: emailController,
                  ageController: ageController,
                  heightController: heightController,
                  weightController: weightController)
              : userType == UserType.canteen
                  ? CanteenRegistration(
                      nameController: nameController,
                      emailController: emailController,
                      contactNumberController: contactNumberController,
                      canteenNameController: canteenNameController)
                  : const Text("Farmer"),
        )
      ];
}

class CanteenRegistration extends StatefulWidget {
  const CanteenRegistration(
      {super.key,
      required this.nameController,
      required this.emailController,
      required this.contactNumberController,
      required this.canteenNameController});

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController contactNumberController;
  final TextEditingController canteenNameController;

  @override
  State<CanteenRegistration> createState() => _CanteenRegistrationState();
}

class _CanteenRegistrationState extends State<CanteenRegistration> {
  var currentSelectedValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            ///***If you have exported images you must have to copy those images in assets/images directory.
            const Image(
              image: NetworkImage(
                  "https://cdn4.iconfinder.com/data/icons/security-overcolor/512/password_code-256.png"),
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: Text(
                "Let's Get Started!",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 22,
                  color: Color(0xff2d9871),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(50, 8, 50, 0),
              child: Text(
                "Provide your business details so we can get you all set up.",
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff000000),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: TextField(
                enabled: false,
                controller: widget.nameController,
                obscureText: false,
                textAlign: TextAlign.start,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff000000),
                ),
                decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  hintText: "Name",
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  filled: true,
                  fillColor: const Color(0xffebebeb),
                  isDense: false,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  prefixIcon: const Icon(Icons.person,
                      color: Color(0xff212435), size: 24),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: TextField(
                enabled: false,
                controller: widget.emailController,
                obscureText: false,
                textAlign: TextAlign.start,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff000000),
                ),
                decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  hintText: "Email Address",
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  filled: true,
                  fillColor: const Color(0xffebebeb),
                  isDense: false,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  prefixIcon: const Icon(Icons.mail,
                      color: Color(0xff212435), size: 24),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: TextField(
                controller: widget.canteenNameController,
                obscureText: false,
                textAlign: TextAlign.start,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff000000),
                ),
                decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  hintText: "Canteen Name",
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  filled: true,
                  fillColor: const Color(0xffffffff),
                  isDense: false,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  prefixIcon: const Icon(Icons.shopping_cart,
                      color: Color(0xff212435), size: 24),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                controller: widget.contactNumberController,
                obscureText: false,
                textAlign: TextAlign.start,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff000000),
                ),
                decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: Color(0xff2d9871), width: 1),
                  ),
                  hintText: "Contact number (09xxxxxxxxx)",
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff000000),
                  ),
                  filled: true,
                  fillColor: const Color(0xffffffff),
                  isDense: false,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  prefixIcon: const Icon(Icons.phone,
                      color: Color(0xff212435), size: 24),
                ),
              ),
            ),
            Row(children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Container(
                        width: 130,
                        height: 50,
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 13),
                        decoration: BoxDecoration(
                          color: const Color(0xffffffff),
                          border: Border.all(
                              color: const Color(0xff2d9871), width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            hint: const Text("School"),
                            value: currentSelectedValue,
                            items: ["Sample School 1", "Sample School 2"]
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            style: const TextStyle(
                              color: Color(0xff000000),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                            ),
                            onChanged: (newValue) {
                              setState(() {
                                currentSelectedValue = newValue;
                              });
                            },
                            icon: const Icon(Icons.account_balance),
                            iconSize: 24,
                            iconEnabledColor: const Color(0xff212435),
                            elevation: 8,
                            isExpanded: true,
                          ),
                        )),
                  ))
            ]),
          ],
        ),
      ),
    );
  }
}

enum UserType { student, canteen, farmer }
