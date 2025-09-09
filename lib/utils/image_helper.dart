import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<String?> pickAndSaveImage() async {
  final picker = ImagePicker();
  final XFile? picked = await picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 1024,
    maxHeight: 1024,
  );
  if (picked == null) return null;

  // Lire les bytes de l'image
  final bytes = await picked.readAsBytes();

  // Récupérer le dossier local de l'application
  final dir = await getApplicationDocumentsDirectory();
  final imagesDir = Directory('${dir.path}/student_images');
  if (!await imagesDir.exists()) {
    await imagesDir.create(recursive: true);
  }

  // Générer un nom de fichier unique avec timestamp
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final extension = picked.path.split('.').last;
  final fileName = 'student_$timestamp.$extension';
  final file = File('${imagesDir.path}/$fileName');

  // Sauvegarder l'image
  await file.writeAsBytes(bytes);

  return file.path;
}