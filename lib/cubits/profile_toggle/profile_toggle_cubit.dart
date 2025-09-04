import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/cache_helper.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/profile_toggle/profile_toggle_state.dart';

class ProfileToggleCubit extends Cubit<HomeToggleState> {
  ProfileToggleCubit._privateConstructor()
    : super(HomeProfileButtonToggleInitial());

  static final ProfileToggleCubit _instance =
      ProfileToggleCubit._privateConstructor();

  factory ProfileToggleCubit() => _instance;

  static ProfileToggleCubit get instance => _instance;

  void homeProfileButtonToggle() {
    showProfileDetails = !showProfileDetails;
    emit(HomeProfileButtonToggleSuccess(showProfileDetails));
  }
}
