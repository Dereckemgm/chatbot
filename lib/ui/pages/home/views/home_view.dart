import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF44336),
        actions: const [
          Icon(Icons.notification_add_outlined, color: Colors.white),
        ],
        title: const Text("Curso Basico Flutter", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.table_rows_sharp,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // const SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(20),
              height: 200,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text("Este es un container Basico"),
            ),

            ListTile(
              title: const Text("Titulo"),
              subtitle: const Text("Subtitulo"),
              leading: const Icon(Icons.access_alarm_rounded),
              onTap: () {
                print("Presionando el listTitle");
              },
              trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_forward_ios_rounded)),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 5,
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(300, 45),
                maximumSize: const Size(350, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                "Boton de prueba",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            const FlutterLogo(),

            const SizedBox(height: 20),

            // const Image(image: AssetImage("assets/840_560.jpeg")),
            Image.asset("assets/840_560.jpeg"),
            const SizedBox(height: 20),

            // const Image(
            //   image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
            // ),

            //Image.network('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.black), label: ""),
        ],
      ),
    );
  }
}
