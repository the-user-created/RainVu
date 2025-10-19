import "dart:io" show Platform;

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:in_app_review/in_app_review.dart";
import "package:rainvu/app_constants.dart";
import "package:share_plus/share_plus.dart";

/// Provides a service for interacting with the platform's app store.
final appStoreServiceProvider = Provider<AppStoreService>(
  (final ref) => AppStoreService(),
);

/// A service to handle interactions like opening the store and sharing the app.
class AppStoreService {
  final InAppReview _inAppReview = InAppReview.instance;

  /// Opens the app's page on the Google Play Store or Apple App Store.
  ///
  /// This method is intended to be called from a user-initiated action,
  /// such as tapping a "Leave a Review" button. Throws an exception on failure.
  Future<void> openStoreListingForReview() async {
    // This is the most reliable way to ask for a review via a button.
    // It directly opens the store page.
    await _inAppReview.openStoreListing(appStoreId: AppConstants.kAppStoreId);
  }

  /// Opens the platform's native share sheet to share the app.
  ///
  /// Includes the appropriate store link in the shared text.
  /// The [context] is used to get the share button's position for iPad.
  Future<void> shareApp({
    required final BuildContext context,
    required final String text,
    required final String subject,
  }) async {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    final Rect? sharePositionOrigin = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    final String storeUrl = Platform.isIOS
        ? AppConstants.kAppStoreUrl
        : AppConstants.kPlayStoreUrl;

    // Combine the base text with the store URL for a complete message.
    final String shareText = "$text\n\n$storeUrl";

    await SharePlus.instance.share(
      ShareParams(
        text: shareText,
        subject: subject,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }
}
