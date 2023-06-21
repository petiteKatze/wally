import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileManager {
  final dio = Dio();
  Future<String?> get _directoryPath async {
    Directory? directory = await getExternalStorageDirectory();
    return directory?.path;
  }

  // write files after downloading
  Future writeFile(String fileName, String apiPath) async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.denied) {
      exit(1);
    }
    final response =
        await dio.get("https://drab-erin-moose-ring.cyclic.app/$apiPath");
    print(response.data);

    final path = await _directoryPath;

    var newFile =
        await File('$path/Walldata/$fileName.json').create(recursive: true);
    await newFile.delete();
    await newFile.writeAsBytes(utf8.encode(jsonEncode(response.data)));
  }

  Future addToLike(dynamic data) async {
    final toLike = await isPresent(data["id"]);

    if (toLike == false) {
      var temp = [];
      var status = await Permission.storage.request();
      if (status == PermissionStatus.denied) {
        exit(1);
      }
      final path = await _directoryPath;
      var filePres = await readFile("likedItems");

      if (filePres == null ||
          filePres.toString() == "Instance of 'Future<dynamic>'") {
        var newFile = await File('$path/Walldata/likedItems.json')
            .create(recursive: true);
        temp.add(data);
        await newFile.delete();
        await newFile.writeAsBytes(utf8.encode(jsonEncode(temp)));
      } else {
        filePres.add(data);
        final newFile = await File('$path/Walldata/likedItems.json');
        newFile.writeAsBytesSync(utf8.encode(jsonEncode(filePres)));
      }
    } else {
      var status = await Permission.storage.request();
      if (status == PermissionStatus.denied) {
        exit(1);
      }
      final path = await _directoryPath;
      var filePres = await readFile("likedItems");
      filePres.removeWhere((ele) => ele["id"] == data["id"]);
      final newFile = await File('$path/Walldata/likedItems.json');
      newFile.writeAsBytesSync(utf8.encode(jsonEncode(filePres)));
      print("deleted");
    }
  }

  Future<List<dynamic>> readLikes() async {
    final likes = await readFile("likedItems");
    if (likes == null) {
      return [];
    } else {
      return likes;
    }
  }

  Future<bool> isPresent(int id) async {
    List<dynamic> likesList = await readLikes();
    for (var i = 0; i < likesList.length; i++) {
      if (id == likesList[i]["id"]) {
        return true;
      }
    }
    return false;
  }

  // reads file
  readFile(String fileName) async {
    var status = await Permission.storage.request();
    if (status == PermissionStatus.denied) {
      exit(1);
    }
    final path = await _directoryPath;
    var presentFile = await File('$path/Walldata/$fileName.json');
    if (await presentFile.exists()) {
      final data = jsonDecode(utf8.decode(presentFile.readAsBytesSync()));
      return data;
    } else {
      return null;
    }
  }

  Future appInitCheck() async {
    var status = await Permission.storage.request();
    if (status == PermissionStatus.denied) {
      Permission.storage.request();
    }
    final shouldDownload = await readFile('initState');
    print(shouldDownload);
    if (shouldDownload.toString() == "Instance of 'Future<dynamic>'" ||
        shouldDownload == null) {
      //as current state file not present then we need to download all files.
      await writeFile("initState", "/prState");
      await writeFile("catagoryData", "/ctData");
      await writeFile("allWalls", "/all");
    } else {
      //also to download if newer version available.

      final res =
          await dio.get("https://drab-erin-moose-ring.cyclic.app/version");

      if (int.parse(res.toString()) > shouldDownload["version"]) {
        await writeFile("initState", "/prState");
        await writeFile("catagoryData", "/ctData");
        await writeFile("allWalls", "/all");
      }
    }
  }

  //for featured walls
  Future<List<dynamic>> getFaetured() async {
    final featuredWalls = await readFile("allWalls");
    return featuredWalls;
  }

  //for fetching catagories
  Future<List<dynamic>> getCatagories() async {
    var cat = await readFile("catagoryData");
    if (cat == null || cat.toString() == "Instance of 'Future<dynamic>'") {
      await writeFile("catagoryData", "/ctData");
      cat = await readFile("catagoryData");
    } else {
      return cat;
    }
    return cat;
  }
}
