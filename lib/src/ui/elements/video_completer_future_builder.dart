import 'package:flutter/material.dart';

import '../../data/type_defs.dart';
import '../../logic/shorts_state.dart';
import 'default_widgets.dart';

class VideoCompleterFutureBuilder extends StatelessWidget {
  /// The controller of the short's.
  final ShortsVideoData shortsVideoData;

  /// Will be displayed when an error occurs.
  ///
  /// If null, the default widget is:
  /// ```dart
  /// const Center(
  ///   child: SizedBox(
  ///     width: 50,
  ///     height: 50,
  ///     child: Icon(Icons.error),
  ///   ),
  /// );
  /// ```
  final Widget Function(Object error, StackTrace? stackTrace)? errorWidget;

  /// The widget that will be displayed while the [ShortsController]
  /// initial dependencies are loading.
  ///
  /// If null, the default widget is:
  /// ```dart
  /// const Center(
  ///   child: SizedBox(
  ///     width: 50,
  ///     height: 50,
  ///     child: CircularProgressIndicator.adaptive(),
  ///   ),
  /// );
  /// ```
  final Widget? loadingWidget;

  /// The element builder.
  final Widget Function(
    BuildContext context,
    VideoData videoData,
  ) builder;

  /// The index of the video.
  final int index;

  const VideoCompleterFutureBuilder({
    Key? key,
    required this.shortsVideoData,
    this.errorWidget,
    this.loadingWidget,
    required this.index,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: shortsVideoData.video.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final data = snapshot.data;
          if (snapshot.hasError || data == null) {
            return errorWidget?.call(
                  snapshot.error!,
                  snapshot.stackTrace,
                ) ??
                const YoutubeShortsDefaultErrorWidget();
          }

          return builder(context, data);
        }

        return loadingWidget ?? const YoutubeShortsDefaultLoadingWidget();
      },
    );
  }
}
