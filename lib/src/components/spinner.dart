import 'dart:async' show StreamSubscription, Timer;
import 'dart:io' show ProcessSignal;

import 'package:zoo_console/src/framework/framework.dart';
import 'package:zoo_console/src/theme/theme.dart';
import 'package:zoo_console/src/utils/utils.dart';

String _prompt(SpinnerStateType _) => '';

enum SpinnerStateType { inProgress, success, failed }

/// A spinner or a loading indicator component.
class Spinner extends Component<SpinnerState> {
  /// Construts a [Spinner] component with the default theme.
  Spinner({
    required this.prompt,
    String? icon,
    String? failedIcon,
    this.clear = false,
  })  : theme = Theme.defaultTheme,
        icon = icon ?? Theme.defaultTheme.successPrefix,
        failedIcon = failedIcon ?? Theme.defaultTheme.errorPrefix;

  /// Constructs a [Spinner] component with the supplied theme.
  Spinner.withTheme({
    required this.prompt,
    String? icon,
    String? failedIcon,
    required this.theme,
    this.clear = false,
  })  : icon = icon ?? theme.successPrefix,
        failedIcon = failedIcon ?? theme.errorPrefix;

  Context? _context;
  final String prompt;

  /// The theme of the component.
  final Theme theme;

  /// The icon to be shown in place of the loading
  /// indicator after it's done.
  final String icon;

  /// The icon to be shown in place of the loading
  /// indicator after it's failed.
  final String failedIcon;

  final bool clear;

  @override
  _SpinnerState createState() => _SpinnerState();

  @override
  void disposeState(State state) {}

  @override
  State pipeState(State state) {
    if (_context != null) {
      state.setContext(_context!);
    }
    return state;
  }

  /// Sets the context to a new one,
  /// to be used internally by [MultiSpinner].
  // ignore: use_setters_to_change_properties
  void setContext(Context c) => _context = c;
}

/// Handles a [Spinner]'s state.
class SpinnerState {
  /// Constructs a state to manage a [Spinner].
  SpinnerState({required this.success, required this.failed, required this.update});

  void Function() Function(String? message) update;

  /// Function to be called to indicate that the
  /// spinner is loaded.
  void Function() Function(String? message) success;

  /// Function to be called to indicate that the
  /// spinner is failed.
  void Function() Function(String? message) failed;
}

class _SpinnerState extends State<Spinner> {
  late SpinnerStateType stateType;
  late String message;
  late int index;
  late StreamSubscription<ProcessSignal> sigint;

  @override
  void init() {
    super.init();
    stateType = SpinnerStateType.inProgress;
    message = component.prompt;
    index = 0;
    sigint = handleSigint();
    context.hideCursor();
  }

  @override
  void dispose() {
    if (component.clear) {
      context.erasePreviousLine();
    }
    context.showCursor();
    super.dispose();
  }

  @override
  void render() {
    final line = StringBuffer();
    if (stateType == SpinnerStateType.success) {
      line.write(component.icon);
    } else if (stateType == SpinnerStateType.failed) {
      line.write(component.failedIcon);
    } else {
      line.write(component.theme.spinners[index]);
    }

    final x = switch (stateType) {
      SpinnerStateType.inProgress => component.theme.defaultStyle(message),
      SpinnerStateType.success => component.theme.valueStyle(message),
      SpinnerStateType.failed => component.theme.errorStyle(message),
    };
    line.write(x);
    context.writeln(line.toString());
  }

  @override
  SpinnerState interact() {
    final timer = Timer.periodic(
      Duration(
        milliseconds: component.theme.spinningInterval,
      ),
      (timer) {
        setState(() {
          index = (index + 1) % component.theme.spinners.length;
        });
      },
    );

    final state = SpinnerState(
      update: (message) {
        setState(() {
          stateType = SpinnerStateType.inProgress;
          if (message != null) this.message = message;
        });
        return () {};
      },
      success: (message) {
        setState(() {
          stateType = SpinnerStateType.success;
          if (message != null) this.message = message;
          sigint.cancel();
        });
        timer.cancel();
        if (component._context != null) {
          return dispose;
        } else {
          dispose();
          return () {};
        }
      },
      failed: (message) {
        setState(() {
          stateType = SpinnerStateType.failed;
          if (message != null) this.message = message;
          sigint.cancel();
        });
        timer.cancel();
        if (component._context != null) {
          return dispose;
        } else {
          dispose();
          return () {};
        }
      },
    );

    return state;
  }
}
