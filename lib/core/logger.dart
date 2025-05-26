import 'package:logger/logger.dart';

class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}

final logger = Logger(
  filter: MyFilter(),
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    // dateTimeFormat: DateTimeFormat.none
  ),
);
