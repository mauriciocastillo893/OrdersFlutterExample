import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<XFile?> getImage() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  return image;
}

Future<bool> sendImage(File image) async {
  final String path = image.path.split('/').last;

  Reference ref = storage.ref().child("users").child(path);
  final UploadTask uploadTask = ref.putFile(image);
  print(uploadTask);

  // Wait for the upload task to complete
  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
  print("snapshot: $snapshot");

  final String url = await snapshot.ref.getDownloadURL();
  print(url);

  print("State: ${snapshot.state}");
  if (snapshot.state == TaskState.success) {
    return true;
  } else {
    return false;
  }
}
