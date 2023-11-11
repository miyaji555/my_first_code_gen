import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:build/build.dart';

Builder copyBuilderForAnnotation(BuilderOptions _) =>
    CopyBuilderForAnnotation();

class CopyBuilderForAnnotation implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': ['.copy.dart'],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    final content = await buildStep.readAsString(inputId);
    final outputId = inputId.changeExtension('.copy.dart');
    final parsedStringResult = parseString(content: content);
    if (_hasCopyAnnotation(parsedStringResult)) {
      await buildStep.writeAsString(outputId, content);
    }
  }

  bool _hasCopyAnnotation(ParseStringResult parsedStringResult) {
    return parsedStringResult.unit.declarations.any(
      (unitMember) => unitMember.metadata
          .any((annotation) => annotation.name.name == 'Copy'),
    );
  }
}
