import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_trash_mobile/data/bloc/trash/trash_bloc.dart';
import 'package:smart_trash_mobile/data/bloc/user/user_bloc.dart';
import 'package:smart_trash_mobile/data/models/card.dart';
import 'package:smart_trash_mobile/presentation/widgets/card.dart';
import 'package:smart_trash_mobile/routes.dart';
import 'package:smart_trash_mobile/utils/services/notification_service.dart';
import 'package:smart_trash_mobile/utils/storage/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(UserGetEvent());
    context.read<TrashBloc>().add(GetReportPerDay());
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final reportPerDay =
        context.select((TrashBloc bloc) => bloc.totalReportPerDay);
    CardData userCard = CardData(Icons.person, Colors.lightBlueAccent,
        'Pengaturan Pengguna', 'Jumlah Pengguna', '0', Routes.userSetting);
    CardData garbageCard = CardData(Icons.delete_rounded, Colors.blueGrey,
        'Monitoring Sampah', 'Jumlah Tempat', '1', Routes.garbageMonitor);
    CardData reportCard = CardData(
        Icons.analytics,
        Colors.greenAccent,
        'Laporan',
        'Pengangkatan Sampah Per-Hari',
        reportPerDay?.toString() ?? '0',
        Routes.report);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Halaman Utama"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value) async {
              if (value == 'logout') {
                await SharedPreferencesService().prefs.remove("access_token");
                await SharedPreferencesService().prefs.remove("refresh_token");
                Navigator.pushReplacementNamed(context, Routes.login);
              }
            },
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          )
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserGetLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is UserGetSuccess) {
            userCard.number = state.response.length.toString();
          }

          return showHome(userCard, garbageCard, reportCard);
        },
      ),
    );
  }

  Widget showHome(CardData userCard, garbageCard, reportCard) {
    return SafeArea(
      child: Center(
        child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 20),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [
                    showCard(userCard),
                    showCard(garbageCard),
                    showCard(reportCard),
                  ],
                ))),
      ),
    );
  }

  Widget showCard(CardData cardData) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(cardData.route);
        },
        child: card(
          context,
          cardData.icon,
          cardData.iconColor,
          cardData.cardContent,
          cardData.footerText,
          cardData.number,
        ),
      ),
    );
  }
}
