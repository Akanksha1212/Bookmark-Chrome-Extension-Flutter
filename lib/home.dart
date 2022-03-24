import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Links {
  late String url;

  Links({required this.url});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;

    return data;
  }
}

class Home extends StatefulWidget {
  var urls = <Links>[];

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TFcontroller = TextEditingController();
  void add_url() {
    if (TFcontroller.text.isEmpty) return;

    setState(() {
      widget.urls.add(
        Links(url: TFcontroller.text),
      );

      TFcontroller.clear();
      save();
    });
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();

    var data = prefs.getString('data');

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Links> result = decoded.map((x) => Links.fromJson(x)).toList();

      setState(() {
        widget.urls = result;
      });
    }
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();

    await prefs.setString('data', jsonEncode(widget.urls));
  }

  _HomeState() {
    load();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff00A8F4),
      body: Container(
          child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            Image.asset("assets/dog.png"),
            ListView.builder(
                shrinkWrap: true,
                itemCount: widget.urls.length,
                itemBuilder: (context, index) {
                  final item = widget.urls[index];
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      child: Center(
                        child: Text(
                          item.url,
                          style: GoogleFonts.josefinSans(
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      onLongPress: () {
                        Clipboard.setData(ClipboardData(text: item.url));
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Copied to Clipboard")));
                      },
                    ),
                  );
                }),
            SizedBox(
              height: 30,
            ),
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: TFcontroller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 240, 240, 240),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black, //this has no effect
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: "Add website url here...",
                  ),
                )),
            Container(
              height: 50,
              width: 150,
              child: ElevatedButton(
                // FBA51E

                onPressed: add_url,
                child: Text(
                  "Add",
                  style: GoogleFonts.josefinSans(
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xffFBA51E)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      // side: BorderSide(color: Color(0xffFBA51E)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      )),
    );
  }
}
