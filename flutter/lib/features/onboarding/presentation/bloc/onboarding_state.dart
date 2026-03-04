part of 'onboarding_bloc.dart';

class OnboardingState extends Equatable {
  final int currentStep;
  final String? selectedUserType;
  final bool isCompleted;

  const OnboardingState({
    this.currentStep = 0,
    this.selectedUserType,
    this.isCompleted = false,
  });

  OnboardingState copyWith({
    int? currentStep,
    String? selectedUserType,
    bool? isCompleted,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      selectedUserType: selectedUserType ?? this.selectedUserType,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [currentStep, selectedUserType, isCompleted];
}