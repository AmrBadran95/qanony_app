import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../data/models/lawyer_model.dart';
part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  List<LawyerModel> originalLawyers = [];
  List<LawyerModel> allLawyers = [];

  String? type;
  String? specialization;
  String? contactMethod;
  String? nameQuery;

  SearchCubit() : super(SearchInitial()) {
    loadlawyer();
  }

  void loadlawyer() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('lawyers')
          .where('subscriptionType', isNotEqualTo: 'free')
          .get();

      originalLawyers = snapshot.docs
          .map((doc) => LawyerModel.fromJson(doc.data()))
          .toList();

      allLawyers = List.from(originalLawyers);

      emit(SearchLoading(allLawyers));
    } catch (e) {
      emit(SearchError('فشل تحميل بيانات المحاميين  $e'));
    }
  }

  void updateFilter({
    String? newType,
    String? newSpecialization,
    String? newContactMethod,
    String? newNameQuery,
  }) {
    if (newType != null) type = newType;
    if (newSpecialization != null) specialization = newSpecialization;
    if (newContactMethod != null) contactMethod = newContactMethod;
    if (newNameQuery != null) nameQuery = newNameQuery;

    filter();
  }

  void filter() {
    allLawyers = originalLawyers.where((lawyer) {
      final matchesType = type == null || lawyer.gender == type;

      final matchesSpecialization =
          specialization == null || lawyer.specialty!.contains(specialization!);

      final matchesContactMethod =
          contactMethod == null ||
          (contactMethod == 'call' && lawyer.offersCall == true) ||
          (contactMethod == 'office' && lawyer.offersOffice == true);

      final matchesName =
          nameQuery == null || (lawyer.fullName?.contains(nameQuery!) ?? false);

      return matchesType &&
          matchesSpecialization &&
          matchesContactMethod &&
          matchesName;
    }).toList();

    emit(SearchLoading(allLawyers));
  }

  void clearFilters() {
    type = null;
    specialization = null;
    nameQuery = null;
    contactMethod = null;
    allLawyers = List.from(originalLawyers);
    emit(SearchLoading(allLawyers));
  }
}
