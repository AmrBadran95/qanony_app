part of 'role_cubit.dart';

@immutable
abstract class RoleState {}

class RoleInitial extends RoleState {}

class RoleSelected extends RoleState {
  final bool isLawyer;

  RoleSelected({required this.isLawyer});
}
