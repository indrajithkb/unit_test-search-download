import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sampleapi/screen/bloc/screen_home_bloc.dart';
import 'package:sampleapi/screen/screenHome.dart';

class ScreenOnboard extends StatefulWidget {
  const ScreenOnboard({required this.imgPathList, super.key});
  final List<String> imgPathList;

  @override
  State<ScreenOnboard> createState() => _ScreenOnboardState();
}

class _ScreenOnboardState extends State<ScreenOnboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ElevatedButton(onPressed: () {}, child: Text('download images')),
            Expanded(
                child: widget.imgPathList.isEmpty
                    ? Text('no images downloaded')
                    : ListView.builder(
                        itemCount: widget.imgPathList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              child: Image.file(
                                File(widget.imgPathList[index]),
                                width: 200,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ))
          ],
        ),
      ),
    );
  }
}
