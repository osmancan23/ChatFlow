part of '../view/profile_view.dart';

mixin _ProfileViewMixin on State<_ProfileBodyWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  File? _image;
  late UserBloc _userBloc;
  late StreamSubscription<UserState> _userSubscription;
  @override
  void initState() {
    _userBloc = UserBloc(UserService(firestore: FirebaseFirestore.instance));
    _userBloc.add(FetchCurrentUserProfile());
    super.initState();

    _userSubscription = _userBloc.stream.listen((state) {
      if (state is CurrentUserProfileLoaded) {
        _nameController.text = state.user.fullName;
        _bioController.text = state.user.bio ?? '';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _userSubscription.cancel();
    super.dispose();
  }
}

class _ProfileViewStrings {
  const _ProfileViewStrings._();

  // AppBar
  static const String title = 'Profil';

  // Form
  static const String nameLabel = 'Ad Soyad';
  static const String bioLabel = 'Hakkımda';
  static const String updateButtonText = 'Profili Güncelle';
  static const String bioMaxLengthError = 'Hakkımda en fazla 200 karakter olmalıdır';

  // Settings
  static const String notificationsLabel = 'Bildirimler';
}
