part of '../view/profile_view.dart';

// ignore: must_be_immutable
class _ProfileAvatarWidget extends StatefulWidget {
  const _ProfileAvatarWidget({required this.onImageSelected, this.imageUrl});
  final void Function(File image) onImageSelected;
  final String? imageUrl;

  @override
  State<_ProfileAvatarWidget> createState() => _ProfileAvatarWidgetState();
}

class _ProfileAvatarWidgetState extends State<_ProfileAvatarWidget> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          child: _image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(80.r),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.fill,
                    height: 120.h,
                    width: 120.w,
                  ),
                )
              : CacheNetworkImageWidget(imageUrl: widget.imageUrl),
        ),
        IconButton(
          onPressed: () async {
            _image = await _choiseImage(context);
            if (_image != null) {
              widget.onImageSelected(_image!);
            }
            setState(() {});
          },
          icon: const Icon(Icons.image),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<File?> _choiseImage(BuildContext context) async {
    String? imagePath;
    bool? isSuccess = false;
    final imagePicker = ImagePicker();
    XFile? xfile;
    try {
      xfile = await imagePicker.pickImage(source: ImageSource.gallery);

      imagePath = xfile?.path;
      isSuccess = true;
      return imagePath != null && isSuccess == true ? File(imagePath) : null;
    } catch (e) {
      return null;
    }
  }
}
