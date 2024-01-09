import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:image_picker/image_picker.dart';
part 'other_provider.g.dart';

@riverpod
class ToggleTheme extends _$ToggleTheme {
  @override
  bool build() {
    return true ;
  }
  void change(){
    state = !state;
  }
}

final loginProvider =
NotifierProvider<LoginProvider, bool>(() => LoginProvider());

class LoginProvider extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  void change() {
    state = !state;
  }
}


final toggleProvider =
NotifierProvider<ToggleProvider, bool>(() => ToggleProvider());

class ToggleProvider extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void change() {
    state = !state;
  }
}



final imageProvider =
NotifierProvider<ImageProvider, XFile?>(() => ImageProvider());

class ImageProvider extends Notifier<XFile?> {
  @override
  XFile? build() {
    return null;
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    state = await picker.pickImage(source: ImageSource.gallery);
  }
}
