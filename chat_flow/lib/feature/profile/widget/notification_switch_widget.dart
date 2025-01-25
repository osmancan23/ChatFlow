part of '../view/profile_view.dart';

class _NotificationSwitchWidget extends StatefulWidget {
  const _NotificationSwitchWidget({
    super.key,
  });

  @override
  State<_NotificationSwitchWidget> createState() => _NotificationSwitchWidgetState();
}

class _NotificationSwitchWidgetState extends State<_NotificationSwitchWidget> {
  late UserBloc _userBloc;
  late StreamSubscription<UserState> _userSubscription;
  bool? _isNotificationEnabled;

  @override
  void initState() {
    _userBloc = UserBloc(locator<UserService>());
    _userBloc.add(FetchCurrentUserProfile());

    _userSubscription = _userBloc.stream.listen((state) {
      if (state is CurrentUserProfileLoaded) {
        _isNotificationEnabled = state.user.notificationsEnabled;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.notifications),
      title: const Text(_ProfileViewStrings.notificationsLabel),
      trailing: Switch(
        value: _isNotificationEnabled ?? false,
        onChanged: (value) {
          setState(() {
            _isNotificationEnabled = value;
          });
          _userBloc.add(UpdateNotificationPreference(isEnabled: value));
        },
      ),
    );
  }
}
