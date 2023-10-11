import 'dart:async';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:surearly_smart_sdk/configs/app_configs.dart';
import 'package:surearly_smart_sdk/features/ble/manager/ble_manager.dart';
import 'package:surearly_smart_sdk/features/ble/providers/ble_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/lot_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/sdk_state_provider.dart';
import 'package:surearly_smart_sdk/features/ble/providers/test_info_state_provider.dart';
import 'package:surearly_smart_sdk/shared/constants/app_constants.dart';
import 'package:surearly_smart_sdk/shared/constants/route_constants.dart';
import 'package:surearly_smart_sdk/shared/domain/models/header_info.dart';
import 'package:surearly_smart_sdk/shared/domain/models/initialize_request.dart';
import 'package:surearly_smart_sdk/shared/domain/models/start_param.dart';
import 'package:surearly_smart_sdk/shared/enums/web_enums.dart';
import 'package:surearly_smart_sdk/shared/script/app_to_web.dart';
import 'package:surearly_smart_sdk/shared/script/web_to_app.dart';
import 'package:surearly_smart_sdk/shared/state/common_state.dart';
import 'package:surearly_smart_sdk/shared/utils/common_utils.dart';
import 'package:surearly_smart_sdk/shared/utils/log_utils.dart';
import 'package:surearly_smart_sdk/shared/utils/stick_check_timer.dart';
import 'package:surearly_smart_sdk/shared/utils/stick_out_timer.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:surearly_smart_sdk/features/ble/screens/home_ble_extension.dart';
import 'package:surearly_smart_sdk/features/ble/screens/home_web_extension.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const String route = 'home';
  final StartParam? param;
  const HomeScreen({super.key, this.param});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  final Completer<InAppWebViewController> _completerController =
      Completer<InAppWebViewController>();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _initCheckPermissoin(state);
    _checkDialogCount(state);
  }

  @override
  void initState() {
    super.initState();
    _initStickTimer();
    _getAppVersion();
    WidgetsBinding.instance.addObserver(this);
  }

  _getAppVersion() async {
    BleManager().appVersion = await CommonUtils.appVersion();
  }

  _initStickTimer() {
    StickCheckTimer().initTimer(widgetRef: ref);
    StickOutTimer().initTimer(widgetRef: ref);
  }

  _initCheckPermissoin(AppLifecycleState state) {
    final checkedPermission = ref.read(permissionChecked.notifier).state;
    if (checkedPermission != null &&
        !checkedPermission &&
        state == AppLifecycleState.resumed) {
      ref.read(permissionChecked.notifier).state = null;
      _checkBluetoothPermission();
    }
  }

  _checkDialogCount(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        BleManager().dialogCount >= 2 &&
        Platform.isAndroid) {
      Future.delayed(const Duration(seconds: 1)).then((_) {
        BleManager().connectStatChk(ref: ref);
        BleManager().receivedData(ref: ref);
      });
    } else if (state == AppLifecycleState.inactive) {
      BleManager().dialogCount += 1;
    }
  }

  _checkPermission({required String type}) {
    if (type == PermissionType.camera.name) {
      LogUtils()
          .saveLogEvent(ref: ref, type: LogType.event, tag: LogTag.MOVE_LOT_QR);
      _checkCameraPermission();
    } else {
      _checkBluetoothPermission();
    }
  }

  _checkBluetoothPermission() {
    if (Platform.isAndroid) {
      _aosLocationPermission();
    } else if (Platform.isIOS) {
      _iosPermission();
    }
  }

  _checkCameraPermission() {
    final controller = ref.read(webViewControllerProvider.notifier).state;
    if (Platform.isAndroid) {
      [
        Permission.camera,
      ].request().then((status) {
        if (status.containsValue(PermissionStatus.granted)) {
          _moveToQrCode(controller: controller);
        }
      });
    } else {
      _moveToQrCode(controller: controller);
    }
  }

  _moveToQrCode({required InAppWebViewController? controller}) {
    AppToWeb().moveToWithLot(
        controller: controller,
        lotResponse: ref.read(lotListNotifierProvider.notifier).state,
        testType: ref.read(selectedTestType.notifier).state ?? '',
        route: RouteConstants.qrCode);
    LogUtils()
        .saveLogEvent(ref: ref, type: LogType.view, tag: LogTag.MOVE_LOT_QR);
  }

  _aosLocationPermission() {
    //위치먼저 체크
    [
      Permission.location,
    ].request().then((status) {
      if (status.containsValue(PermissionStatus.denied) ||
          status.containsValue(PermissionStatus.permanentlyDenied)) {
        AppToWeb().showCommonDialog(
            controller: ref.read(webViewControllerProvider.notifier).state,
            dialogType: CommonDialogType.permissionLocation);
      } else {
        _aosBlePermission();
      }
    });
  }

  _aosBlePermission() {
    [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan
    ].request().then((status) async {
      print("status ====== $status");
      if (status.containsValue(PermissionStatus.permanentlyDenied)) {
        AppToWeb().showCommonDialog(
            controller: ref.read(webViewControllerProvider.notifier).state,
            dialogType: CommonDialogType.permissionBluetooth);
      } else {
        await FlutterBluePlus.turnOn();
        ref.read(permissionChecked.notifier).state = true;
      }
    });
  }

  void _iosPermission() async {
    await FlutterBluePlus.adapterState
        .map((state) {
          if (state == BluetoothAdapterState.unauthorized) {
            AppToWeb().showCommonDialog(
                controller: ref.read(webViewControllerProvider.notifier).state,
                dialogType: CommonDialogType.permissionBluetooth);
          } else if (state == BluetoothAdapterState.on) {
            ref.read(permissionChecked.notifier).state = true;
          }
          return state;
        })
        .where((s) => s == BluetoothAdapterState.on)
        .first;
  }

  Widget webView() {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final bottomBarHeight = MediaQuery.of(context).padding.bottom;
    final splashUrl =
        '${AppConfigs.webBaseUrl}statusBarHeight=$statusBarHeight&bottomBarHeight=$bottomBarHeight';

    return InAppWebView(
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
        ),
        android: AndroidInAppWebViewOptions(
          useHybridComposition: true,
        ),
        ios: IOSInAppWebViewOptions(
          allowsInlineMediaPlayback: true,
        ),
      ),
      onWebViewCreated: (controller) {
        _completerController.future.then((value) async {
          if (Platform.isAndroid) {
            AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
          }
          // controller = controller;
          ref.read(webViewControllerProvider.notifier).state = controller;
          controller.loadUrl(
              urlRequest: URLRequest(
            url: Uri.parse(splashUrl),
          ));
        });
        _completerController.complete(controller);

        controller.addJavaScriptHandler(
            handlerName: HandlerType.permission.name,
            callback: (type) async {
              _checkPermission(type: type.first);
            });
        controller.addJavaScriptHandler(
            handlerName: HandlerType.permissionSetting.name,
            callback: (type) async {
              ref.read(permissionChecked.notifier).state = false;
              WebToApp().moveToSetting();
            });
        controller.addJavaScriptHandler(
            handlerName: HandlerType.selectType.name,
            callback: (type) async {
              selectTestType(type.first);
              _watchLotState();
            });
        controller.addJavaScriptHandler(
            handlerName: HandlerType.startTest.name,
            callback: (type) async {
              AppToWeb().moveToWithLot(
                  controller: controller,
                  lotResponse: ref.read(lotListNotifierProvider.notifier).state,
                  testType: ref.read(selectedTestType.notifier).state ?? '',
                  route: RouteConstants.lotConfirm);
            });
        controller.addJavaScriptHandler(
            handlerName: HandlerType.selectLot.name,
            callback: (lot) async {
              selectLot(ref: ref, lotNumber: lot.first);
            });
        controller.addJavaScriptHandler(
            handlerName: HandlerType.startSearch.name,
            callback: (data) async {
              setRecentDeviceList(ref: ref);
              LogUtils().saveLogEvent(
                  ref: ref, type: LogType.event, tag: LogTag.SEARCH_DEVICE);
              await startBleScan();
            });
        controller.addJavaScriptHandler(
            handlerName: HandlerType.selectDevice.name,
            callback: (device) async {
              deviceConnect(selectedDevice: device.first);
            });
        controller.addJavaScriptHandler(
            handlerName: HandlerType.finish.name,
            callback: (device) async {
              LogUtils().saveLogEvent(
                  ref: ref, type: LogType.event, tag: LogTag.SDK_END);
              SystemNavigator.pop();
            });
        controller.addJavaScriptHandler(
            handlerName: HandlerType.lotTypeDifferent.name,
            callback: (device) async {
              lotMismatchConfirm(ref: ref);
            });
        controller.addJavaScriptHandler(
            handlerName: HandlerType.notificationSet.name,
            callback: (device) {
              AwesomeNotifications()
                  .isNotificationAllowed()
                  .then((isAllowed) async {
                if (!isAllowed) {
                  final agree = await AwesomeNotifications()
                      .requestPermissionToSendNotifications();
                  AppToWeb()
                      .setNotification(controller: controller, agree: agree);
                }
              });
            });
        controller.addJavaScriptHandler(
            handlerName: HandlerType.notificationGet.name,
            callback: (device) {
              AwesomeNotifications()
                  .isNotificationAllowed()
                  .then((isAllowed) async {
                AppToWeb()
                    .getNotification(controller: controller, agree: isAllowed);
              });
            });
        controller.addJavaScriptHandler(
            handlerName: HandlerType.sendLog.name,
            callback: (tag) {
              if (tag.first != null) {
                final tagName = tag.first;
                final tagType = (tagName == SendLogType.cancel.name)
                    ? LogTag.CANCEL_TEST
                    : (tagName == SendLogType.finish.name)
                        ? LogTag.END_TEST
                        : LogTag.MOVE_LOT_DIRECT;
                LogUtils()
                    .saveLogEvent(ref: ref, type: LogType.event, tag: tagType);
              }
            });
      },
      onLoadStop: (controller, url) {
        if (url.toString().contains(AppConfigs.webBaseUrl)) {
          _completeLoadingWebView(context);
        }
      },
      onLoadError: ((controller, url, code, message) {}),
      onLoadHttpError: (controller, url, statusCode, description) {},
      androidOnPermissionRequest: (controller, origin, resources) async {
        return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceListState();
    deviceState();
    statChkState();
    progressTimeState();
    testResultState();
    testResultToDeviceResponse();
    stickOutedProcess();

    return Scaffold(
      backgroundColor: Colors.white,
      body: webView(),
    );
  }

  _completeLoadingWebView(BuildContext context) {
    final controller = ref.read(webViewControllerProvider.notifier).state;
    controller
        ?.evaluateJavascript(
      source: 'window.navigator.language',
    )
        .then((value) {
      String acceptLanguage = value ?? 'en-US';
      _sdkInit(language: acceptLanguage);
    });
  }

  _sdkInit({required String language}) {
    final headerInfo = HeaderInfo(
        xClientId:
            "jSIWHLKZVHcAE7dMulUShrwlTpLabHhg5nAseRzV5avLfEy80kdwJhn8O9BlyJU3",
        xSdkSecret: "thisisthesdk",
        xBundleId: "com.vespexx.moduletest2",
        acceptLanguage: language);
    final initializeRequest = InitializeRequest(
      identifier: "jjing2",
      mobilePhone: MobilePhone(
          appOs: "IOS",
          appOsVersion: "app",
          phoneModel: "phone",
          phoneUid: "uid",
          sdkVersion: "1"),
      profile: Profile(birth: 1900, gender: "M", name: "jjing"),
    );

    final controller = ref.read(webViewControllerProvider.notifier).state;
    ref.watch(
        requestSdkInitNotifierProvider(Tuple2(headerInfo, initializeRequest))
            .select((states) {
      if (states.state == CommonConcreteState.loaded) {
        if (states.response?.code == AppConstants.successCode) {
          setSessionInfo(
              sessionId: states.response?.data?.sessionAlphaId ?? '');
          ref.read(initializeNotifierProvider.notifier).state = states.response;
          setBleManagerConstants();
          moveToTestListPage(controller: controller);
        }
      } else if (states.state == CommonConcreteState.failure) {
        AppToWeb()
            .showErrorDialog(controller: controller, code: "S-${states.code}");
      }
    }));
  }

  _watchLotState() {
    final controller = ref.read(webViewControllerProvider.notifier).state;
    final testType = ref.read(selectedTestType.notifier).state ?? '';
    ref.watch(requestLotsNotifierProvider(testType).select((states) {
      if (states.state == CommonConcreteState.loaded) {
        if (states.response?.code == AppConstants.successCode) {
          ref.read(lotListNotifierProvider.notifier).state = states.response;
          AppToWeb().moveToPreparation(
              controller: controller,
              testType: ref.read(selectedTestType.notifier).state ?? '');
        }
      } else if (states.state == CommonConcreteState.failure) {
        AppToWeb()
            .showErrorDialog(controller: controller, code: "S-${states.code}");
      }
    }));
  }
}
