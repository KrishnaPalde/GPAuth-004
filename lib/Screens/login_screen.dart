import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpauth_004/Models/Color.dart';
import 'package:gpauth_004/Models/database.dart';
import 'package:gpauth_004/Models/gpauth_algorithms.dart';
import 'package:gpauth_004/Models/gpauth_encryption.dart';
import 'package:gpauth_004/Models/static_data.dart';
import 'package:gpauth_004/Screens/register_screen.dart';
import 'package:gpauth_004/Widgets/countdown_timer.dart';
import 'package:material_text_fields/material_text_fields.dart';
import 'package:material_text_fields/utils/form_validation.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailOrUsername = TextEditingController();
  Map<String, dynamic> _user = {'status': -2, 'data': null};
  Map<String, dynamic> _imageSet = {'status': -2, 'data': null};

  bool isEnabled = true;
  List<int> _selectedImages = [];
  void maliciousActivityDetected() {
    setState(() {
      GPAuthAlgorithms.removeAllSelectedImage();
      GPAuthAlgorithms.currentImageSet.clear();
      GPAuthAlgorithms.getRandomImageSetExceptCurrentSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 0.35,
          color: Theme.of(context).primaryColor,
          child: Image.asset(
            'assets/images/login-left.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 0.65,
          child: Padding(
            padding: const EdgeInsets.only(left: 100, top: 50, right: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome back',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Login to your account',
                  style: GoogleFonts.inter(
                    fontSize: 23,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 35),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: GestureDetector(
                    onDoubleTap: () {
                      setState(() {
                        isEnabled = true;
                      });
                    },
                    child: MaterialTextField(
                      controller: _emailOrUsername,
                      enabled: isEnabled,
                      keyboardType: TextInputType.emailAddress,
                      hint: 'Email / Username',
                      onChanged: (value) async {
                        if (value.length == 8) {
                          _user = await getGPAuthUserFromFirebase(value);
                          if (_user['status'] == -1) {
                            Fluttertoast.showToast(
                              msg: "Invalid Username",
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_LONG,
                            );
                            return;
                          }
                          _imageSet = await getImageSetDataFromFirebase(
                              _user['data'].imageset.toString());
                          // GPAuthAlgorithms.populatePasswordImageSet(
                          //     GPAuthEncryption.decryptGPAuthPassword(
                          //             _user['data'].encryptedPString)
                          //         .split(";"));

                          if (_imageSet['status'] == -1) {
                            Fluttertoast.showToast(
                                msg: "Technical Error",
                                backgroundColor: Colors.black,
                                textColor: Colors.white);
                            return;
                          }
                          // StaticData.imageSet = _imageSet['data'].imagesetName;
                          // StaticData.images = _imageSet['data'].imageSet;
                          GPAuthAlgorithms.populatePasswordImageSet(
                              ['polar-bear', 'fox', 'zebra-left']);
                          GPAuthAlgorithms.getFirstImageSet();
                          setState(() {
                            isEnabled = false;
                          });
                        }
                      },
                      labelText: 'Email / Username',
                      textInputAction: TextInputAction.next,
                      prefixIcon: const Icon(Icons.email_outlined),
                      //  controller: _emailTextController,
                      validator: FormValidation.emailTextField,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                !isEnabled
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        width: MediaQuery.of(context).size.width * 0.50,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 160.0, right: 160.0),
                          child: GridView.builder(
                            itemCount: 9,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 1.5 / 1.3),
                            itemBuilder: (context, index) {
                              // print(GPAuthAlgorithms.passwordImageSet);
                              if (GPAuthAlgorithms.selectedImages.contains(
                                  GPAuthAlgorithms.currentImageSet.singleWhere(
                                      (element) =>
                                          element['index'] ==
                                          GPAuthAlgorithms
                                                  .currentImageSet[index]
                                              ['index']))) {
                                final data = GPAuthAlgorithms
                                    .getSingleRandomImageExceptCurrentSet();
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (GPAuthAlgorithms
                                              .selectedImages.length <
                                          3) {
                                        GPAuthAlgorithms
                                            .selectImageFromCurrentSet(
                                                GPAuthAlgorithms
                                                        .currentImageSet[index]
                                                    ['index']);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Select Only 3 Images.\nClick on Clear Button");
                                      }
                                    });
                                  },
                                  child: Image.network(
                                    data['image'],
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (GPAuthAlgorithms
                                              .selectedImages.length <
                                          3) {
                                        GPAuthAlgorithms
                                            .selectImageFromCurrentSet(
                                                GPAuthAlgorithms
                                                        .currentImageSet[index]
                                                    ['index']);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Select Only 3 Images.\nClick on Clear Button");
                                      }
                                    });
                                  },
                                  child: Image.network(
                                    GPAuthAlgorithms.currentImageSet[index]
                                        ['image'],
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.45,
                        width: MediaQuery.of(context).size.width * 0.50,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 160.0, right: 160.0),
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
                                  print("Image ${index + 1} is TAPPED");
                                },
                                child: Image.network(
                                  "https://picsum.photos/200",
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                !isEnabled
                    ? Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.12,
                            right: MediaQuery.of(context).size.width * 0.12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.061,
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding: const EdgeInsets.all(5)),
                                onPressed: () {
                                  GPAuthAlgorithms.removeAllSelectedImage();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.clear_rounded),
                                    Text(" Clear",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.nunito(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),

                            const CustomCountDownTimer(),
                            // Text("00:30",
                            // style: GoogleFonts.nunito(
                            //     fontSize: 16,
                            //     fontWeight: FontWeight.bold,
                            //     color: Colors.grey)),

                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width * 0.02,
                            // ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.050,
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding: const EdgeInsets.only(left: 7)),
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Skip",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.nunito(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    const Icon(Icons.chevron_right_rounded)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.20,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    onPressed: () {},
                    child: Text("Login",
                        style: GoogleFonts.nunito(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member?",
                      style: GoogleFonts.nunito(
                          color: Colors.grey[400],
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(RegisterScreen.routeName);
                      },
                      child: Text(
                        "Register",
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
          ),
        ),
      ],
    ));
  }
}

