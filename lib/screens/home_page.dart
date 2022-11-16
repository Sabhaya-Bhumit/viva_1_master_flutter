import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_api/youtube_api.dart';

import '../global.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool typing = false;
  static String key = "AIzaSyBRVa7iu7N03OuNEqZKHQGK1au-zbeRwZw";
  String header = "New Song";

  YoutubeAPI youtube = YoutubeAPI(key);
  List<YouTubeVideo> videoResult = [];

  Future<void> callAPI() async {
    videoResult = await youtube.search(
      "New Song",
      order: 'relevance',
      videoDuration: 'any',
    );
    videoResult = await youtube.nextPage();
    setState(() {});
  }

  time() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    Global.time = pref.getStringList('time') ?? [];
    Global.count = pref.getInt('count') ?? 0;
    Global.count--;
    Global.searchList = pref.getStringList('searchList') ?? [];
  }

  @override
  void initState() {
    super.initState();
    callAPI();
    time();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blue,
          title: Row(
            children: const [
              Icon(
                Icons.play_circle_filled,
                color: Colors.red,
                size: 30,
              ),
              SizedBox(width: 5),
              Text(
                "YouTube",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
          actions: [
            const Icon(Icons.cast, color: Colors.black, size: 23),
            const SizedBox(width: 12),
            const Icon(Icons.notifications_none_outlined,
                color: Colors.black, size: 27),
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed("search_page");
              },
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
            CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey.withOpacity(0.5),
                backgroundImage: const AssetImage("asset/images/IMG_6526.JPG")),
            const SizedBox(width: 10),
          ],
        ),
        drawer: Drawer(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              color: Colors.lightBlue,
              child: Text("YouTub", style: TextStyle(fontSize: 20)),
              alignment: Alignment.center,
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                setState(() {
                  Navigator.of(context).pushNamed('history');
                });
              },
              child: Container(
                height: 100,
                color: Colors.lightBlue,
                child: Text("HisTory", style: TextStyle(fontSize: 20)),
                alignment: Alignment.center,
              ),
            )
          ],
        )),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: videoResult.map<Widget>(listItem).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listItem(YouTubeVideo video) {
    return GestureDetector(
      onTap: () {
        Global.data = video;
        Global.id = video.id.toString();
        Navigator.of(context).pushNamed("YouTub_page");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              image: DecorationImage(
                image: NetworkImage("${video.thumbnail.high.url}"),
                fit: BoxFit.cover,
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.25,
          ),
          Padding(
            padding:
                const EdgeInsets.only(right: 15, left: 15, top: 5, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                Text(
                  video.channelTitle,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
