part of 'rating_cubit.dart';

abstract class RatingState {}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class RatingSuccess extends RatingState {}

class RatingError extends RatingState {
  final String message;
  RatingError(this.message);
}

class ReviewsLoaded extends RatingState {
  final double average;
  final int count;
  final List<RatingModel> reviews;

  ReviewsLoaded({
    required this.average,
    required this.count,
    required this.reviews,
  });
}

class AllLawyersRatingsLoaded extends RatingState {
  final Map<String, LawyerRatingData> lawyerRatings;

  AllLawyersRatingsLoaded(this.lawyerRatings);
}

class LawyerRatingData {
  final double average;
  final int count;

  LawyerRatingData({required this.average, required this.count});
}
