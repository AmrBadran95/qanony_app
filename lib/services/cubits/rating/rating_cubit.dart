import 'package:bloc/bloc.dart';
import 'package:qanony/data/models/rating_model.dart';
import 'package:qanony/services/firestore/rating_firestore_service.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  final RatingFirestoreService ratingService;

  RatingCubit(this.ratingService) : super(RatingInitial());

  Future<void> submitRating({
    required String userId,
    required String lawyerId,
    required double rating,
    String? comment,
  }) async {
    emit(RatingLoading());

    try {
      await ratingService.addOrUpdateRating(
        userId: userId,
        lawyerId: lawyerId,
        rating: rating,
        comment: comment,
      );
      emit(RatingSuccess());
    } catch (e) {
      emit(RatingError(e.toString()));
    }
  }

  Future<void> loadLawyerReviews(String lawyerId) async {
    emit(RatingLoading());

    try {
      final reviews = await ratingService.getAllRatingsForLawyer(lawyerId);

      double totalRating = 0;
      for (var review in reviews) {
        totalRating += review.rating;
      }

      final average = reviews.isEmpty ? 0.0 : totalRating / reviews.length;
      final count = reviews.length;

      emit(ReviewsLoaded(average: average, count: count, reviews: reviews));
    } catch (e) {
      emit(RatingError(e.toString()));
    }
  }
}
