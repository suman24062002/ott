import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Qwerty extends StatefulWidget {
  const Qwerty({Key? key}) : super(key: key);

  @override
  _QwertyState createState() => _QwertyState();
}

class _QwertyState extends State<Qwerty> {
  List<String> names = ['Bhuvanesh'];
  bool isDarkMode = false;
  String? imagePath;

  Future<void> changeTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = preferences.getBool('dark') ?? false;
    });
  }

  void toggleTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = !isDarkMode;
      preferences.setBool('dark', isDarkMode);
    });
  }

  Future<void> getImage() async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imagePath = pickedImage.path;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    changeTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.headphones_outlined),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Text(
                'Help & Support',
                style: TextStyle(),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 70.0),
                child: Center(
                  child: Stack(
                    children: [
                      if (imagePath != null) ...[
                        Image.network(imagePath!),
                      ] else ...[
                        CircleAvatar(
                          backgroundImage: AssetImage('img/pic.png'),
                          radius: 55,
                        ),
                      ],
                      Positioned(
                        child: IconButton(
                          onPressed: getImage,
                          icon: Icon(
                            Icons.add_a_photo_rounded,
                          ),
                        ),
                        bottom: -10,
                        left: 75,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 45.0, top: 10),
                    child: Text(
                      '${names[0]}',
                      style: TextStyle(fontSize: 23),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _editName(context, 0);
                    },
                    icon: Icon(Icons.edit),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 165.0),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Save'),
                ),
              ),
              // Rest of your widgets...
            ],
          ),
        ),
      ),
    );
  }

  void _editName(BuildContext context, int index) {
    String newName = names[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Name'),
          content: TextField(
            decoration: InputDecoration(hintText: 'Enter new name'),
            onChanged: (value) {
              newName = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  names[index] = newName;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(Qwerty());
}