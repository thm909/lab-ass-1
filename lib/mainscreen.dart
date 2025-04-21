import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  TextEditingController controller = TextEditingController();
  String pictureUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Random User Info"),
        backgroundColor: const Color.fromARGB(255, 126, 92, 183),
        centerTitle: true,
        elevation: 10,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade300,
              const Color.fromARGB(255, 233, 206, 240)
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 25),
                  ),
                  onPressed: loadUserData,
                  child: const Text(
                    "Load Another User",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                if (pictureUrl.isNotEmpty)
                  ClipOval(
                    child: Image.network(
                      pictureUrl,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 20),
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SizedBox(
                    width: 350,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextField(
                        maxLines: 20,
                        controller: controller,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "User Information will appear here...",
                          hintStyle:
                              TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadUserData() async {
    var response = await http.get(Uri.parse("https://randomuser.me/api/"));
    print("Status Code: ${response.statusCode}");
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var user = data['results'][0];

      String name =
          "${user['name']['title']} ${user['name']['first']} ${user['name']['last']}";
      String gender = user['gender'];
      String email = user['email'];
      String phone = user['phone'];
      String cell = user['cell'];
      String dob = user['dob']['date'];
      String age = user['dob']['age'].toString();
      String nationality = user['nat'];
      String country = user['location']['country'];
      String state = user['location']['state'];
      String city = user['location']['city'];
      String postcode = user['location']['postcode'].toString();
      String street =
          "${user['location']['street']['number']} ${user['location']['street']['name']}";
      String username = user['login']['username'];
      String password = user['login']['password'];
      String timezone = user['location']['timezone']['description'];

      pictureUrl = user['picture']['large'];

      print("Name: $name");
      print("Gender: $gender");
      print("Email: $email");
      print("Phone: $phone");
      print("Cell: $cell");
      print("DOB: $dob");
      print("Age: $age");
      print("Nationality: $nationality");
      print("Country: $country");
      print("State: $state");
      print("City: $city");
      print("Postcode: $postcode");
      print("Street: $street");
      print("Username: $username");
      print("Password: $password");
      print("Timezone: $timezone");

      controller.text = "Name: $name\n\n"
          "Gender: $gender\n\n"
          "Email: $email\n\n"
          "Phone: $phone\n"
          "Cell: $cell\n\n"
          "DOB: $dob (Age: $age)\n\n"
          "Nationality: $nationality\n\n"
          "Location: $city, $state, $country\n"
          "Street: $street\nPostcode: $postcode\n\n"
          "Username: $username\nPassword: $password\n\n"
          "Timezone: $timezone";

      setState(() {});
    } else {
      controller.text = "Error loading data";
      print("Error: ${response.statusCode}");
      setState(() {});
    }
  }
}
