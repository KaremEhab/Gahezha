abstract class HomeToggleState {}

class HomeProfileButtonToggleInitial extends HomeToggleState {}

class HomeProfileButtonToggleSuccess extends HomeToggleState {
  final bool showProfileDetails;
  HomeProfileButtonToggleSuccess(this.showProfileDetails);
}
