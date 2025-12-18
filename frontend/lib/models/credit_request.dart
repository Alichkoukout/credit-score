class CreditRequest {
  final int id;
  final String requestNumber;
  final double amountRequested;
  final String? purpose;
  final String? employmentStatus;
  final double? monthlyIncome;
  final int? employmentDurationMonths;
  final double? currentDebt;
  final int? creditHistoryMonths;
  final int? age;
  final String? maritalStatus;
  final int? dependents;
  final bool? propertyOwned;
  final String? educationLevel;
  final double? aiScore;
  final double? aiConfidence;
  final double? finalScore;
  final String status;
  final int? agentId;
  final DateTime? validatedAt;
  final String? rejectionReason;
  final DateTime? createdAt;
  final UserInfo? user;

  CreditRequest({
    required this.id,
    required this.requestNumber,
    required this.amountRequested,
    this.purpose,
    this.employmentStatus,
    this.monthlyIncome,
    this.employmentDurationMonths,
    this.currentDebt,
    this.creditHistoryMonths,
    this.age,
    this.maritalStatus,
    this.dependents,
    this.propertyOwned,
    this.educationLevel,
    this.aiScore,
    this.aiConfidence,
    this.finalScore,
    required this.status,
    this.agentId,
    this.validatedAt,
    this.rejectionReason,
    this.createdAt,
    this.user,
  });

  factory CreditRequest.fromJson(Map<String, dynamic> json) {
    return CreditRequest(
      id: json['id'],
      requestNumber: json['requestNumber'],
      amountRequested: (json['amountRequested'] as num).toDouble(),
      purpose: json['purpose'],
      employmentStatus: json['employmentStatus'],
      monthlyIncome: json['monthlyIncome'] != null ? (json['monthlyIncome'] as num).toDouble() : null,
      employmentDurationMonths: json['employmentDurationMonths'],
      currentDebt: json['currentDebt'] != null ? (json['currentDebt'] as num).toDouble() : null,
      creditHistoryMonths: json['creditHistoryMonths'],
      age: json['age'],
      maritalStatus: json['maritalStatus'],
      dependents: json['dependents'],
      propertyOwned: json['propertyOwned'],
      educationLevel: json['educationLevel'],
      aiScore: json['aiScore'] != null ? (json['aiScore'] as num).toDouble() : null,
      aiConfidence: json['aiConfidence'] != null ? (json['aiConfidence'] as num).toDouble() : null,
      finalScore: json['finalScore'] != null ? (json['finalScore'] as num).toDouble() : null,
      status: json['status'],
      agentId: json['agentId'],
      validatedAt: json['validatedAt'] != null ? DateTime.parse(json['validatedAt']) : null,
      rejectionReason: json['rejectionReason'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      user: json['user'] != null ? UserInfo.fromJson(json['user']) : null,
    );
  }

  bool get isPending => status == 'PENDING';
  bool get isTreated => status == 'TREATED';
  bool get isApproved => status == 'APPROVED';
  bool get isRejected => status == 'REJECTED';
}

class UserInfo {
  final int id;
  final String? email;
  final String? firstName;
  final String? lastName;

  UserInfo({
    required this.id,
    this.email,
    this.firstName,
    this.lastName,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}

