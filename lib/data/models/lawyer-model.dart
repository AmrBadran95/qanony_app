class LawyerModel {
  final String name;
  final String type;
  final List<String> specialization;
  final String contactMethod;
  final int YearsOfExperience;
  final double? sessionPrice;

  LawyerModel({
    required this.name,
    required this.type,
    required this.specialization,
    required this.contactMethod,
    required this.YearsOfExperience,
    required this.sessionPrice,
  });
}
