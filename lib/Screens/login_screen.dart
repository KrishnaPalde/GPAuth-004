import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gpauth_004/Models/Color.dart';
import 'package:gpauth_004/Models/database.dart';
import 'package:gpauth_004/Screens/register_screen.dart';
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
  bool isEnabled = true;
  List<int> _selectedImages = [];
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
                            return;
                          }
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
                    ? FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance
                            .collection('GPAuth')
                            .doc(_user['data'].imageset)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            final data = snapshot.data!.data();
                            print(data);
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.45,
                              width: MediaQuery.of(context).size.width * 0.50,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 160.0, right: 160.0),
                                child: GridView.builder(
                                  itemCount: 9,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          childAspectRatio: 1.5 / 1.3),
                                  itemBuilder: (context, index) {
                                    if (_selectedImages.contains(index)) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedImages.remove(index);
                                          });
                                        },
                                        child: Image.asset(
                                          "assets/images/double-tick.png",
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedImages.add(index);
                                          });
                                        },
                                        child: Image.network(
                                          data!['imageSet'][index],
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.45,
                              width: MediaQuery.of(context).size.width * 0.50,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 160.0, right: 160.0),
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
                            );
                          }
                        },
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
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 400.0),
                      child: !isEnabled
                          ? CountdownTimer(
                              endTime: DateTime.now().millisecondsSinceEpoch +
                                  1000 * 30,
                              onEnd: () {
                                print("Completed");
                                setState(() {});
                              },
                              widgetBuilder: (_, time) {
                                if (time == null) {
                                  return Container();
                                }
                                if (time.sec.toString().length == 1) {
                                  return Text(
                                    '00:0${time.sec}',
                                    style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  );
                                }
                                return Text(
                                  '00:${time.sec}',
                                  style: GoogleFonts.nunito(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                );
                              },
                            )
                          : Container(),
                      // Text("00:30",
                      // style: GoogleFonts.nunito(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold,
                      //     color: Colors.grey)),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    !isEnabled
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.062,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                              ),
                              onPressed: () {},
                              child: Row(
                                children: [
                                  Text("Skip",
                                      style: GoogleFonts.nunito(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const Icon(Icons.chevron_right_rounded)
                                ],
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
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
