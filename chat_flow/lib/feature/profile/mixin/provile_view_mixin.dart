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
    _userBloc = UserBloc(locator<UserService>());
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

  void _listenBloc(UserState state, BuildContext context) {
    log('UserBloc state: $state');
    if (state is UserProfileUpdated) {
      _userBloc.add(FetchCurrentUserProfile());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil güncellendi.'),
        ),
      );
    } else if (state is UserProfileUpdateError) {
      _userBloc.add(FetchCurrentUserProfile());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
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

  // Settings
  static const String notificationsLabel = 'Bildirimler';
}
