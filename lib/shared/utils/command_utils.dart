import 'package:surearly_smart_sdk/features/ble/manager/ble_manager.dart';
import 'package:surearly_smart_sdk/shared/enums/enums.dart';

class CommandUtils {
  String makeNumberFormat(int number) {
    String formattedNumber = number.toString().padLeft(4, '0');
    return formattedNumber;
  }

  List<int> makeCodeUnits(String command) {
    return command.codeUnits;
  }

  List<int> getCommandString({required DeviceCommand command, int? level}) {
    if (command == DeviceCommand.DEV_INFO) {
      return devInfoCommand(
          colorCode: BleManager().testStickColor,
          delayTime: BleManager().deviceInfo?.stickInsertDelaySeconds ?? 4,
          reactTime: BleManager().deviceInfo?.deviceTestSeconds ?? 300);
    } else if (command == DeviceCommand.DEV_RST) {
      return devRstCommand();
    } else if (command == DeviceCommand.RSLT_DATA) {
      return rsltDataCommand(level: level ?? 9);
    }

    return statkChkCommand();
  }

  List<int> devRstCommand() {
    String command = '|0017DEV_RST@@@@@{"cmd":"DEV_RST"}#';
    BleManager().lastCmd = command;
    return makeCodeUnits(command);
  }

  List<int> statkChkCommand() {
    String command = '|0018STAT_CHK@@@@{"cmd":"STAT_CHK"}#';
    BleManager().lastCmd = command;
    return makeCodeUnits(command);
  }

  List<int> rsltDataCommand({required int level}) {
    String command = '{"cmd":"RSLT_DATA","data":{"rslt_level":$level}}';
    String numberFormat = makeNumberFormat(command.length);
    command = '|${numberFormat}RSLT_DATA@@@${command}#';
    BleManager().lastCmd = command;

    return makeCodeUnits(command);
  }

  List<int> devInfoCommand(
      {required String colorCode,
      required int delayTime,
      required int reactTime}) {
        
    String command =
        '{"cmd":"DEV_INFO","data":{"stick_color":"$colorCode","insert_time":$delayTime,"react_time":$reactTime}}';
    String numberFormat = makeNumberFormat(command.length);
    command = '|${numberFormat}DEV_INFO@@@@$command#';
    BleManager().lastCmd = command;

    return makeCodeUnits(command);
  }
}
