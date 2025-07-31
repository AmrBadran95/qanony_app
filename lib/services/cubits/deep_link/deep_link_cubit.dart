import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_links/app_links.dart';

part 'deep_link_state.dart';

class DeepLinkCubit extends Cubit<DeepLinkState> {
  final AppLinks _appLinks = AppLinks();

  DeepLinkCubit() : super(DeepLinkInitial());

  StreamSubscription<Uri>? _linkSub;

  void listenToDeepLinks() {
    _linkSub?.cancel();
    _linkSub = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri == null) return;

      final link = uri.toString();
      if (link == 'qanony://connect-success') {
        emit(DeepLinkSuccess());
        _linkSub?.cancel();
      }
    });
  }

  @override
  Future<void> close() {
    _linkSub?.cancel();
    return super.close();
  }
}
