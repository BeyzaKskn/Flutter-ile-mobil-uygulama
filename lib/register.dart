import 'package:flutter/material.dart';
import 'package:flutterr_app/anasayfa.dart';
import 'package:flutterr_app/loginpage.dart';
import 'package:flutterr_app/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();
  // ignore: unused_field
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>(); // Add form key for validation
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 206, 80, 245),
                  Color.fromARGB(255, 98, 231, 255)
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Kayıt Ol',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins"),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          decoration: const InputDecoration(
                            labelText: 'Kullanıcı Adı',
                            labelStyle: TextStyle(
                                color: Colors.white, fontFamily: "Poppins"),
                            prefixIcon: Icon(Icons.person, color: Colors.white),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Kullanıcı adı boş bırakılamaz';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'E-Mail',
                            labelStyle: TextStyle(
                                color: Colors.white, fontFamily: "Poppins"),
                            prefixIcon: Icon(Icons.mail, color: Colors.white),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'E-Mail boş bırakılamaz';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Geçerli bir E-Mail giriniz';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Parola',
                            labelStyle: TextStyle(
                                color: Colors.white, fontFamily: "Poppins"),
                            prefixIcon: Icon(Icons.lock, color: Colors.white),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Parola boş bırakılamaz';
                            }
                            if (value.length < 6) {
                              return 'Parola en az 6 karakter olmalıdır';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordAgainController,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Parola Tekrar',
                            labelStyle: TextStyle(
                                color: Colors.white, fontFamily: "Poppins"),
                            prefixIcon: Icon(Icons.lock, color: Colors.white),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Parola tekrar boş bırakılamaz';
                            }
                            if (value != _passwordController.text) {
                              return 'Parolalar eşleşmiyor';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              _registerUser();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(30))),
                            child: const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Center(
                                  child: Text(
                                "Kaydet",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              )),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (isLoading) const CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: size.height * .06,
            left: size.width * .02,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: w * 0.67,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Anasayfa()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 206, 80, 245),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.0),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Kayıt Olmadan Devam Et",
                style: TextStyle(
                    color: Colors.white, fontFamily: "Poppins", fontSize: 12),
              ),
              SizedBox(
                width: 6,
              ),
              Icon(Icons.arrow_forward, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPag(
                  onPressed: () {},
                )),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Şifre en az 6 karakter uzunluğunda olmalıdır."),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Bu e posta ile açılmış bir hesap bulunmaktadır."),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Kayıt işlemi başarısız: $e"),
        ),
      );
    }
  }
}