// Row(
//         children: [
//           Expanded(
//               //<-- Expanded widget
//               child: Image.asset(
//             'assets/images/login1.jpg',
//             fit: BoxFit.cover,
//             // width: MediaQuery.of(context).size.width * 0.2,
//           )),
//           Expanded(
//             //<-- Expanded widget
//             child: Container(
//               constraints: const BoxConstraints(maxWidth: 21),
//               padding: const EdgeInsets.symmetric(horizontal: 50),
// child: Column(
//   mainAxisAlignment: MainAxisAlignment.center,
//   crossAxisAlignment: CrossAxisAlignment.stretch,
//   children: [
//     Text(
//       'Welcome back',
//       style: GoogleFonts.inter(
//         fontSize: 17,
//         color: Colors.black,
//       ),
//     ),
//     const SizedBox(height: 8),
//     Text(
//       'Login to your account',
//       style: GoogleFonts.inter(
//         fontSize: 23,
//         color: Colors.black,
//         fontWeight: FontWeight.w700,
//       ),
//     ),
//     const SizedBox(height: 35),
//     TextField(
//       keyboardType: TextInputType.emailAddress,
//       decoration: InputDecoration(
//           hintText: 'Email ID',
//           hintStyle: GoogleFonts.nunito(
//               color: Colors.grey[400],
//               fontSize: 20,
//               fontWeight: FontWeight.bold),
//           enabledBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                   color: Theme.of(context).primaryColor,
//                   width: 3)),
//           contentPadding: const EdgeInsets.symmetric(
//               vertical: 8, horizontal: 2)),
//     ),
//     const SizedBox(height: 20),
//     TextField(
//       keyboardType: TextInputType.name,
//       decoration: InputDecoration(
//           hintText: 'Username',
//           hintStyle: GoogleFonts.nunito(
//               color: Colors.grey[400],
//               fontSize: 20,
//               fontWeight: FontWeight.bold),
//           enabledBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                   color: Theme.of(context).primaryColor,
//                   width: 3)),
//           contentPadding: const EdgeInsets.symmetric(
//               vertical: 8, horizontal: 2)),
//     ),
//     const SizedBox(height: 25),
//     Row(
//         //...
//         ),
//     const SizedBox(height: 30),
//     TextButton(
//       onPressed: () {},
//       child: Text("Login"),
//     ),
//     const SizedBox(height: 15),
//     TextButton(
//       onPressed: () {},
//       child: Text("Demo"),
//     ),
//   ],
// ),
//             ),
//           ),
//         ],
//       ),

// MaterialTextField(
//                       keyboardType: TextInputType.emailAddress,
//                       hint: 'Email / Username',

//                       labelText: 'Email / Username',
//                       textInputAction: TextInputAction.next,
//                       prefixIcon: const Icon(Icons.email_outlined),
//                       //  controller: _emailTextController,
//                       validator: FormValidation.emailTextField,
//                     ),
