import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileManager {
  final String apiLink = "https://drab-erin-moose-ring.cyclic.app";
  // final String apiLink = "https://localhost:5001";
  final dio = Dio();

  Future<String?> get _directoryPath async {
    Directory? directory = await getExternalStorageDirectory();
    return directory?.path;
  }

  // write files after downloading
  Future writeFile(String fileName, String apiPath) async {
    var status = await Permission.storage.request();

    if (status == PermissionStatus.denied) {
      Permission.storage.request();
    }
    final response =
        await dio.get("$apiLink/$apiPath").timeout(const Duration(seconds: 45));

    if (kDebugMode) {
      print(response.data);
    }

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
        final newFile = File('$path/Walldata/likedItems.json');
        newFile.writeAsBytesSync(utf8.encode(jsonEncode(filePres)));
      }
    } else {
      var status = await Permission.storage.request();
      if (status == PermissionStatus.denied) {
        Permission.storage.request();
      }
      final path = await _directoryPath;
      var filePres = await readFile("likedItems");
      filePres.removeWhere((ele) => ele["id"] == data["id"]);
      final newFile = File('$path/Walldata/likedItems.json');
      newFile.writeAsBytesSync(utf8.encode(jsonEncode(filePres)));
      if (kDebugMode) {
        print("deleted");
      }
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
      Permission.storage.request();
    }
    final path = await _directoryPath;
    var presentFile = File('$path/Walldata/$fileName.json');
    if (await presentFile.exists()) {
      final data = jsonDecode(utf8.decode(presentFile.readAsBytesSync()));
      return data;
    } else {
      return null;
    }
  }

  getCatagory(String catName) async {
    var status = await Permission.storage.request();
    if (status == PermissionStatus.denied) {
      Permission.storage.request();
    }
    //fuck it user har bar mobile data kharcha karega, nahi chhaiye savings
    final path = await _directoryPath;
    final response = await dio.get("$apiLink/catagory/$catName");
    var newFile = await File('$path/Walldata/catagory/$catName.json')
        .create(recursive: true);
    await newFile.delete();
    await newFile.writeAsBytes(utf8.encode(jsonEncode(response.data)));
    var presentFile = File('$path/Walldata/catagory/$catName.json');
    final data = jsonDecode(utf8.decode(presentFile.readAsBytesSync()));
    Fluttertoast.showToast(
        msg: "Loading walls",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
    return data;
  }

  Future appInitCheck() async {
    var status = await Permission.storage.request();
    if (status == PermissionStatus.denied) {
      Permission.storage.request();
    }
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final shouldDownload = await readFile('initState');
      if (kDebugMode) {
        print(shouldDownload);
      }
      if (shouldDownload.toString() == "Instance of 'Future<dynamic>'" ||
          shouldDownload == null) {
        //as current state file not present then we need to download all files.
        await writeFile("initState", "/prState");
        await writeFile("catagoryData", "/ctData");
        await writeFile("allWalls", "/all");
      } else {
        Fluttertoast.showToast(
            msg: "Loading walls",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);

        final res = await dio
            .get("$apiLink/version")
            .timeout(const Duration(seconds: 30));

        if (int.parse(res.toString()) > shouldDownload["version"]) {
          Fluttertoast.showToast(
              msg: "New wallpapers loading !",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              fontSize: 16.0);

          await writeFile("initState", "/prState");
          await writeFile("catagoryData", "/ctData");
          await writeFile("allWalls", "/all");
        }
      }
    } else {
      Fluttertoast.showToast(
          msg:
              "You are not connected to any network, please connect to a network and reload",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
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
