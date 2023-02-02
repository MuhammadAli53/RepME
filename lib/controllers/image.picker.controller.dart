import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerController extends GetxController {
  Rx<XFile> image = XFile('').obs;
  RxBool isPicked = false.obs;

  void getImage({required bool isCamera}) async {
    XFile? _file;

    if (isCamera) {
      _file = await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      _file = await ImagePicker().pickImage(source: ImageSource.gallery);
    }

    if (_file != null) {
      image.value = XFile(_file.path);
      isPicked.value = true;
    }
  }
}
