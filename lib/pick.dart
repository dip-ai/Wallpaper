import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:insta_image_viewer/insta_image_viewer.dart';

class WallpaperApp extends StatefulWidget {
  const WallpaperApp({super.key});

  @override
  State<WallpaperApp> createState() => _WallpaperAppState();
}

class _WallpaperAppState extends State<WallpaperApp> {
  Color myHexColor = const Color(0xFF92D6DB);
  Color myNextColor = const Color(0xFF9E9E9E);
  List data = [];
  TextEditingController searchImage = TextEditingController();
  final List<String> categories = [
    'Architecture',
    'Movie',
    'Travel',
    'Animal',
    'Food',
    'Sport',
    'Nature'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhoto(categories[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        const SizedBox(
          height: 20,
        ),
        topRow(),
        searchBar(),
        const Center(
            child: Text(
          'Categories can have a look at',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        )),
        const SizedBox(height: 20),
        horizontalBuilder(),
        const SizedBox(
          height: 20,
        ),
        verticalBuilder(),
      ]),
    );
  }

  void getPhoto(search) async {
    setState(() {
      data = [];
    });

    try {
      final url = Uri.parse(
          'https://api.unsplash.com/search/photos/?client_id=5D4mEky7QpdPm5KwsCRMaX2k05A4iHzVMru7V-R6fhc&query=$search&per_page=30');
      var responce = await http.get(url);
      var result = jsonDecode(responce.body);
      data = result['results'];
      debugPrint('$data');
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget topRow() {
    return Row(
      children: [
        const SizedBox(width: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset("assets/images/Slack.jpg",
              fit: BoxFit.cover, height: 40, width: 40),
        ),
        const SizedBox(width: 80),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Slack ",
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: myHexColor,
                    fontFamily: 'cv'),
              ),
              TextSpan(
                text: "Flyer",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: myNextColor,
                    fontFamily: 'cv'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget searchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: searchImage,
                decoration: const InputDecoration(
                  hintText: 'Search images (nature, animals)...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              if (searchImage.text.isNotEmpty) {
                getPhoto(searchImage.text);
              }
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }

  Widget horizontalBuilder() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              getPhoto(categories[index]);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage("assets/images/${categories[index]}.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  categories[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget verticalBuilder() {
    return data.isNotEmpty
        ? MasonryGridView.count(
            crossAxisCount: 2,
            itemCount: data.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              double ht = index % 2 == 0 ? 200 : 100;
              return Padding(
                padding: const EdgeInsets.all(10),
                child: InstaImageViewer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      data[index]['urls']['regular'],
                      height: ht,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            })
        : const SizedBox(
            height: 500,
            child: Center(
              child: SpinKitCircle(color: Colors.grey),
            ));
  }
}
