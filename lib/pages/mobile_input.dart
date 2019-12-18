import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hyperloop/data_models/countries.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hyperloop/utils/widgets.dart';

class PhoneAuthGetPhone extends StatefulWidget {
  final Color cardBackgroundColor = Color(0xFF6874C2);
  final String logo = 'images/ctu.jpg';
  final String appName = "Hyperloop";

  @override
  _PhoneAuthGetPhoneState createState() => _PhoneAuthGetPhoneState();
}

class _PhoneAuthGetPhoneState extends State<PhoneAuthGetPhone> {
  double _height, _width, _fixedPadding;

  List<Country> countries = [];
  StreamController<List<Country>> _countriesStreamController;
  Stream<List<Country>> _countriesStream;
  Sink<List<Country>> _countriesSink;

  TextEditingController _searchCountryController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  int _selectedCountryIndex = 100;
  bool _isCountriesDataFormed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchCountryController.dispose();
    super.dispose();
  }

  Future<List<Country>> loadCountriesJson() async {
    countries.clear();

    var value = await DefaultAssetBundle.of(context)
        .loadString("data/country_phone_codes.json");
    var countriesJson = json.decode(value);
    for (var country in countriesJson) {
      countries.add(Country.fromJson(country));
    }
    return countries;
  }

  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('In verify phone $value');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: countries[_selectedCountryIndex].dialCode +
              _phoneNumberController.text,
          // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent: smsOTPSent,
          // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException e) {
            print('${e.message}');
          });
    } catch (error) {
      handleError(error);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: new AlertDialog(
                title: Text('Enter SMS Code'),
                content: Container(
                  height: 85,
                  child: Column(children: [
                    TextField(
                      onChanged: (value) {
                        this.smsOTP = value;
                      },
                    ),
                    (errorMessage != ''
                        ? Text(
                            errorMessage,
                            style: TextStyle(color: Colors.red),
                          )
                        : Container())
                  ]),
                ),
                contentPadding: EdgeInsets.all(10),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Done'),
                    onPressed: () {
                      _auth.currentUser().then((user) {
                        if (user != null) {
                          print('User was already there');
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacementNamed('/home');
                        } else {
                          signIn();
                        }
                      });
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      _auth.signInWithCredential(credential).then((AuthResult result) async {
        final FirebaseUser user = result.user;
        final FirebaseUser currentUser = await _auth.currentUser();
        assert(user.uid == currentUser.uid);
        print('Manual code entry');
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed('/home');
      });
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.025;

    WidgetsBinding.instance.addPostFrameCallback((Duration d) {
      if (countries.length < 240) {
        loadCountriesJson().whenComplete(() {
          setState(() => _isCountriesDataFormed = true);
        });
      }
    });
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: _getBody(),
          ),
        ),
      ),
    );
  }

  Widget _getBody() => Card(
        color: widget.cardBackgroundColor,
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Container(
          height: _height * 9 / 10,
          width: _width * 9 / 10,
          child: _isCountriesDataFormed
              ? _getColumnBody()
              : Center(child: CircularProgressIndicator()),
        ),
      );

  Widget _getColumnBody() => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //  Logo: scaling to occupy 2 parts of 10 in the whole height of device
          Padding(
            padding: EdgeInsets.all(_fixedPadding),
            child: PhoneAuthWidgets.getLogo(
                logoPath: widget.logo, height: _height * 0.2),
          ),

          // AppName:
          Text(widget.appName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700)),

          Padding(
            padding: EdgeInsets.only(top: _fixedPadding, left: _fixedPadding),
            child: PhoneAuthWidgets.subTitle('Select your country'),
          ),

          Padding(
            padding: EdgeInsets.only(left: _fixedPadding, right: _fixedPadding),
            child: PhoneAuthWidgets.selectCountryDropDown(
                countries[_selectedCountryIndex], showCountries),
          ),

          Padding(
            padding: EdgeInsets.only(top: 10.0, left: _fixedPadding),
            child: PhoneAuthWidgets.subTitle('Enter your phone'),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: _fixedPadding,
                right: _fixedPadding,
                bottom: _fixedPadding),
            child: PhoneAuthWidgets.phoneNumberField(_phoneNumberController,
                countries[_selectedCountryIndex].dialCode),
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(width: _fixedPadding),
              Icon(Icons.info, color: Colors.white, size: 20.0),
              SizedBox(width: 10.0),
              Expanded(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: 'We will send ',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w400)),
                  TextSpan(
                      text: 'One Time Password',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700)),
                  TextSpan(
                      text: ' to this mobile number',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w400)),
                ])),
              ),
              SizedBox(width: _fixedPadding),
            ],
          ),

          SizedBox(height: _fixedPadding * 1.5),
          RaisedButton(
            elevation: 15.0,
            onPressed: () {
              verifyPhone();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'SEND OTP',
                style: TextStyle(
                    color: widget.cardBackgroundColor, fontSize: 18.0),
              ),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
          ),
        ],
      );

  showCountries() {
    _countriesStreamController = StreamController();
    _countriesStream = _countriesStreamController.stream;
    _countriesSink = _countriesStreamController.sink;
    _countriesSink.add(countries);

    showDialog(
        context: context,
        builder: (BuildContext context) => searchAndPickYourCountryHere(),
        barrierDismissible: false);
    _searchCountryController.addListener(searchCountries);
  }

  searchCountries() {
    String query = _searchCountryController.text;
    if (query.length == 0 || query.length == 1) {
      _countriesSink.add(countries);
//      print('added all countries again');
    } else if (query.length >= 2 && query.length <= 5) {
      List<Country> searchResults = [];
      searchResults.clear();
      countries.forEach((Country c) {
        if (c.toString().toLowerCase().contains(query.toLowerCase()))
          searchResults.add(c);
      });
      _countriesSink.add(searchResults);
//      print('added few countries based on search ${searchResults.length}');
    } else {
      //No results
      List<Country> searchResults = [];
      _countriesSink.add(searchResults);
//      print('no countries added');
    }
  }

  Widget searchAndPickYourCountryHere() => WillPopScope(
        onWillPop: () => Future.value(false),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Dialog(
            key: Key('SearchCountryDialog'),
            elevation: 8.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            child: Container(
              margin: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //  TextFormField for searching country
                  PhoneAuthWidgets.searchCountry(_searchCountryController),

                  //  Returns a list of Countries that will change according to the search query
                  SizedBox(
                    height: 300.0,
                    child: StreamBuilder<List<Country>>(
                        //key: Key('Countries-StreamBuilder'),
                        stream: _countriesStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            // print(snapshot.data.length);
                            return snapshot.data.length == 0
                                ? Center(
                                    child: Text('Your search found no results',
                                        style: TextStyle(fontSize: 16.0)),
                                  )
                                : ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int i) =>
                                            PhoneAuthWidgets.selectableWidget(
                                                snapshot.data[i],
                                                (Country c) =>
                                                    selectThisCountry(c)),
                                  );
                          } else if (snapshot.hasError)
                            return Center(
                              child: Text('Seems, there is an error',
                                  style: TextStyle(fontSize: 16.0)),
                            );
                          return Center(child: CircularProgressIndicator());
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      );

  void selectThisCountry(Country country) {
    print(country);
    _searchCountryController.clear();
    Navigator.of(context).pop();
    Future.delayed(Duration(milliseconds: 10)).whenComplete(() {
      _countriesStreamController.close();
      _countriesSink.close();

      setState(() {
        _selectedCountryIndex = countries.indexOf(country);
      });
    });
  }
}
