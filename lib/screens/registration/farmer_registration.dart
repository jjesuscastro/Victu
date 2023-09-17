// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:philippines_rpcmb/philippines_rpcmb.dart';

class FarmerRegistration extends StatefulWidget {
  const FarmerRegistration(
      {super.key,
      required this.businessNameController,
      required this.nameController,
      required this.emailController,
      required this.contactNumberController,
      required this.locationCallback});

  final TextEditingController businessNameController;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController contactNumberController;
  final Function locationCallback;

  @override
  State<FarmerRegistration> createState() => _FarmerRegistrationState();
}

class _FarmerRegistrationState extends State<FarmerRegistration> {
  Region? region;
  Province? province;
  Municipality? municipality;

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
                "Provide your farm's details so we can tell vendors about you.",
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
                controller: widget.businessNameController,
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
                  hintText: "Business Name",
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
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Container(
                      width: 130,
                      height: 54,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 13),
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(
                            color: const Color(0xff2d9871), width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: PhilippineRegionDropdownView(
                          onChanged: (Region? value) {
                            setState(
                              () {
                                if (region != value) {
                                  province = null;
                                  municipality = null;
                                }
                                region = value;
                              },
                            );
                          },
                          value: region,
                          itemBuilder: (context, value) {
                            String regionName = "";

                            switch (value.regionName) {
                              case "REGION I":
                                regionName = "ILOCOS REGION";
                              case "REGION II":
                                regionName = "CAGAYAN VALLEY";
                              case "REGION III":
                                regionName = "CENTRAL LUZON";
                              case "REGION IV-A":
                                regionName = "CALABARZON";
                              case "REGION IV-B":
                                regionName = "MIMAROPA";
                              case "REGION V":
                                regionName = "BICOL REGION";
                              case "REGION VI":
                                regionName = "WESTERN VISAYAS";
                              case "REGION VII":
                                regionName = "CENTRAL VISAYAS";
                              case "REGION VIII":
                                regionName = "EASTERN VISAYAS";
                              case "REGION IX":
                                regionName = "ZAMBOANGA PENINSULA";
                              case "REGION X":
                                regionName = "NORTHERN MINDANAO";
                              case "REGION XI":
                                regionName = "DAVAO REGION";
                              case "REGION XII":
                                regionName = "SOCCSKSARGEN";
                              case "REGION XIII":
                                regionName = "CARAGA";
                            }

                            return DropdownMenuItem(
                                value: value,
                                child: Text(regionName == ""
                                    ? value.regionName
                                    : regionName));
                          }),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Container(
                      width: 130,
                      height: 54,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 13),
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(
                            color: const Color(0xff2d9871), width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: PhilippineProvinceDropdownView(
                        provinces: region?.provinces ?? [],
                        onChanged: (Province? value) {
                          setState(() {
                            if (province != value) {
                              municipality = null;
                            }
                            province = value;
                          });
                        },
                        value: province,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Container(
                      width: 130,
                      height: 54,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 13),
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(
                            color: const Color(0xff2d9871), width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: PhilippineMunicipalityDropdownView(
                        municipalities: province?.municipalities ?? [],
                        onChanged: (value) {
                          setState(() {
                            municipality = value;

                            widget.locationCallback(
                                "${province!.id}|${municipality!.id}");
                          });
                        },
                        value: municipality,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
