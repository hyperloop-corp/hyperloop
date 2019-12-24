import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyperloop/app/bloc/authentication_bloc/bloc.dart';
import 'package:hyperloop/app/utils/constants.dart';
import 'package:hyperloop/app/widgets/auth_widgets.dart';

class LoginEmailCard extends StatefulWidget {
  final cardBackgroundColor = 0xFF6874C2;

  final Function onBackPress;

  const LoginEmailCard({Key key, @required this.onBackPress}) : super(key: key);

  @override
  _LoginEmailCardState createState() => _LoginEmailCardState();
}

class _LoginEmailCardState extends State<LoginEmailCard> {
  double _height, _width, _fixedPadding;

  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery
        .of(context)
        .size
        .height;
    _width = MediaQuery
        .of(context)
        .size
        .width;
    _fixedPadding = _height * 0.025;

    return Card(
      color: Color(widget.cardBackgroundColor),
      elevation: 2.0,
      child: Container(
        height: _height * 9 / 10,
        width: _width * 9 / 10,
        child: _getCardContent(context),
      ),
    );
  }

  Widget _getCardContent(BuildContext context) {
    return Container(
      height: _height * 9 / 10,
      width: _width * 9 / 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(_fixedPadding * 3.5,
                _fixedPadding * 3.5, _fixedPadding * 3.5, _fixedPadding * 0.5),
            child: AuthWidgets.getLogo(
                logoPath: Resources.hyperloopLogo, height: _height * 0.2),
          ),
          Padding(
            padding: EdgeInsets.all(_fixedPadding),
            child: _showLoginForm(),
          ),
          Padding(
            padding: EdgeInsets.all(_fixedPadding),
            child: _showCircularProgress(),
          ),
        ],
      ),
    );
  }

  Widget _showLoginForm() {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          _showEmailInput(),
          _showPasswordInput(),
          _showPrimaryButton(),
          _showSecondaryButton(),
          _showErrorMessage(),
        ],
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          style: TextStyle(
            color: Colors.white,
          ),
          decoration: new InputDecoration(
            hintText: 'Email',
            hintStyle: TextStyle(
              color: Colors.grey
            ),
            icon: new Icon(
            Icons.mail,
            color: Colors.white,
          )),
      validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
      onSaved: (value) => _email = value.trim(),
    ),);
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: new InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(
                color: Colors.grey
            ),
            icon: new Icon(
              Icons.lock,
              color: Colors.white,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text(_isLoginForm ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300, color: Colors.white)),
        onPressed: toggleFormMode);
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          BlocProvider.of<AuthenticationBloc>(context)
            ..add(InvokeSignInWithEmail(email: _email, password: _password));
//          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
//          userId = await widget.auth.signUp(_email, _password);
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null && _isLoginForm) {
//          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }
}
