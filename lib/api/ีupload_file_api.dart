// UploadImageDialog.dart
import 'dart:convert';
import 'package:e_smartward/Model/create_transection_model.dart';
import 'package:e_smartward/Model/data_note_model.dart';
import 'package:e_smartward/util/tlconstant.dart';
import 'package:e_smartward/widget/text.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';

class UploadImageDialog extends StatefulWidget {
  final DataNoteModel card;
  final Map<String, String> headers;
  final VoidCallback onUpdateMain;
  final void Function(FileModel) onFileUploaded;

  const UploadImageDialog({
    super.key,
    required this.card,
    required this.headers,
    required this.onUpdateMain,
    required this.onFileUploaded,
  });

  @override
  State<UploadImageDialog> createState() => _UploadImageDialogState();
}

class _UploadImageDialogState extends State<UploadImageDialog> {
  PlatformFile? file;
  String? base64string;
  String fileName = '';
  String imgLastName = '';
  bool isRemarkValid = false;
  final TextEditingController txtRemarkImages = TextEditingController();
  bool isUploading = false;

  @override
  void initState() {
    super.initState();
    txtRemarkImages.addListener(() {
      final remark = txtRemarkImages.text.trim();
      if (mounted) {
        setState(() {
          isRemarkValid = remark.isNotEmpty;
        });
      }
    });
    pickFile();
  }

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
        allowMultiple: false,
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        Navigator.pop(context);
        return;
      }

      file = result.files.first;
      fileName = file!.name;
      imgLastName = fileName.split('.').last;

      if (file!.bytes != null) {
        base64string = base64.encode(file!.bytes!);
      }
      widget.onFileUploaded(FileModel(
        path: fileName,
        remark: '',
      ));

      final fileSizeMB = file!.size / (1024 * 1024);
      if (imgLastName.toLowerCase() == 'pdf' && fileSizeMB > 8) {
        Future.delayed(Duration.zero, () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("ขนาดไฟล์เกิน"),
              content: const Text("ไฟล์ PDF ที่เลือกมีขนาดเกิน 8MB"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("ตกลง"),
                )
              ],
            ),
          ).then((_) => Navigator.pop(context));
        });
      }

      setState(() {});
    } catch (e) {
    //  print("Error picking file: $e");
      Navigator.pop(context);
    }
  }

  Future<void> createImage() async {
    if (isUploading || file == null || base64string == null) return;

    setState(() {
      isUploading = true;
    });

    final dio = Dio();
    final orderId = widget.card.smw_transaction_order_id;

    try {
      final response = await dio.post(
        '${TlConstant.syncApi}/storeBase64File',
        data: FormData.fromMap({
          "filename": fileName,
          "file": base64string,
          "ref_id": orderId,
        }),
        options: Options(headers: widget.headers),
      );

      final path = response.data['body'];
      if (response.data['code'] == 1 && path != null && path is String) {
        final newFile = FileModel(
          path: path,
          remark: txtRemarkImages.text.trim().isNotEmpty
              ? txtRemarkImages.text.trim()
              : '-',
        );

        widget.card.file ??= [];
        widget.card.file?.removeWhere(
            (f) => f.path == fileName || f.path.split('/').last == fileName);

        widget.card.file!.add(newFile);

        widget.onFileUploaded(newFile);

        txtRemarkImages.clear();
        Navigator.pop(context);
        widget.onUpdateMain();
      } else {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("เกิดข้อผิดพลาด"),
            content: Text("Upload ไม่สำเร็จ: ${response.data['message']}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("ตกลง"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
    //  print("Upload error: $e");
    } finally {
      if (mounted) {
        setState(() {
          isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (file == null || base64string == null) return const SizedBox();

    return AlertDialog(
      title: text(context, 'ชื่อไฟล์ : $fileName'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          imgLastName.toLowerCase() == 'pdf'
              ? const Icon(Icons.picture_as_pdf, size: 100, color: Colors.red)
              : Image.memory(
                  file!.bytes!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
          TextFormField(
            controller: txtRemarkImages,
            decoration: const InputDecoration(hintText: 'หมายเหตุ'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: (!isRemarkValid || isUploading) ? null : createImage,
          style: TextButton.styleFrom(
            backgroundColor: (!isRemarkValid || isUploading)
                ? Colors.grey[300]
                : Colors.teal,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isUploading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : text(context, "Upload", color: Colors.white),
        ),
      ],
    );
  }
}
