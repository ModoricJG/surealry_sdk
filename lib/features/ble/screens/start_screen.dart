import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:surearly_smart_sdk/features/ble/screens/home_screen.dart';
import 'package:surearly_smart_sdk/shared/domain/models/start_param.dart';

const channelName = 'com.example.surearly_smart_sdk.host/start';
const methodChannel = MethodChannel(channelName);

class StartScreen extends ConsumerStatefulWidget {
  static const String route = 'start';
  const StartScreen({super.key});

  @override
  ConsumerState<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends ConsumerState<StartScreen>{

  @override
  void initState() {
    super.initState();
    methodChannel.setMethodCallHandler(methodHandler);
  }

  Future<dynamic> methodHandler(MethodCall methodCall) async {
    // 메소드 호출이 입력으로 들어오는 함수
    StartParam? startParam;
    if (methodCall.method == "param") {
      // 메소드 채널에서 호출된 메소드가 "getUserToken"이라는 메소드인 경우
      try {
        startParam = startParamFromJson(methodCall.arguments);
      } catch (e) {
        print("startParam Exception = $e");
      }
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen(param: startParam)), (Route<dynamic> route) => false);
    }
  } // 메소드 채널로 전달된 인자

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
