class ProfileState {
  final bool isHidden;
  final String? pinCode;

  const ProfileState({
    this.isHidden = false,
    this.pinCode,
  });

  ProfileState copyWith({bool? isHidden, String? pinCode}) {
    return ProfileState(
      isHidden: isHidden ?? this.isHidden,
      pinCode: pinCode ?? this.pinCode,
    );
  }
}
