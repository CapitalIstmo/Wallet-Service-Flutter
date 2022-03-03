import 'package:flutter/material.dart';

class DragableScrollSheyCustom extends StatelessWidget {
  const DragableScrollSheyCustom({
    Key? key,
    required this.fullname,
    required this.username,
  }) : super(key: key);

  final String? fullname;
  final String? username;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.5,
      builder:
          (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
              color: Color(0xffF3AB0D),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        )),
                    height: 10,
                    width: 100,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.grey,
                  ),
                ),
                Text(
                  "$fullname",
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "$username",
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}