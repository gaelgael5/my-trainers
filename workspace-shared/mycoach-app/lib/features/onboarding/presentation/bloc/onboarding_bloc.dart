import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

@injectable
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState()) {
    on<OnboardingStepChanged>(_onOnboardingStepChanged);
    on<OnboardingUserTypeSelected>(_onOnboardingUserTypeSelected);
    on<OnboardingCompleted>(_onOnboardingCompleted);
    on<OnboardingReset>(_onOnboardingReset);
  }

  void _onOnboardingStepChanged(
    OnboardingStepChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(currentStep: event.step));
  }

  void _onOnboardingUserTypeSelected(
    OnboardingUserTypeSelected event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(selectedUserType: event.userType));
  }

  void _onOnboardingCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(isCompleted: true));
  }

  void _onOnboardingReset(
    OnboardingReset event,
    Emitter<OnboardingState> emit,
  ) {
    emit(const OnboardingState());
  }
}