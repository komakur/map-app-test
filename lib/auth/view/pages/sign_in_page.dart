import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app_test/auth/auth.dart';
import 'package:map_app_test/auth/view/widgets/form_elevated_button.dart';
import 'package:map_app_test/map/map_screen.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signInUserWithEmailAndPassword(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(SignInRequested(
        _emailController.text,
        _passwordController.text,
      ));
    }
  }

  void _authenticateWithGoogle(context) {
    BlocProvider.of<AuthBloc>(context).add(
      GoogleSignInRequested(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapPage(),
                ),
              );
            }
            if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            if (state is Loading) {
              return const CircularProgressIndicator();
            }
            if (state is UnAuthenticated) {
              return ListView(
                shrinkWrap: true,
                children: [
                  Image.asset('assets/images/logo_image.png'),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Your email',
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Your password',
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: FormElevatedButton(
                            text: 'Sign In',
                            onPressed: () =>
                                _signInUserWithEmailAndPassword(context),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _authenticateWithGoogle(context);
                          },
                          icon: Image.network(
                            "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png",
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(text: 'Dont have an account? '),
                          TextSpan(
                            text: 'Sign up',
                            style: const TextStyle(color: Colors.blueAccent),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpPage()));
                              },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
