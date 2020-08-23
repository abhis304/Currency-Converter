import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map worldData;
  Map countrys;
  List<String> countryList;
  String fromCountry;
  String toCountry;
  TextEditingController textFieldController = TextEditingController();
  TextEditingController pccController = TextEditingController();

  var ans;
  bool _numValidate = false;
  bool _pccValidate = false;

  fetchWorldWideData() async {
    http.Response response =
        await http.get('https://api.exchangeratesapi.io/latest');
    setState(() {
      worldData = json.decode(response.body);
      countrys = worldData['rates'];
      countryList = countrys.keys.toList();
    });
    print(worldData['rates']);
    print('hii');
    print(countrys.keys.toList());
    fromCountry = countryList[0];
    toCountry = countryList[1];
  }

  @override
  void initState() {
    super.initState();
    fetchWorldWideData();
  }

  @override
  Widget build(BuildContext context) {
    // var pcc;
    var height = MediaQuery.of(context).size.height;
    bool resultLoad = false;

    Future<String> _doConversion() async {
      setState(() {
        resultLoad = true;
        textFieldController.text.isEmpty
            ? _numValidate = true
            : _numValidate = false;

        pccController.text.isEmpty ? _pccValidate = true : _pccValidate = false;
      });

      print('in conversion method');
      print(fromCountry);
      print(toCountry);
      String url =
          'https://api.exchangeratesapi.io/latest?base=$fromCountry&symbols=$toCountry';

      http.Response response =
          await http.get(url, headers: {"Accept": "application/json"});
      var responseBody = json.decode(response.body);
      setState(() {
        var anss1 = ((responseBody['rates'][toCountry]) *
            double.parse(textFieldController.text));

        anss1 = anss1.toStringAsFixed(3);
        print(anss1);

        double anss2 = double.parse(pccController.text) / 100;
        print(anss2);

        double anss3 = double.parse(anss1) * anss2;
        print(anss3);
        ans = double.parse(anss1) - anss3;

        ans = ans.toStringAsFixed(2);

        

        setState(() {
          resultLoad = false;
        });

        print(ans);
      });
      return 'success';
    }

    Container topPart() {
      return Container(
        padding: EdgeInsets.all(25.0),
        color: Colors.brown[300],
        height: height * 0.2,
        child: Row(
          children: [
            Text(
              'Percentage Conversion Charge',
              style: TextStyle(color: Colors.white70, fontSize: 17.0),
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Container(
                width: 50.0,
                height: 50.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: pccController,
                  cursorColor: Colors.white,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    errorText: _pccValidate ? 'Plz Enter' : null,
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.white60, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                  ),
                  // onChanged: (value) {
                  //   pcc = value;
                  // },
                ),
              ),
            ),
          ],
        ),
      );
    }

    Container middlePart() {
      return Container(
        color: Colors.white,
        height: height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DropdownButton<String>(
              value: fromCountry,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Color.fromRGBO(17, 28, 127, 0.9),
              ),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Color.fromRGBO(17, 28, 127, 0.9)),
              underline: Container(height: 1, color: Colors.white),
              dropdownColor: Colors.white70,
              onChanged: (String newValue) {
                setState(() {
                  fromCountry = newValue;
                  print(fromCountry);
                });
              },
              items: countryList.map((String country) {
                return new DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
            ),
            Container(
              width: 120.0,
              height: 53.0,
              child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: textFieldController,
                  decoration: InputDecoration(
                    errorText: _numValidate ? 'Value Can\'t Be Empty' : null,
                    hintText: 'Enter',
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      borderSide: BorderSide(color: Colors.black38, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.black38),
                    ),
                  )),
            ),
            // Text(
            //   '1',
            //   style: TextStyle(
            //       fontSize: 65.0, color: Color.fromRGBO(17, 28, 127, 0.9)),
            // ),
          ],
        ),
      );
    }

    Container endPart() {
      return Container(
        color: Color.fromRGBO(17, 28, 127, 0.9),
        height: height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DropdownButton<String>(
              value: toCountry,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
              ),
              iconSize: 24,
              elevation: 16,
              dropdownColor: Color.fromRGBO(17, 28, 127, 0.9),
              style: TextStyle(color: Colors.white),
              underline: Container(
                  height: 0.0, color: Color.fromRGBO(17, 28, 127, 0.9)),
              onChanged: (String newValue) {
                setState(() {
                  toCountry = newValue;
                  print(toCountry);
                });
              },
              items: countryList.map((String country) {
                return new DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                );
              }).toList(),
            ),
            ans == null
                ? Text('')
                : resultLoad == true
                    ? CircularProgressIndicator()
                    : Text(
                        ans.toString(),
                        style: TextStyle(fontSize: 55.0, color: Colors.white),
                      ),
          ],
        ),
      );
    }

    return Scaffold(
      body: countryList == null
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                topPart(),
                middlePart(),
                endPart(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Get Conversion',
        onPressed: _doConversion,
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
    );
  }
}
