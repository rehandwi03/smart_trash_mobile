// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_trash_mobile/data/bloc/login/login_bloc.dart';
import 'package:smart_trash_mobile/data/models/login.dart';
import 'package:smart_trash_mobile/routes.dart';
import 'package:smart_trash_mobile/utils/constants/colors.dart';
import 'package:smart_trash_mobile/presentation/widgets/input_text.dart';
import 'package:smart_trash_mobile/utils/storage/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final storage = SharedPreferencesService();
  final _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 238, 238, 238),
        body: SafeArea(
            child:
                BlocConsumer<LoginBloc, LoginState>(builder: (context, state) {
          if (state is LoginLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return showLogin();
        }, listener: (context, state) {
          if (state is LoginSuccessState) {
            storage.prefs
                .setString("access_token", state.response.accessToken ?? "");
            storage.prefs
                .setString("refresh_token", state.response.refreshToken ?? "");
            Navigator.pushReplacementNamed(context, Routes.home);
          }
        })));
  }

  Widget showLogin() {
    return Center(
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.5,
        width: MediaQuery.sizeOf(context).width * 0.9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Selamat Datang di ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            SizedBox(
              height: 5,
            ),
            Text(
              "Smart Trash",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(bottom: 20, top: 20),
                    child: Text(
                      "Harap login terlebih dahulu",
                      style: TextStyle(fontSize: 15),
                    )),
              ],
            ),
            inputText("Masukan email", emailController),
            SizedBox(
              height: 20,
            ),
            inputText("Masukan password", passwordController, obsecure: true),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final deviceToken = await _firebaseMessaging.getToken();
                  BlocProvider.of<LoginBloc>(context).add(LoginEvent(
                      LoginRequest(
                          email: emailController.text,
                          password: passwordController.text,
                          deviceToken: deviceToken ?? "")));
                },
                child: Text(
                  'Masuk',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  fixedSize: Size(MediaQuery.sizeOf(context).width, 25),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  backgroundColor: AppColors.greenPrimaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
