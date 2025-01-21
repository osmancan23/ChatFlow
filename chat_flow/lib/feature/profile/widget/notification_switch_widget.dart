part of "../view/profile_view.dart";
class _NotificationSwitchWidget extends StatelessWidget {
  const _NotificationSwitchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.notifications),
      title: const Text(_ProfileViewStrings.notificationsLabel),
      trailing: Switch(
        value: true,
        onChanged: (value) {},
      ),
    );
  }
}
