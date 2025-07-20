// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';

// import '../../../../data/models/lawyer_model.dart';

// part 'search_state.dart';

// class SearchCubit extends Cubit<SearchState> {
//   List<LawyerModel> AllLawyer = [];

//   String? type;
//   String? specialization;
//   String? contactMethod;
//   String? nameQuery;

//   SearchCubit() : super(SearchInitial()) {
//     loadlawyer();
//   }

//   void loadlawyer() {
//     AllLawyer = [
//       LawyerModel(
//         name: 'احمد',
//         type: 'ذكر',
//         specialization: ['جنائية', 'مدني'],
//         contactMethod: 'مكالمه فيديو',
//         sessionPrice: 300,
//         YearsOfExperience: 5,
//       ),
//       LawyerModel(
//         name: 'ساره',
//         type: 'انثى',
//         specialization: ['مالية'],
//         contactMethod: 'مكالمه صوتيه',
//         sessionPrice: 100,
//         YearsOfExperience: 5,
//       ),
//       LawyerModel(
//         name: 'محمد',
//         type: 'ذكر',
//         specialization: ['أحوال شخصية'],
//         contactMethod: 'فى المكتب',
//         sessionPrice: 500,
//         YearsOfExperience: 5,
//       ),
//       LawyerModel(
//         name: 'علي',
//         type: 'ذكر',
//         specialization: ['مدنية', 'جنائية', 'مالية'],
//         contactMethod: 'فى المكتب',
//         sessionPrice: 100,
//         YearsOfExperience: 5,
//       ),
//       LawyerModel(
//         name: 'فاطمه',
//         type: 'انثى',
//         specialization: ['عقارية'],
//         contactMethod: 'مكالمه فيديو',
//         sessionPrice: 200,
//         YearsOfExperience: 5,
//       ),
//     ];

//     emit(SearchLoading(AllLawyer));
//   }

//   void updateFilter({
//     String? newType,
//     String? newSpecialization,
//     String? newContactMethod,
//     String? newNameQuery,
//   }) {
//     if (newType != null) type = newType;
//     if (newSpecialization != null) specialization = newSpecialization;
//     if (newContactMethod != null) contactMethod = newContactMethod;
//     if (newNameQuery != null) nameQuery = newNameQuery;

//     filter();
//   }

//   void filter() {
//     List<LawyerModel> filteredLawyers = AllLawyer.where((lawyer) {
//       final matchesType = type == null || lawyer.type == type;
//       final matchesSpecialization =
//           specialization == null ||
//           lawyer.specialization.contains(specialization!);
//       final matchesContactMethod =
//           contactMethod == null || lawyer.contactMethod == contactMethod;
//       final matchesName = nameQuery == null || lawyer.name.contains(nameQuery!);

//       return matchesType &&
//           matchesSpecialization &&
//           matchesContactMethod &&
//           matchesName;
//     }).toList();

//     emit(SearchLoading(filteredLawyers));
//   }

//   void clearFilters() {
//     type = null;
//     specialization = null;
//     nameQuery = null;
//     contactMethod = null;
//     emit(SearchLoading(AllLawyer));
//   }
// }
