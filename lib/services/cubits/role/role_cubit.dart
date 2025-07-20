import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qanony/Core/shared/app_cache.dart';

part 'role_state.dart';

class RoleCubit extends Cubit<RoleState> {
  RoleCubit() : super(RoleInitial());

  void selectLawyerRole() async {
    await AppCache.setIsLawyer(true);
    emit(RoleSelected(isLawyer: true));
  }

  void selectUserRole() async {
    await AppCache.setIsLawyer(false);
    emit(RoleSelected(isLawyer: false));
  }

  void loadSavedRole() {
    final isLawyer = AppCache.isLawyer;
    emit(RoleSelected(isLawyer: isLawyer));
  }
}
