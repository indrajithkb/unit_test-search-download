import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sampleapi/model/user_model.dart';
import 'package:sampleapi/repo/repository.dart';
import 'package:sampleapi/screen/bloc/screen_home_bloc.dart';
import 'package:sampleapi/screen/screenOnboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenHome extends StatefulWidget {
  ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  List<String> imgPath = [];

  Future<void> downloadAndSaveImage(String imageUrl) async {
    try {
      Dio dio = Dio();

      // Generate a unique filename based on the current time
      final uniqueFileName =
          DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$uniqueFileName';

      await dio.download(
        imageUrl,
        filePath,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      imgPath.add(filePath);
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('imagePaths', imgPath);
      // final savedImagePaths = prefs.getStringList('imagePaths') ?? [];
      // print(savedImagePaths);

      // You can use 'filePath' as needed, for example, displaying it or storing its path.
    } catch (e) {
      // Handle any errors that occur during the download process
      print('Error: $e');
    }
  }

  Future<void> loadSavedImagePaths() async {
    final prefs = await SharedPreferences.getInstance();
    final savedImagePaths = prefs.getStringList('imagePaths') ?? [];
    setState(() {
      imgPath = savedImagePaths;
    });
  }

  @override
  void initState() {
    loadSavedImagePaths();

    super.initState();
  }

  List<Data> filterUserList(List<Data> userList, String query) {
    return userList.where((user) {
      return user.firstName?.toLowerCase().contains(query) ?? false;
    }).toList();
  }

  // var imageList = [];
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // UserRepo().getApiData();
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Api'),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScreenOnboard(imgPathList: imgPath),
                    ));
              },
              icon: const Icon(Icons.arrow_forward_ios_rounded))
        ],
      ),
      body: BlocBuilder<ScreenHomeBloc, ScreenHomeState>(
        builder: (context, state) {
          if (state is ScreenHomeLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ScreenHomeLoadedState) {
            final UserModel userList = state.user as UserModel;
            List<Data> userSearchList = userList.data!;

            if (_searchController.text.isNotEmpty) {
              final query = _searchController.text.toLowerCase();
              userSearchList = filterUserList(userSearchList, query);
            }
            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (query) {
                      setState(() {});
                    },
                    controller: _searchController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 15),
                        hintText: 'search',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        )),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: userSearchList.length,
                    itemBuilder: (context, index) {
                      // print(userList.data![index].avatar);

                      // final data = userList.data!;
                      // print(data[index].firstName);
                      // bool isImageDownloaded = index < imgPath.length;
                      return Card(
                          child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              userSearchList[index].avatar.toString()),
                        ),
                        title: Text(userSearchList[index].firstName.toString()),
                        subtitle: Text(userSearchList[index].email.toString()),
                      ));
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      for (final userData in userList.data!) {
                        downloadAndSaveImage(userData.avatar!);
                      }
                    },
                    child: const Text('download images')),
                const SizedBox(height: 8),
              ],
            );
          }
          if (state is ScreenHomeErrorState) {
            return Text(state.error);
          }
          return Container();
        },
      ),
    );
  }
}
