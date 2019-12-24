import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyperloop/app/bloc/authentication_bloc/bloc.dart';
import 'package:hyperloop/app/bloc/country_bloc/bloc.dart';
import 'package:hyperloop/app/utils/constants.dart';
import 'package:hyperloop/app/widgets/auth_widgets.dart';
import 'package:hyperloop/domain/entities/country.dart';
import 'package:hyperloop/injection_container.dart';

enum PhoneCardState { VerifyPhone, EnterOTP }

class LoginPhoneCard extends StatefulWidget {
  final cardBackgroundColor = 0xFF6874C2;

  final Function onBackPress;

  const LoginPhoneCard({Key key, @required this.onBackPress}) : super(key: key);

  @override
  _LoginPhoneCardState createState() => _LoginPhoneCardState();
}

class _LoginPhoneCardState extends State<LoginPhoneCard> {
  double _height, _width, _fixedPadding;

  PhoneCardState _phoneCardState;

  List<Country> countries = [];
  StreamController<List<Country>> _countriesStreamController;
  Stream<List<Country>> _countriesStream;
  Sink<List<Country>> _countriesSink;

  TextEditingController _searchCountryController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  int _selectedCountryIndex = 3;

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();
  String code = "";

  @override
  void initState() {
    _phoneCardState = PhoneCardState.VerifyPhone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.025;

    return WillPopScope(
      onWillPop: () async {
        this.onBackPress();

        return false;
      },
      child: Card(
        color: Color(widget.cardBackgroundColor),
        elevation: 2.0,
        child: Container(
          height: _height * 9 / 10,
          width: _width * 9 / 10,
          child: _getCardContent(),
        ),
      ),
    );
  }

  Widget _getCardContent() {
    if (BlocProvider.of<AuthenticationBloc>(context).state
        is PhoneAuthCodeSent) {
      setState(() {
        _phoneCardState = PhoneCardState.EnterOTP;
      });
    }

    if (_phoneCardState == PhoneCardState.VerifyPhone) {
      return _getVerifyPhoneCard();
    } else if (_phoneCardState == PhoneCardState.EnterOTP) {
      return _getSignInCard();
    }

    return Center(child: CircularProgressIndicator());
  }

