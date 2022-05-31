/*
CRONS:

30 1 /bin/run_me_daily
45 * /bin/run_me_hourly
* * /bin/run_me_every_minute
* 19 /bin/run_me_sixty_times
*/

// How to run:
// dart run minicron.dart <simulated current time>

abstract class CodeErrors {
  static const tooFewArgs = 'At least one argument must be provided';
  static const tooManyArgs = 'Only one argument must be provided';
  static const invalidFormat = 'Please, use HH:MM format';
  static const unableToParse = 'Unable to parse';
  static const invalidHour = 'Invalid hour input';
  static const invalidMinute = 'Invalid minute input';
}

// TODO(carlos): Improve error handling 😅
int main(List<String> args) {
  if (args.length != 1) {
    if (args.length < 1)
      return exit(error: CodeErrors.tooFewArgs);
    else
      return exit(error: CodeErrors.tooManyArgs);
  }

  if (args[0].length != 4 && args[0].length != 5)
    return exit(error: CodeErrors.invalidFormat);

  if (args[0].length == 4 && args[0][1] != ':')
    return exit(error: CodeErrors.invalidFormat);

  if (args[0].length == 5 && args[0][2] != ':')
    return exit(error: CodeErrors.invalidFormat);

  late final int hour;
  late final int minute;

  // TODO(carlos): This should be refactored (Both hour && Minute)
  if (args[0].length == 4) {
    try {
      hour = int.tryParse(args[0][0])!;

      final j = int.tryParse(args[0][2])! * 10;
      final j2 = int.tryParse(args[0][3])!;

      minute = j + j2;
    } catch (e) {
      return exit(error: '${CodeErrors.unableToParse}\n[$e]');
    }
  } else {
    try {
      final i = int.tryParse(args[0][0])! * 10;
      final i2 = int.tryParse(args[0][1])!;

      final j = int.tryParse(args[0][3])! * 10;
      final j2 = int.tryParse(args[0][4])!;

      hour = i + i2;
      minute = j + j2;
    } catch (e) {
      return exit(error: '${CodeErrors.unableToParse}\n[$e]');
    }
  }

  if (hour < 0 || hour > 23) return exit(error: CodeErrors.invalidHour);
  if (minute < 0 || minute > 59) return exit(error: CodeErrors.invalidMinute);

  String i1;
  if (hour == 1 && minute < 30) {
    i1 = '1:30 today';
  } else {
    i1 = '1:30 tomorrow';
  }

  String i2;

//45 * /bin/run_me_hourly
  if (hour == 23 && minute >= 45) {
    i2 = '00:45 tomorow';
  } else if (minute >= 45) {
    i2 = '${hour + 1}:45 today';
  } else {
    i2 = '$hour:45 today';
  }

  String i3;
  if (hour == 23 && minute == 59) {
    i3 = '00:00 tomorrow';
  } else if (minute == 59) {
    i3 = '${hour + 1}:00 today';
  } else
    i3 = '$hour:${fixMinute(minute + 1)} today';

  String i4;
  if (hour == 19 && minute != 59) {
    i4 = '19:${fixMinute(minute + 1)} today';
  } else {
    i4 = '19:00 ${hour >= 19 ? 'tomorrow' : 'today'}';
  }

  return (ret(
    i1: i1,
    i2: i2,
    i3: i3,
    i4: i4,
  ));
}

String fixMinute(int min) => min < 10 ? '0$min' : min.toString();

int ret({
  required String i1,
  required String i2,
  required String i3,
  required String i4,
}) {
  print('''$i1 - /bin/run_me_daily
$i2 - /bin/run_me_hourly
$i3 - /bin/run_me_every_minute
$i4 - /bin/run_me_sixty_times''');

  return (0);
}

int exit({required String error}) {
  print('\x1B[31mError: $error\x1B[0m');

  return (1);
}
