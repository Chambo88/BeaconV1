import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env.local");

  final configTemplate = File('config.template.json').readAsStringSync();

  final configContent = configTemplate
      .replaceAll('\${PROJECT_NUMBER}', dotenv.env['PROJECT_NUMBER']!)
      .replaceAll('\${PROJECT_ID}', dotenv.env['PROJECT_ID']!)
      .replaceAll('\${STORAGE_BUCKET}', dotenv.env['STORAGE_BUCKET']!)
      .replaceAll('\${MOBILESDK_APP_ID}', dotenv.env['MOBILESDK_APP_ID']!)
      .replaceAll('\${PACKAGE_NAME}', dotenv.env['PACKAGE_NAME']!)
      .replaceAll('\${CLIENT_ID}', dotenv.env['CLIENT_ID']!)
      .replaceAll('\${API_KEY}', dotenv.env['API_KEY']!);

  File('config.json').writeAsStringSync(configContent);

  print('Config file generated successfully.');
}
