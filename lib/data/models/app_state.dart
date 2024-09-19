class ProfileState {
  final bool isHidden;
  final String? pinCode;

  const ProfileState({
    this.isHidden = false,
    this.pinCode,
  });

  ProfileState copyWith({bool? isHidden, String? pinCode}) {
    return ProfileState(
      isHidden: isHidden ??
          this.isHidden, // ?? nghĩa là , nếu giá trị null, sẽ giữ giá trị ban đầu.
      pinCode: pinCode ?? this.pinCode,
    );
  }
}
