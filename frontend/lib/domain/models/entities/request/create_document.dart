import 'package:camera/camera.dart';
import 'package:frontend/domain/models/abstract/serializable_entity.dart';



class CreateDocument extends SerializableEntity {
  late XFile image;

  CreateDocument({required this.image});

  @override
  Map<String, dynamic> toMap() {
    return {
      'image': image,
    };
  }

  @override
  String toString() {
    return 'CreateDocument{image: $image}';
  }
}
