part of 'console.dart';

final console = ZooConsole.instance;

/// Prompts the user for input with a given message.
///
/// The [prompt] parameter specifies the message to display to the user.
/// The [validator] parameter is an optional function to validate the user's input.
/// The [initialText] parameter specifies the initial text to display in the input field, defaulting to an empty string.
/// The [defaultValue] parameter specifies a default value to use if the user provides no input.
///
/// Returns the user's input as a [String].

String prompt(
  String prompt, {
  Validator<String>? validator,
  String initialText = '',
  String? defaultValue,
}) =>
    ZooConsole.instance.prompt(prompt, validator: validator, initialText: initialText, defaultValue: defaultValue);

/// Prompts the user to enter a password securely.
///
/// The [prompt] parameter specifies the message to display to the user.
///
/// If [confirmation] is set to `true`, the user will be prompted to confirm the password.
/// The [confirmPrompt] parameter specifies the message to display for the confirmation prompt.
/// The [confirmError] parameter specifies the error message to display if the passwords do not match.
///
/// Returns the entered password as a [String].
String password(
  String prompt, {
  bool confirmation = false,
  String? confirmPrompt,
  String? confirmError,
}) =>
    ZooConsole.instance
        .password(prompt, confirmation: confirmation, confirmPrompt: confirmPrompt, confirmError: confirmError);

/// Prompts the user for a confirmation.
///
/// Displays a [prompt] message to the user and waits for a confirmation response.
///
/// The [defaultValue] parameter specifies the default value to use if the user
/// does not provide an input. If [defaultValue] is `null`, the user must provide
/// an explicit response.
///
/// The [enterForConfirm] parameter determines whether pressing the Enter key
/// without any input should be considered as a confirmation. If set to `true`,
/// pressing Enter will confirm the prompt.
///
/// Returns `true` if the user confirms, `false` otherwise.
bool confirm(
  String prompt, {
  bool? defaultValue,
  bool enterForConfirm = false,
}) =>
    ZooConsole.instance.confirm(prompt, defaultValue: defaultValue, enterForConfirm: enterForConfirm);

/// Prompts the user to select an option from a list of provided options.
///
/// The [prompt] parameter is the message displayed to the user.
/// The [choices] parameter is a required list of options for the user to choose from.
/// The [defaultValue] parameter is an optional default value that will be selected if the user does not provide an input.
/// The [display] parameter is an optional function that defines how each option is displayed to the user.
///
/// Returns the selected option of type [T].
///
/// Example usage:
/// ```dart
/// final choice = select(
///   'Choose an option:',
///   choices: ['Option 1', 'Option 2', 'Option 3'],
///   defaultValue: 'Option 1',
///   display: (option) => option.toString(),
/// );
/// ```
T select<T>(
  String prompt, {
  required List<T> choices,
  T? defaultValue,
  String Function(T)? display,
}) =>
    ZooConsole.instance.select(prompt, choices: choices, defaultValue: defaultValue, display: display);

/// Prompts the user with a multi-select question and returns the selected choices.
///
/// The [prompt] parameter is the message displayed to the user.
/// The [choices] parameter is a list of options the user can choose from.
/// The [defaultValues] parameter is an optional list of default selected values.
/// The [display] parameter is an optional function to customize the display of each choice.
///
/// Returns a list of selected choices of type [T].
///
/// Example usage:
/// ```dart
/// List<String> selectedFruits = multiSelect<String>(
///   'Select your favorite fruits:',
///   choices: ['Apple', 'Banana', 'Cherry'],
///   defaultValues: ['Apple'],
///   display: (fruit) => fruit,
/// );
/// ```
List<T> multiSelect<T>(
  String prompt, {
  required List<T> choices,
  List<T>? defaultValues,
  String Function(T)? display,
}) =>
    ZooConsole.instance.multiSelect(prompt, choices: choices, defaultValues: defaultValues, display: display);

/// Displays a processing loader with a given prompt message.
///
/// The loader will display a success or failure message based on the outcome
/// of the processing. Optionally, the console can be cleared before displaying
/// the loader.
///
/// - Parameters:
///   - [prompt]: The message to display while processing.
///   - [successMessage]: An optional message to display upon successful completion.
///   - [failedMessage]: An optional message to display upon failure.
///   - [clear]: A boolean flag indicating whether to clear the console before displaying the loader. Defaults to `false`.
///
/// - Returns: A `LoaderState` representing the state of the loader.
LoaderState processing(
  String prompt, {
  String? successMessage,
  String? failedMessage,
  bool clear = false,
}) =>
    ZooConsole.instance.processing(prompt, successMessage: successMessage, failedMessage: failedMessage, clear: clear);

/// Executes a task with a loading spinner and optional success or failure messages.
///
/// This function displays a prompt and executes the provided task function while showing a loading spinner.
/// Optionally, it can display success or failure messages and clear the console after execution.
///
/// - Parameters:
///   - [prompt]: A string to display as the prompt before executing the task.
///   - [task]: A required function that takes a [LoaderState] spinner and returns a [Future<void>].
///   - [successMessage]: An optional string to display if the task completes successfully.
///   - [failedMessage]: An optional string to display if the task fails.
///   - [clear]: A boolean indicating whether to clear the console after execution. Defaults to `false`.
///
/// - Returns: A [Future<void>] that completes when the task is finished.

Future<void> task(
  String prompt, {
  required Future<void> Function(LoaderState spinner) task,
  String? successMessage,
  String? failedMessage,
  bool clear = false,
}) =>
    ZooConsole.instance
        .task(prompt, task: task, successMessage: successMessage, failedMessage: failedMessage, clear: clear);

/// Inserts a spacer line in the console output.
///
/// This method calls the `spacer` method on the singleton instance of
/// `ZooConsole`, which is responsible for managing console output.
void spacer() => ZooConsole.instance.spacer();

/// Outputs a line to the console.
///
/// If a [message] is provided, it will be included in the output.
///
/// The [message] parameter is optional and can be `null`.
///
/// Example:
/// ```dart
/// line(message: "Hello, World!");
/// ```
void line({String? message}) => ZooConsole.instance.line(message: message);

/// Clears the console output by invoking the `clear` method on the
/// `ZooConsole` instance.
void clear() => ZooConsole.instance.clear();
void start(String title, {String? message}) => ZooConsole.instance.start(title, message: message);
void end(String title, {String? message}) => ZooConsole.instance.end(title, message: message);

String link(LinkData data) => ZooConsole.instance.link(data);

void write(String message) => ZooConsole.instance.write(message);
void writeln(String message) => ZooConsole.instance.writeln(message);

/// Creates a table row with the specified properties.
///
/// This function returns a `TableRow` widget that can be used in a `Table`
/// widget. The properties of the table row can be customized by passing
/// the appropriate parameters.
///
/// Returns:
///   A `TableRow` widget with the specified properties.
TableRow table(
  String prompt, {
  required List<String> headers,
  required List<TableRow> rows,
}) =>
    ZooConsole.instance.table(prompt, rows: rows, headers: headers);
