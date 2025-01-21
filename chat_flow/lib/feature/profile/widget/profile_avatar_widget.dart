
part of "../view/profile_view.dart";
class _ProfileAvatarWidget extends StatelessWidget {
  const _ProfileAvatarWidget();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        const CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(
            'https://via.placeholder.com/120',
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.camera_alt),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
