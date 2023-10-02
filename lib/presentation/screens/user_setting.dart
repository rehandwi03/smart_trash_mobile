import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_trash_mobile/data/bloc/user/user_bloc.dart';
import 'package:smart_trash_mobile/data/models/user.dart';
import 'package:smart_trash_mobile/presentation/widgets/input_text.dart';

class UserSettingScreen extends StatefulWidget {
  const UserSettingScreen({super.key});

  @override
  State<UserSettingScreen> createState() => _UserSettingScreenState();
}

class _UserSettingScreenState extends State<UserSettingScreen> {
  double _buttonSize = 50.0;
  double _pressedButtonSize = 40.0;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _buttonSize = _pressedButtonSize;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _buttonSize = 50.0;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(UserGetEvent());
  }

  void _showPopupForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          child: AlertDialog(
            title: Text("Tambah Pengguna"),
            content: Container(
              margin: EdgeInsets.only(top: 15),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.18,
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  inputText("Masukan email", emailController),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue),
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // to go back to screen after submitting
                  }),
              ElevatedButton(
                  child: Text("Save"),
                  onPressed: () async {
                    context.read<UserBloc>().add(UserAddEvent(
                        request: UserAddRequest(email: emailController.text)));
                  }),
            ],
          ),
        );
      },
    );
  }

  Widget _formWidget(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              inputText("Masukan nama", nameController),
              ElevatedButton(
                onPressed: () {
                  // Perform form submission logic here
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<UserResponse> users = [];
    return Scaffold(
        floatingActionButton: BlocConsumer<UserBloc, UserState>(
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: () {
                _showPopupForm(context);
              },
              child: const Text(
                "+",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
            );
          },
          listener: (context, state) {
            if (state is UserAddSuccess) {
              // Navigator.pushNamed(context, Routes.userSetting);
              context.read<UserBloc>().add(UserGetEvent());
            }
            if (state is UserAddLoading) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Center(
                  child: CircularProgressIndicator(),
                );
                Navigator.pop(context);
              });
            }
          },
        ),
        appBar: AppBar(
          title: const Text(
            "Pengaturan Pengguna",
          ),
          titleTextStyle:
              const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          elevation: 0,
          // backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
            child: BlocConsumer<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserGetLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is UserGetSuccess) {
              users = state.response;
            }

            if (state is UserDeleteLoading) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                const Center(
                  child: CircularProgressIndicator(),
                );
                Navigator.pop(context);
              });
            }

            return showForm(
              context,
              users,
            );
          },
          listener: (context, state) {
            if (state is UserDeleteSuccess) {
              final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Berhasil menghapus pengguna',
                  message: 'Pengguna telah terhapus',
                  contentType: ContentType.success,
                ),
              );

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);
              context.read<UserBloc>().add(UserGetEvent());
            }

            if (state is UserAddSuccess) {
              final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Berhasil menambah pengguna',
                  message: 'User baru telah ditambahkan',
                  contentType: ContentType.success,
                ),
              );

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);
              context.read<UserBloc>().add(UserGetEvent());
            }

            if (state is UserDeleteError) {
              final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Gagal menghapus user',
                  message: state.message,
                  contentType: ContentType.failure,
                ),
              );

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);
            }

            if (state is UserAddError) {
              final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Gagal menambahkan user',
                  message: state.message,
                  contentType: ContentType.failure,
                ),
              );

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);
            }
          },
        )));
  }

  void _showDeletePopUp(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Hapus Data"),
          content: Text("Apa anda yakin akan menghapus pengguna ini?"),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue),
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // to go back to screen after submitting
                }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, foregroundColor: Colors.white),
                child: Text("Hapus"),
                onPressed: () {
                  context
                      .read<UserBloc>()
                      .add(UserDeleteEvent(request: UserDeleteRequest(id: id)));
                }),
          ],
        );
      },
    );
  }

  Widget showForm(BuildContext context, List<UserResponse> users) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  flex: 3,
                  child: inputText('cari pengguna', nameController),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 15, bottom: 15),
              child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Total Pengguna',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  )),
            ),
            Expanded(
                child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 3),
                  child: ClipRRect(
                    child: Card(
                      elevation: 4,
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(users[index].email ?? ""),
                            ElevatedButton(
                              onPressed: () {
                                _showDeletePopUp(context, users[index].id);
                              },
                              child: Text(
                                "hapus",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