  Widget _getVerifyPhoneCard() {
    return BlocProvider(
      create: (_) => sl<CountryBloc>()..add(LoadCountries()),
      child: BlocBuilder<CountryBloc, CountryState>(
        builder: (context, state) {
          print('CountryState: ' + state.toString());
          if (state is CountriesLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CountriesLoaded) {
            countries = state.countries;
            return _getVerifyPhoneBody();
          } else if (state is CountryError) {
            print('Error: ' + state.message);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _getVerifyPhoneBody() {
    return Container(
        height: _height * 9 / 10,
        width: _width * 9 / 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  _fixedPadding * 3.5,
                  _fixedPadding * 3.5,
                  _fixedPadding * 3.5,
                  _fixedPadding * 0.5),
              child: AuthWidgets.getLogo(
                  logoPath: Resources.hyperloopLogo, height: _height * 0.2),
            ),
            Padding(
              padding: EdgeInsets.only(top: _fixedPadding, left: _fixedPadding),
              child: AuthWidgets.subTitle('Select your country'),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: _fixedPadding, right: _fixedPadding),
              child: AuthWidgets.selectCountryDropDown(
                  countries[_selectedCountryIndex], showCountries),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: _fixedPadding),
              child: AuthWidgets.subTitle('Enter your phone'),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: _fixedPadding,
                  right: _fixedPadding,
                  bottom: _fixedPadding),
              child: AuthWidgets.phoneNumberField(_phoneNumberController,
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
                final phoneNumber = countries[_selectedCountryIndex].dialCode +
                    _phoneNumberController.text;
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(InvokeVerifyPhone(phoneNumber: phoneNumber));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'SEND OTP',
                  style: TextStyle(
                      color: Color(widget.cardBackgroundColor), fontSize: 18.0),
                ),
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
            ),
          ],
        ));
  }

  Widget _getSignInCard() {
    return Container(
        height: _height * 9 / 10,
        width: _width * 9 / 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(_fixedPadding),
              child: AuthWidgets.getLogo(
                  logoPath: Resources.hyperloopLogo, height: _height * 0.2),
            ),
            SizedBox(height: _fixedPadding * 1.5),
            Row(
              children: <Widget>[
                SizedBox(width: 20.0),
                Expanded(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Please enter the ',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400)),
                    TextSpan(
                        text: 'One Time Password',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700)),
                    TextSpan(
                        text: ' sent to your mobile',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400)),
                  ])),
                ),
                SizedBox(width: 20.0),
              ],
            ),
            SizedBox(height: _fixedPadding * 1.5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                getField("1", focusNode1),
                SizedBox(width: 5.0),
                getField("2", focusNode2),
                SizedBox(width: 5.0),
                getField("3", focusNode3),
                SizedBox(width: 5.0),
                getField("4", focusNode4),
                SizedBox(width: 5.0),
                getField("5", focusNode5),
                SizedBox(width: 5.0),
                getField("6", focusNode6),
                SizedBox(width: 5.0),
              ],
            )
          ],
        ));
  }

  Widget getField(String key, FocusNode fn) => SizedBox(
        height: 40.0,
        width: 35.0,
        child: TextField(
          key: Key(key),
          expands: false,
          autofocus: key.contains("1") ? true : false,
          focusNode: fn,
          onChanged: (String value) {
            if (value.length == 1) {
              code += value;
              switch (code.length) {
                case 0:
                  FocusScope.of(context).requestFocus(focusNode1);
                  break;
                case 1:
                  FocusScope.of(context).requestFocus(focusNode2);
                  break;
                case 2:
                  FocusScope.of(context).requestFocus(focusNode3);
                  break;
                case 3:
                  FocusScope.of(context).requestFocus(focusNode4);
                  break;
                case 4:
                  FocusScope.of(context).requestFocus(focusNode5);
                  break;
                case 5:
                  FocusScope.of(context).requestFocus(focusNode6);
                  break;
                case 6:
                  BlocProvider.of<AuthenticationBloc>(context)
                      .add(InvokeSignInWithPhone(smsCode: code));
                  break;
                default:
                  FocusScope.of(context).unfocus();
                  break;
              }
            }
          },
          maxLengthEnforced: false,
          textAlign: TextAlign.center,
          cursorColor: Colors.white,
          keyboardType: TextInputType.number,
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white),
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                  bottom: 10.0, top: 10.0, left: 4.0, right: 4.0),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide:
                      BorderSide(color: Colors.blueAccent, width: 2.25)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Colors.white))),
        ),
      );

  Widget searchAndPickYourCountryHere() => WillPopScope(
        onWillPop: () => Future.value(true),
        child: Dialog(
          elevation: 8.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AuthWidgets.searchCountry(_searchCountryController),
                SizedBox(
                  height: 300.0,
                  child: StreamBuilder<List<Country>>(
                      stream: _countriesStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return snapshot.data.length == 0
                              ? Center(
                                  child: Text('Your search found no results',
                                      style: TextStyle(fontSize: 16.0)),
                                )
                              : ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int i) =>
                                      AuthWidgets.selectableWidget(
                                          snapshot.data[i],
                                          (Country c) => selectThisCountry(c)),
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
      );

  showCountries() {
    _countriesStreamController = StreamController();
    _countriesStream = _countriesStreamController.stream;
    _countriesSink = _countriesStreamController.sink;
    _countriesSink.add(countries);

    showDialog(
      context: context,
      builder: (BuildContext context) => searchAndPickYourCountryHere(),
    );
    _searchCountryController.addListener(searchCountries);
  }

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

  searchCountries() {
    String query = _searchCountryController.text;
    if (query.length == 0 || query.length == 1) {
      _countriesSink.add(countries);
    } else if (query.length >= 2 && query.length <= 5) {
      List<Country> searchResults = [];
      searchResults.clear();
      countries.forEach((Country c) {
        if (c.toString().toLowerCase().contains(query.toLowerCase()))
          searchResults.add(c);
      });
      _countriesSink.add(searchResults);
    } else {
      List<Country> searchResults = [];
      _countriesSink.add(searchResults);
    }
  }

  onBackPress() {
    if (_phoneCardState == PhoneCardState.EnterOTP) {
      this.setState(() {
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
        _phoneCardState = PhoneCardState.VerifyPhone;
      });
    } else {
      widget.onBackPress();
    }
  }

  @override
  void dispose() {
    _searchCountryController.dispose();
    super.dispose();
  }
}
