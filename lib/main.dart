import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(new MaterialApp(home: new HomePage()));
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  ScrollController _scrollController = ScrollController();

  List? data;

  Future<String> getData() async {
    var response = await http.get(
        Uri.parse(
            "https://fireworks.galileosoft.com/api/product/getfeaturedproduct/1"),
        headers: {"Accept": "application/json"});

    this.setState(() {
      data = json.decode(response.body);
    });

    print(data![1]["name"]);

    return "Success!";
  }

  @override
  void initState() {
    super.initState();
    this.getData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      double minScrollExtent1 = _scrollController.position.minScrollExtent;
      double maxScrollExtent1 = _scrollController.position.maxScrollExtent;

      animatetoMaxMin(maxScrollExtent1,minScrollExtent1,maxScrollExtent1,25,_scrollController);
    }
    );



  }

  @override
  Widget build(BuildContext context) {
    String Base_Url = "https://fireworks.galileosoft.com";
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar:
          AppBar(title: new Text("Listviews"), backgroundColor: Colors.blue),
      body: SafeArea(
        child: Container(
          height: height * 0.35,
          width: width,
          child: ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: data == null ? 0 : data!.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: height * 0.15,
                width: width * 0.5,
                margin: EdgeInsets.all(width * 0.02),
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          child: Image.network(
                              height: height * 0.20,
                              Base_Url + data![index]["mainimg"]),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, width * 0.05, 0, 0),
                          child: Text(
                            data![index]["name"],
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, width * 0.05, 0, 0),
                          child: Text(
                            "\$ " + data![index]["mainprice"].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: width * 0.04),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void animatetoMaxMin(double max,double min, double direction,int seconds, ScrollController scrollController) {
    scrollController.animateTo(direction, duration: Duration(seconds: seconds), curve: Curves.linear);


  }
}
