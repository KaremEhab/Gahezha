part of 'signup_cubit.dart';

abstract class SignupState {}

class SignupInitialState extends SignupState {}

class SignupLoadingState extends SignupState {}

class SignupSuccessState extends SignupState {
  final String uId;

  SignupSuccessState(this.uId);
}

class SignupErrorState extends SignupState {
  final String error;

  SignupErrorState({required this.error});
}

class SignupCreateUserLoadingState extends SignupState {}

class SignupCreateUserSuccessState extends SignupState {}

class SignupCreateUserErrorState extends SignupState {
  final String error;

  SignupCreateUserErrorState(this.error);
}

class SignupPhoneLoadingState extends SignupState {}

class SignupPhoneSuccessState extends SignupState {}

class SignupPhoneErrorState extends SignupState {
  final String error;

  SignupPhoneErrorState(this.error);
}

class SignupSendOtpSuccessState extends SignupState {
  final String verificationId;

  SignupSendOtpSuccessState(this.verificationId);
}

class SignupVerifyPhoneLoadingState extends SignupState {}

class SignupVerifyPhoneSuccessState extends SignupState {}

class SignupVerifyPhoneErrorState extends SignupState {
  final String error;

  SignupVerifyPhoneErrorState(this.error);
}

class SignUpWithGoogleLoadingState extends SignupState {}

class SignUpWithGoogleSuccessState extends SignupState {}

class SignUpWithGoogleErrorState extends SignupState {
  final String error;

  SignUpWithGoogleErrorState({required this.error});
}

class SignUpWithFacebookLoadingState extends SignupState {}

class SignUpWithFacebookSuccessState extends SignupState {}

class SignUpWithFacebookErrorState extends SignupState {
  final String error;

  SignUpWithFacebookErrorState({required this.error});
}

class SignUpWithAppleLoadingState extends SignupState {}

class SignUpWithAppleSuccessState extends SignupState {}

class SignUpWithAppleErrorState extends SignupState {
  final String error;

  SignUpWithAppleErrorState({required this.error});
}
