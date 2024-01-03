import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipOval(
                  child: Image.asset("assets/images/ss.jpg",

                    width: 10,
                    height: 300,
                    fit: BoxFit.fill,
                  )),
              const SizedBox(height: 16.0),
              const Center(child: Text('Harshal Jathwa',style: TextStyle(fontSize: 20,),)),
              const SizedBox(height: 10.0),
              const Center(child: Text('FLUTTER DEVELOPER',style: TextStyle(fontSize: 20,),)),
              const SizedBox(height: 16.0),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  fillColor: Colors.white,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(top: 0),
                    // add padding to adjust icon
                    child: Icon(Icons.phone),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  fillColor: Colors.white,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(top: 0),
                    // add padding to adjust icon
                    child: Icon(Icons.email),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 62.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
                onPressed: () {},
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}