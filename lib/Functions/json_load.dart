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

    final path = await _directoryPath;

    var newFile =
        await File('$path/Walldata/$fileName.json').create(recursive: true);
    await newFile.delete();
    await newFile.writeAsBytes(utf8.encode(jsonEncode(response.data)));
    readFile(fileName);
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
    if (shouldDownload.toString() == "Instance of 'Future<dynamic>'" ||
        shouldDownload == null) {
      //as current state file not present then we need to download all files.
      writeFile("initState", "/prState");
      writeFile("catagoryData", "/ctData");
      writeFile("allWalls", "/all");
    } else {
      //also to download if newer version available.

      final res =
          await dio.get("https://drab-erin-moose-ring.cyclic.app/version");

      if (int.parse(res.toString()) > shouldDownload["version"]) {
        writeFile("initState", "/prState");
        writeFile("catagoryData", "/ctData");
        writeFile("allWalls", "/all");
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
