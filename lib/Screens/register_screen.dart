import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpauth_004/Models/static_data.dart';
import 'package:gpauth_004/Screens/login_screen.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:material_text_fields/utils/form_validation.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = "/register";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  TwilioFlutter twilioFlutter = TwilioFlutter(
      accountSid: 'AC7e239b4c934da6a7f2d9021be92c3245',
      authToken: 'adcbd0183d28fd95972885551e0fb0b5',
      twilioNumber: '+13203739927');

  @override
  void initState() {
    super.initState();
  }

  String selectedImageSet = '';
  bool _isImageSetSelected = false;
  bool _isOTPVerified = false;
  TextEditingController _mobileNumber = TextEditingController();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _middleName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _otp = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      // rgba(205,209,212,255)
      color: const Color.fromRGBO(205, 209, 212, 1),
      // color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              )
            ],
          ),
          // const SizedBox(height: 8),
          Text(
            'Create Your Account',
            style: GoogleFonts.inter(
              fontSize: 23,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 35),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.09),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.12,
                              child: MaterialTextField(
                                controller: _firstName,
                                keyboardType: TextInputType.name,
                                hint: 'First Name',

                                labelText: 'First Name',
                                textInputAction: TextInputAction.next,
                                prefixIcon: Icon(Icons.person),
                                //  controller: _emailTextController,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.115,
                              child: MaterialTextField(
                                controller: _middleName,
                                keyboardType: TextInputType.name,
                                hint: 'Middle Name',

                                labelText: 'Middle Name',
                                textInputAction: TextInputAction.next,
                                prefixIcon: Icon(Icons.person),
                                //  controller: _emailTextController,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.12,
                              child: MaterialTextField(
                                controller: _lastName,
                                keyboardType: TextInputType.name,
                                hint: 'Last Name',

                                labelText: 'Last Name',
                                textInputAction: TextInputAction.next,
                                prefixIcon: Icon(Icons.person),
                                //  controller: _emailTextController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: MaterialTextField(
                                controller: _username,
                                keyboardType: TextInputType.none,
                                hint: 'Username',

                                labelText: 'Username',
                                textInputAction: TextInputAction.next,
                                prefixIcon:
                                    Icon(Icons.person_add_alt_1_rounded),
                                //  controller: _emailTextController,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.22,
                              child: MaterialTextField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                hint: 'Email',

                                labelText: 'Email',
                                textInputAction: TextInputAction.next,
                                prefixIcon: Icon(Icons.email_outlined),
                                //  controller: _emailTextController,
                                validator: FormValidation.emailTextField,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.22,
                              child: MaterialTextField(
                                controller: _mobileNumber,
                                keyboardType: TextInputType.number,
                                hint: 'Mobile Number',

                                labelText: 'Mobile Number',
                                textInputAction: TextInputAction.next,
                                prefixIcon:
                                    const Icon(Icons.phone_android_rounded),
                                //  controller: _emailTextController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.22,
                              child: MaterialTextField(
                                controller: _otp,
                                onChanged: (value) {
                                  if (value.length == 6) {
                                    if (int.parse(value) != StaticData.otp) {
                                      Fluttertoast.showToast(
                                          msg: "Enter Valid OTP");
                                      _isOTPVerified = false;
                                    } else {
                                      _isOTPVerified = true;
                                    }
                                  }
                                },

                                keyboardType: TextInputType.number,
                                hint: 'Enter OTP',
                                labelText: 'Enter OTP',
                                textInputAction: TextInputAction.next,
                                prefixIcon: Icon(Icons.password_rounded),
                                //  controller: _emailTextController,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.062,
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black),
                                  onPressed: () {
                                    StaticData.generateOTP();
                                    twilioFlutter.sendSMS(
                                        toNumber: "+91${_mobileNumber.text}",
                                        messageBody:
                                            'Your OTP is ${StaticData.otp}');
                                  },
                                  child: const Text("Get OTP")),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: DropdownSearch<String>(
                                  items: const [
                                    "Select Image Set",
                                    "Animals",
                                    "Flowers",
                                    "Great Places",
                                  ],
                                  dropdownDecoratorProps:
                                      const DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                        labelText: "Select Image Set",
                                        hintText: "Select Image Set",
                                        prefixIcon: Icon(Icons.image_rounded),
                                        contentPadding:
                                            EdgeInsets.only(left: 20)),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      if (!value!
                                          .contains("Select Image Set")) {
                                        selectedImageSet =
                                            value.trim().toLowerCase();
                                        _isImageSetSelected = true;
                                      } else {
                                        _isImageSetSelected = false;
                                      }
                                    });
                                  },
                                  selectedItem: null,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: const VerticalDivider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    // color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _isImageSetSelected
                            ? FutureBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                future: FirebaseFirestore.instance
                                    .collection('GPAuth')
                                    .doc(selectedImageSet)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    final data = snapshot.data!.data();
                                    print(data);
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.51,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50.0, right: 50.0),
                                        child: GridView.builder(
                                          itemCount: 9,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  crossAxisSpacing: 10,
                                                  mainAxisSpacing: 10,
                                                  childAspectRatio: 1.5 / 1.3),
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                print(
                                                    "Image ${index + 1} is TAPPED");
                                              },
                                              child: Image.network(
                                                data!['imageSet'][index],
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                })
                            : Container(
                                child: Text(
                                  "Please Select a Image Set",
                                  style: GoogleFonts.nunito(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.20,
              height: MediaQuery.of(context).size.height * 0.06,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: () {},
                    child: Text(
                      "Register",
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              )),
          const SizedBox(
            height: 5,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already a member?",
                style: GoogleFonts.nunito(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(LoginScreen.routeName);
                },
                child: Text(
                  "Login",
                  style: GoogleFonts.nunito(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
}





          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 150),
          //   child: MaterialTextField(
          //      keyboardType: TextInputType.number,
          //     hint: 'Email / Username',

          //     labelText: 'Email / Username',
          //     textInputAction: TextInputAction.next,
          //     prefixIcon: Icon(Icons.email_outlined),
          //     //  controller: _emailTextController,
          //      
          //   ),
          // ),
          // const SizedBox(height: 40),
          // Container(
          //   height: MediaQuery.of(context).size.height * 0.45,
          //   width: MediaQuery.of(context).size.width * 0.50,
          //   child: Padding(
          //     padding: const EdgeInsets.only(left: 160.0, right: 160.0),
          //     child: GridView.builder(
          //       itemCount: 9,
          //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //           crossAxisCount: 3,
          //           crossAxisSpacing: 10,
          //           mainAxisSpacing: 10,
          //           childAspectRatio: 1.5 / 1.3),
          //       itemBuilder: (context, index) {
          //         return Image.network(
          //           "https://picsum.photos/200",
          //           fit: BoxFit.cover,
          //         );
          //       },
          //     ),
          //   ),
          // ),
          // Row(
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.only(left: 250.0),
          //       child: Text("00:30",
          //           style: GoogleFonts.nunito(
          //               fontSize: 16,
          //               fontWeight: FontWeight.bold,
          //               color: Colors.grey)),
          //     ),
          //     SizedBox(
          //       width: MediaQuery.of(context).size.width * 0.1,
          //     ),
          //     SizedBox(
          //       width: MediaQuery.of(context).size.width * 0.062,
          //       height: MediaQuery.of(context).size.height * 0.05,
          //       child: ElevatedButton(
          //         style: ElevatedButton.styleFrom(
          //           backgroundColor: Colors.black,
          //         ),
          //         onPressed: () {},
          //         child: Row(
          //           children: [
          //             Text("Skip",
          //                 style: GoogleFonts.nunito(
          //                     fontSize: 16, fontWeight: FontWeight.bold)),
          //             const Icon(Icons.chevron_right_rounded)
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width * 0.20,
          //   height: MediaQuery.of(context).size.height * 0.07,
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //         backgroundColor: Colors.black,
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(25))),
          //     onPressed: () {},
          //     child: Text("Login",
          //         style: GoogleFonts.nunito(
          //             fontSize: 20, fontWeight: FontWeight.bold)),
          //   ),
          // ),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.025,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       "Already a member?",
          //       style: GoogleFonts.nunito(
          //           color: Colors.grey[400],
          //           fontSize: 14,
          //           fontWeight: FontWeight.bold),
          //     ),
          //     TextButton(
          //       onPressed: () {
          //         Navigator.of(context).pushNamed(LoginScreen.routeName);
          //       },
          //       child: Text(
          //         "Login",
          //         style: GoogleFonts.nunito(
          //             color: Colors.black,
          //             fontSize: 14,
          //             fontWeight: FontWeight.bold),
          //       ),
          //     )
          //   ],
          // )