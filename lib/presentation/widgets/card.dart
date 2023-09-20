import 'package:flutter/material.dart';
import 'package:smart_trash_mobile/utils/constants/colors.dart';

Widget card(BuildContext context, IconData icon, Color iconColor,
    String cardContent, footerText, number) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Card(
      elevation: 4, // Add shadow to the card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main content of the card
          Container(
              height: MediaQuery.of(context).size.height * 0.2,
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cardContent,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Icon(
                    icon,
                    size: 50,
                    color: iconColor,
                  ),
                ],
              )),
          // Divider line to separate content from footer
          Divider(
            height: 0,
            thickness: 2,
          ),
          // Footer section
          Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    number,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(footerText,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
