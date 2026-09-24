import 'dart:async';
import 'dart:convert';
import 'dart:io' as file;
import 'dart:typed_data';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../../../core/config/app_constants.dart';
import '../../../../../core/config/locator.dart';

class ImagePicker {
  /// List locales are already supported by picker
  static List<String> supportDefaultLocales = [
    'zh',
    'en',
    'he',
    'de',
    'ru',
    'ja',
    'ar',
    'fr',
    'vi',
    'tr'
  ];

  static Future<List<AssetEntity>> select(
      BuildContext context, {
        int maxFiles = 1,
        List<AssetEntity>? selectedAssets,
        RequestType requestType = RequestType.common,
      }) async {
    // final isGranted = await checkGrantedPermission();

    final currentLocale =
    Localizations.maybeLocaleOf(context)?.languageCode.toLowerCase();

    final result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: maxFiles,
       // pickerTheme: Theme.of(context),
        specialPickerType: SpecialPickerType.noPreview,
        selectedAssets: selectedAssets,
        requestType: requestType,
        textDelegate: supportDefaultLocales.contains(currentLocale)
            ? null
            : CustomAssetPickerTextDelegate(context: context),
      ),
    );
    return result ?? [];
  }

  static Future<String> formatImage(dynamic image) async {
      var url = await getImagePath(image);
     // var pathWithoutExt = p.withoutExtension(url!);
      var ext = lookupMimeType(url!) ?? "image/jpeg";//p.extension(url!);
      return ext;
  }

  static Future<String> getImageName(dynamic image) async {
    var url = await getImagePath(image);
    String basename = p.basename(url!);
    return basename;
  }

  static Future<PermissionState> checkGrantedPermission() async {
    final permissionState = await PhotoManager.requestPermissionExtend();
    return permissionState;
  }

  static Future<Uint8List?>? getByteData(dynamic image) {
    if (image is AssetEntity) {
      return image.originBytes;
    }
    return null;
  }

  static Widget getThumbnail(dynamic image,
      {double width = 100, double height = 100}) {
    if (image is AssetEntity) {
      return AssetEntityImage(
        image,
        width: width,
        height: height,
      );
    }
    return const SizedBox();
  }

  static bool isAsset(dynamic image) => image is AssetEntity;

  static Future<file.File> writeToFile(Uint8List? data,
      {String? fileName}) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    var filePath = '$tempPath/${fileName ?? 'file_01'}.jpeg';
    var f = file.File(filePath);
    if (data != null) {
      await f.writeAsBytes(data);
    }
    return f;
  }

  static Future<String?> getImagePath(dynamic image) async {
    if (image is AssetEntity && isAndroid) {
      var file = await image.file;
      return file?.path;
    }

    if (image is AssetEntity || image is file.File) {
      final byteData = await image.originBytes;

      if (byteData != null) {
        final tmpFile = await writeToFile(byteData);
        return tmpFile.path;
      }
    }

    if (image is XFile) {
      return image.path;
    }

    if (image is String) {
      if (image.contains('http')) {
        return image;
      }
    }
    return null;
  }

  static Future<String> compressImage(dynamic image) async {
    var base64 = '';
    //const quality = 60;

    /// Disable cause the build issue on Flutter 2.2
    /// https://github.com/OpenFlutter/flutter_image_compress/issues/180

    if (image is AssetEntity && isAndroid) {
      var file = await image.file;
      print(file?.uri);
      if (file?.path != null) {
        final compressedFile = await FlutterNativeImage.compressImage(
          file!.path,
        );
        final bytes = compressedFile.readAsBytesSync();
        return base64Encode(bytes);
      }
    }

    if (image is AssetEntity || image is file.File) {
      Uint8List? byteData;

      if (image is AssetEntity) {
        byteData = await image.originBytes;
      } else if (image is file.File) {
        byteData = await image.readAsBytes();
      }

      if (byteData != null) {
        final tmpFile = await writeToFile(byteData);

        final compressedFile = await FlutterNativeImage.compressImage(
          tmpFile.path,
        );
        final bytes = compressedFile.readAsBytesSync();
        base64 += base64Encode(bytes);
      }
    }

    if (image is XFile) {
      final compressedFile = await FlutterNativeImage.compressImage(
        image.path,
      );
      final bytes = compressedFile.readAsBytesSync();
      base64 += base64Encode(bytes);
    }

    if (image is String) {
      if (image.contains('http')) {
        base64 += image;
      }
    }
    return base64;
  }

  static Future<String> compressAndConvertImagesForUploading(
      List<dynamic> images) async {
    var base64 = StringBuffer();
    for (final image in images) {
      base64
        ..write(await compressImage(image))
        ..write(',');
    }
    return base64.toString();
  }

  static Future<bool> checkImageLive(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      try {
        final contentType = response.headers['content-type'];
        final isImage = contentType != null && contentType.startsWith('image/');

        return isImage && response.bodyBytes.isNotEmpty;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

}

class CustomAssetPickerTextDelegate extends EnglishAssetPickerTextDelegate {
  CustomAssetPickerTextDelegate({required this.context});

  final BuildContext context;

  @override
  String get confirm => AppLocalizations.of(context)!.confirm;

  @override
  String get cancel => AppLocalizations.of(context)!.cancel;

  @override
  String get select => AppLocalizations.of(context)!.select;

  @override
  String get loadFailed => AppLocalizations.of(context)!.loadFail;

  @override
  String get emptyList => AppLocalizations.of(context)!.dataEmpty;

  @override
  String get preview => AppLocalizations.of(context)!.preview;
}