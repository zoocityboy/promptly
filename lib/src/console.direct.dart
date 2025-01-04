part of 'console.dart';

final console = Console.instance;
int get spacint => console.spacing;
Theme get currentTheme => console.theme;
PromptTheme get promptTheme => currentTheme.promptTheme;
LoaderTheme get loaderTheme => currentTheme.loaderTheme;
SelectTheme get selectTheme => currentTheme.selectTheme;
ConfirmTheme get confirmTheme => currentTheme.confirmTheme;
HeaderTheme get headerTheme => currentTheme.headerTheme;
TableTheme get tableTheme => currentTheme.tableTheme;

/// Displays a message on the console with an optional prefix and style.
///
/// The [message] parameter specifies the message to be displayed.
/// The [prefix] parameter is an optional string that will be prepended to the message.
/// The [style] parameter is an optional [MessageStyle] that defines the style of the message.
///
String message(String message, {String? prefix, MessageStyle? style}) => Console.instance.message(
      message,
      prefix: prefix,
      style: style,
    );

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
    Console.instance.prompt(prompt, validator: validator, initialText: initialText, defaultValue: defaultValue);

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
    Console.instance
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
    Console.instance.confirm(prompt, defaultValue: defaultValue, enterForConfirm: enterForConfirm);

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
    Console.instance.select(prompt, choices: choices, defaultValue: defaultValue, display: display);

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
    Console.instance.multiSelect(prompt, choices: choices, defaultValues: defaultValues, display: display);

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
    Console.instance.table(prompt, rows: rows, headers: headers);

/// Creates a progress state with the specified parameters.
///
/// The [length] parameter is required and specifies the total length of the progress.
/// The [size] parameter is optional and defaults to 1.0, specifying the size of the progress.
/// The [startLabel] parameter is an optional function that returns a label to be displayed at the start of the progress.
/// The [endLabel] parameter is an optional function that returns a label to be displayed at the end of the progress.
///
/// Returns a [ProgressState] object representing the progress state.
ProgressState progress(
  String prompt, {
  required int length,
  double size = 1.0,
  ProgressFn? startLabel,
  ProgressFn? endLabel,
}) =>
    Console.instance.progress(
      prompt,
      length: length,
      size: size,
      startLabel: startLabel,
      endLabel: endLabel,
    );

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
    Console.instance.processing(prompt, successMessage: successMessage, failedMessage: failedMessage, clear: clear);

void multiProcessing(String prompt, List<Loader> tasks) => Console.instance.multiProcessing(prompt, tasks);

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
    Console.instance
        .task(prompt, task: task, successMessage: successMessage, failedMessage: failedMessage, clear: clear);

/// Inserts a spacer line in the console output.
///
/// This method calls the `spacer` method on the singleton instance of
/// `ZooConsole`, which is responsible for managing console output.
void spacer() => Console.instance.spacer();

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
void line({String? message, String? prefix}) => Console.instance.line(message: message);

/// Clears the console output by invoking the `clear` method on the
/// `ZooConsole` instance.
void clear() => Console.instance.clear();

/// Starts the console with the given title and an optional message.
///
/// This function initializes the console instance with the specified [title].
/// An optional [message] can also be provided.
///
/// Example usage:
/// ```dart
/// start('My Console Title', message: 'Welcome to the console!');
/// ```
///
/// - Parameters:
///   - title: The title to be displayed in the console.
///   - message: An optional message to be displayed in the console.
void header(String title, {String? message}) => Console.instance.header(title, message: message);

/// Ends the console session with a given title and an optional message.
///
/// This function calls the `end` method on the `Console` instance, passing
/// the provided `title` and `message`.
///
/// - Parameters:
///   - title: The title to display when ending the console session.
///   - message: An optional message to display when ending the console session.
void success(String title, {String? message, String? prefix}) => Console.instance.success(title, message: message);

void failure(String title, {String? message, String? prefix}) => Console.instance.failure(title, message: message);

String link(String url, {String? label}) => Console.instance.link(LinkData(uri: Uri.parse(url), message: label));

void write(String message) => Console.instance.write(message);
void writeln(String message) => Console.instance.writeln(message);
