// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class FarmerRegistration extends StatefulWidget {
  const FarmerRegistration(
      {super.key, required this.nameController, required this.emailController});

  final TextEditingController nameController;
  final TextEditingController emailController;

  @override
  State<FarmerRegistration> createState() => _FarmerRegistrationState();
}

class _FarmerRegistrationState extends State<FarmerRegistration> {
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
