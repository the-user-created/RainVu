import "dart:convert";
import "dart:io";

import "package:flutter/services.dart" show rootBundle;
import "package:riverpod_annotation/riverpod_annotation.dart";

part "legal_providers.g.dart";

/// A provider that loads the content of a markdown file.
///
/// It first attempts to load from local assets. If that fails, it falls back
/// to fetching the raw content from the public GitHub repository.
@riverpod
Future<String> documentContent(final Ref ref, final String path) async {
  // 1. Try loading from local assets first
  try {
    return await rootBundle.loadString(path);
  } catch (assetError) {
    // 2. If asset loading fails, fall back to fetching from URL
    try {
      final client = HttpClient();
      final Uri uri = Uri.parse(
        "https://raw.githubusercontent.com/the-user-created/RainWise/main/$path",
      );
      final HttpClientRequest request = await client.getUrl(uri);
      final HttpClientResponse response = await request.close();

      if (response.statusCode == 200) {
        final String content = await response.transform(utf8.decoder).join();
        client.close();
        return content;
      } else {
        client.close();
        throw HttpException(
          "Failed to load from URL (Status: ${response.statusCode})",
        );
      }
    } catch (networkError) {
      // 3. If both asset and network fail, throw a final error
      throw Exception(
        "Asset load failed: $assetError\nNetwork fallback failed: $networkError",
      );
    }
  }
}
