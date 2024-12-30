import 'package:zoo_console/src/components/loader.dart';
import 'package:zoo_console/src/framework/framework.dart';

/// A shared context and handler for rendering multiple [Loader]s.
class MultiSpinner {
  final Context _context = Context();
  final List<StringBuffer> _lines = [];
  final List<LoaderState> _spinners = [];
  final List<void Function()> _disposers = [];

  void _dispose(void Function() fn) {
    fn();

    if (_disposers.length == _spinners.length) {
      for (final disposer in _disposers) {
        disposer();
      }
    }
  }

  void _render() {
    if (_context.renderCount > 0) {
      _context.erasePreviousLine(_context.linesCount);
      _context.resetLinesCount();
    }

    for (final line in _lines) {
      _context.writeln(line.toString());
    }

    _context.increaseRenderCount();
  }

  /// Adds a new [Loader] to current [MultiSpinner].
  LoaderState add(Loader spinner) {
    final index = _spinners.length;

    _lines.add(StringBuffer());
    spinner.setContext(
      BufferContext(
        buffer: _lines[index],
        setState: _render,
      ),
    );
    _spinners.add(spinner.interact());

    final state = LoaderState(
      success: (message) {
        final disposer = _spinners[index].success(message);
        _dispose(() {
          _disposers.add(disposer);
        });
        return disposer;
      },
      failed: (message) {
        final disposer = _spinners[index].failed(message);
        _dispose(() {
          _disposers.add(disposer);
        });
        return disposer;
      },
      update: (message) => _spinners[index].update(message),
    );

    return state;
  }
}
