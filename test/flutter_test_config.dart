import 'dart:async';

import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Without this, GoogleFonts tries to fetch font files over the network
  // on first use, which hangs (or flakes) in a sandboxed test run — fall
  // back to the bundled font instead.
  GoogleFonts.config.allowRuntimeFetching = false;
  await loadAppFonts();
  return testMain();
}
