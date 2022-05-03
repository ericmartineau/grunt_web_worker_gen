import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'grunt_generator.dart';

Builder gruntBuilder(BuilderOptions options) =>
    LibraryBuilder(GruntGenerator(), generatedExtension: '.grunt.dart');
