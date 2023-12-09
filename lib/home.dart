import 'dart:convert';
import 'package:boredapp/model/activity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/user.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<User> futureuser;
  Future<User> fetchUser() async {
    final response = await http.get(Uri.parse('http://localhost:8081/users'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body.toString());
      return User.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.

      throw Exception('Failed to load User');
    }
  }

  @override
  void initState() {
    super.initState();
    futureuser = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(children: [
        Container(
          width: size.width,
          height: size.height * 0.8,
          color: Colors.grey,
          child: Center(
            child: FutureBuilder<User>(
              future: futureuser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.email.toString());
                } else if (snapshot.hasError) {
                  print(snapshot);

                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
        SizedBox(
          width: size.width,
          height: size.height * 0.2,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.amber)),
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.star_border_outlined,
                        color: Colors.amber,
                      )),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      futureuser = fetchUser();
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/bored.png"))),
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red)),
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.favorite_border_outlined,
                        color: Colors.red,
                      )),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
