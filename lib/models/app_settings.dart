class AppSettings {
  const AppSettings({
    this.onboardingCompleted = false,
    this.userName = '',
    this.monthlyBudget,
    this.themeId = 'ninja_dark',
    this.customPrimaryColor,
    this.customSecondaryColor,
    this.customBackgroundColor,
    this.customCardColor,
    this.displayCurrency = 'BRL',
  });

  final bool onboardingCompleted;
  final String userName;
  final double? monthlyBudget;
  final String themeId;
  final int? customPrimaryColor;
  final int? customSecondaryColor;
  final int? customBackgroundColor;
  final int? customCardColor;
  final String displayCurrency;

  AppSettings copyWith({
    bool? onboardingCompleted,
    String? userName,
    double? monthlyBudget,
    bool clearMonthlyBudget = false,
    String? themeId,
    int? customPrimaryColor,
    int? customSecondaryColor,
    int? customBackgroundColor,
    int? customCardColor,
    String? displayCurrency,
  }) {
    return AppSettings(
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      userName: userName ?? this.userName,
      monthlyBudget: clearMonthlyBudget ? null : monthlyBudget ?? this.monthlyBudget,
      themeId: themeId ?? this.themeId,
      customPrimaryColor: customPrimaryColor ?? this.customPrimaryColor,
      customSecondaryColor: customSecondaryColor ?? this.customSecondaryColor,
      customBackgroundColor: customBackgroundColor ?? this.customBackgroundColor,
      customCardColor: customCardColor ?? this.customCardColor,
      displayCurrency: displayCurrency ?? this.displayCurrency,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'onboardingCompleted': onboardingCompleted,
      'userName': userName,
      'monthlyBudget': monthlyBudget,
      'themeId': themeId,
      'customPrimaryColor': customPrimaryColor,
      'customSecondaryColor': customSecondaryColor,
      'customBackgroundColor': customBackgroundColor,
      'customCardColor': customCardColor,
      'displayCurrency': displayCurrency,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      onboardingCompleted: map['onboardingCompleted'] as bool? ?? false,
      userName: map['userName'] as String? ?? '',
      monthlyBudget: (map['monthlyBudget'] as num?)?.toDouble(),
      themeId: map['themeId'] as String? ?? 'ninja_dark',
      customPrimaryColor: map['customPrimaryColor'] as int?,
      customSecondaryColor: map['customSecondaryColor'] as int?,
      customBackgroundColor: map['customBackgroundColor'] as int?,
      customCardColor: map['customCardColor'] as int?,
      displayCurrency: map['displayCurrency'] as String? ?? 'BRL',
    );
  }
}
