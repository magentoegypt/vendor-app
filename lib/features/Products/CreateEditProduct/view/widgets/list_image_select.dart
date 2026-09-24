import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:multi_vendor/common/flux_image.dart';
import 'package:multi_vendor/core/config/locator.dart';
import 'ImagePicker.dart';



class ListImageSelect extends StatefulWidget {
  final List? images;
  final String? label;
  final Function(List? images) onSelect;
  final Function(String? image) onDeleteImage;
  const ListImageSelect({super.key, this.images, this.label, required this.onSelect,required this.onDeleteImage});

  @override
  State<ListImageSelect> createState() => _ListImageSelectState();
}

class _ListImageSelectState extends State<ListImageSelect> {
  var _images;
  List<File?>? _tmpFiles;

  Future<void> _addImage() async {
    print("object");
    try {
      final images = await ImagePicker.select(
        context,
        maxFiles: 5,
        requestType: RequestType.image,
      );

      await Future.forEach(images, (img) async {
        final tmpFile = await _getFile(img);
        _tmpFiles!.insert(0, tmpFile);
        _images.insert(0, img);
      });

      widget.onSelect(_images);
      setState(() {});
    } catch (_) {}
  }

  Future<File> _getFile(AssetEntity image) async {
    final byte = await image.originBytes;
    var fileName = 'file_${DateTime.now().microsecondsSinceEpoch}';
    return await ImagePicker.writeToFile(byte, fileName: fileName);
  }

  void _deleteImage({int? index, bool clearAll = false}) {
    if (clearAll) {
      _images.clear();
      _tmpFiles!.clear();
    } else {
      if(_images[index!] is String){
        widget.onDeleteImage(_images[index]);
      }
      _images.removeAt(index);
      _tmpFiles!.removeAt(index);
    }
    widget.onSelect(_images);
    setState(() {});
  }

  Widget _buildImage({int? index, bool isAdd = false}) {
    if (isAdd) {
      return InkWell(
        onTap: _addImage,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: const Center(
              child: Icon(Icons.camera_alt_outlined),
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: _images[index] is String
                  ? FluxImage(imageUrl: _images[index], fit: BoxFit.cover)
                  : Image.file(
                      _tmpFiles![index!]!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.red,
            ),
            onPressed: () {
              if(_images[index] is String){
                showAlertDialog(context,index);
              }else {
                _deleteImage(index: index);
              }
            },
          ),
        )
      ],
    );
  }

  Widget _buildImages() {
    return SizedBox(
      height: 100,
      child: Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildImage(isAdd: true),
              ...List.generate(
                  _images.length, (index) => _buildImage(index: index))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _images = List.from(widget.images ?? []);
    _tmpFiles = List.generate(_images.length, (index) => null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0,top: 10),
          child: Text(
            widget.label ?? AppLocalizations.of(context)!.gallery,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: _buildImages(),
        ),
      ],
    );
  }

  Future<bool> showAlertDialog(BuildContext context,int? index) async {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("No"),
      onPressed: () {
        // returnValue = false;
        Navigator.of(context).pop(false);
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Yes"),
      onPressed: () {
        // returnValue = true;
        Navigator.of(context).pop(true);
        _deleteImage(index: index);
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert!"),
      content: Text("Do you want to Delete this image?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog
    final result = await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    return result ?? false;
  }
}
