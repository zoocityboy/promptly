import 'dart:async' show StreamSubscription, Timer;
import 'dart:io' show ProcessSignal;

import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';
import 'package:promptly/src/utils/utils.dart';

/// Represents the state of a loader.
/// 
/// The loader can be in one of the following states:
/// - `inProgress`: The loading process is currently ongoing.
/// - `success`: The loading process has completed successfully.
/// - `failed`: The loading process has failed.
enum LoaderStateType { inProgress, success, failed }

/// A [Loader] component that displays a loading indicator with customizable
/// icons for success and failure states.
///
/// The [Loader] can be constructed with either the default theme or a
/// supplied theme. It also supports an optional clear state.
///
/// Example usage:
/// ```dart
/// Loader(
///   prompt: 'Loading...',
///   icon: 'success_icon',
///   failedIcon: 'error_icon',
///   clear: true,
/// );
/// ```
///
/// Example usage with a custom theme:
/// ```dart
/// Loader.withTheme(
///   prompt: 'Loading...',
///   icon: 'success_icon',
///   failedIcon: 'error_icon',
///   theme: customTheme,
///   clear: true,
/// );
/// ```
///
/// Properties:
/// - `prompt`: The prompt message to be displayed.
/// - `icon`: The icon to be shown after the loading is successful.
/// - `failedIcon`: The icon to be shown after the loading has failed.
/// - `theme`: The theme of the component.
/// - `clear`: A boolean indicating whether to clear the state.
///
/// Methods:
/// - `createState`: Creates the state for the [Loader] component.
/// - `disposeState`: Disposes the state of the [Loader] component.
/// - `pipeState`: Pipes the state to a new context if available.
/// - `setContext`: Sets the context to a new one, used internally by [MultiSpinner].

class Loader extends StateComponent<LoaderState> {
  /// Construts a [Loader] component with the default theme.
  Loader({
    required this.prompt,
    String? icon,
    String? failedIcon,
    this.clear = false,
  })  : theme = Theme.defaultTheme,
        icon = icon ?? Theme.defaultTheme.loaderTheme.successPrefix,
        failedIcon = failedIcon ?? Theme.defaultTheme.loaderTheme.errorPrefix;

  /// Constructs a [Loader] component with the supplied theme.
  Loader.withTheme({
    required this.prompt,
    String? icon,
    String? failedIcon,
    required this.theme,
    this.clear = false,
  })  : icon = icon ?? theme.loaderTheme.successPrefix,
        failedIcon = failedIcon ?? theme.loaderTheme.errorPrefix;

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
  _LoaderState createState() => _LoaderState();

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

/// Handles a [Loader]'s state.
class LoaderState {
  /// Constructs a state to manage a [Loader].
  LoaderState({
    required this.success,
    required this.failed,
    required this.update,
  });

  void Function() Function(String? message) update;

  /// Function to be called to indicate that the
  /// spinner is loaded.
  void Function() Function(String? message) success;

  /// Function to be called to indicate that the
  /// spinner is failed.
  void Function() Function(String? message) failed;
}

class _LoaderState extends State<Loader> {
  late LoaderStateType stateType;
  late String message;
  late int index;
  late StreamSubscription<ProcessSignal> sigint;
  LoaderTheme get theme => component.theme.loaderTheme;

  @override
  void init() {
    super.init();
    stateType = LoaderStateType.inProgress;
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
    final icon = switch (stateType) {
      LoaderStateType.inProgress => theme.processingStyle(
          theme.spinners[index].padRight(component.theme.spacing),
        ),
      LoaderStateType.success =>
        theme.successStyle(component.icon.padRight(component.theme.spacing)),
      LoaderStateType.failed => theme
          .errorStyle(component.failedIcon.padRight(component.theme.spacing)),
    };

    final formatedMessage = switch (stateType) {
      LoaderStateType.inProgress => theme.processingStyle(message),
      LoaderStateType.success => theme.successStyle(message),
      LoaderStateType.failed => theme.errorStyle(message),
    };
    // ignore: unnecessary_string_interpolations
    line.write(icon);
    line.write(formatedMessage);
    context.writeln(line.toString());
  }

  @override
  LoaderState interact() {
    final timer = Timer.periodic(
      Duration(
        milliseconds: theme.interval,
      ),
      (timer) {
        setState(() {
          index = (index + 1) % theme.spinners.length;
        });
      },
    );

    final state = LoaderState(
      update: (message) {
        setState(() {
          stateType = LoaderStateType.inProgress;
          if (message != null) this.message = message;
        });
        return () {};
      },
      success: (message) {
        setState(() {
          stateType = LoaderStateType.success;
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
          stateType = LoaderStateType.failed;
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
