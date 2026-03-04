part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class OnboardingStepChanged extends OnboardingEvent {
  final int step;

  const OnboardingStepChanged({required this.step});

  @override
  List<Object?> get props => [step];
}

class OnboardingUserTypeSelected extends OnboardingEvent {
  final String userType;

  const OnboardingUserTypeSelected({required this.userType});

  @override
  List<Object?> get props => [userType];
}

class OnboardingCompleted extends OnboardingEvent {
  const OnboardingCompleted();
}

class OnboardingReset extends OnboardingEvent {
  const OnboardingReset();
}