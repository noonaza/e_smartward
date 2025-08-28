// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:e_smartward/Model/data_note_model.dart';
import 'package:e_smartward/Model/doctor_model.dart';
import 'package:e_smartward/Model/list_user_model.dart';
import 'package:e_smartward/Model/note_detail_model.dart';
import 'package:e_smartward/api/%E0%B8%B5upload_file_api.dart';
import 'package:e_smartward/api/admit_api.dart';
import 'package:e_smartward/api/note_api.dart';
import 'package:e_smartward/util/tlconstant.dart';
import 'package:e_smartward/widget/checkbox_widget.dart';
import 'package:e_smartward/widget/text.dart';
import 'package:e_smartward/widget/textfield.dart';

import '../Model/create_trans_detail_model.dart';
import '../Model/create_transection_model.dart';
import '../Model/list_pet_model.dart';

// ignore: must_be_immutable
class CardNoteWidget extends StatefulWidget {
  final String foodName;
  final String method;
  final String time;
  final String amountStatus;
  final List<ListUserModel> lUserLogin;
  final Map<String, String> headers;
  final bool isDone;
  final bool isChecked;
  final DataNoteModel dataNote;
  final NoteDetailModel note;
  final ValueChanged<bool?>? onCheckboxChanged;
  final VoidCallback? onToggle;
  final String typeCard;
  final VoidCallback? onRemove;
  final List<ListPetModel> lPetAdmit;
  final bool isDisabled;
  final VoidCallback? onRefresh;
  final String? drugTypeName;
  final ListPetModel petAdmit;
  final String visit;
  Function cb;

  CardNoteWidget({
    Key? key,
    required this.foodName,
    required this.method,
    required this.time,
    required this.amountStatus,
    required this.lUserLogin,
    required this.headers,
    required this.isDone,
    required this.isChecked,
    required this.dataNote,
    required this.note,
    this.onCheckboxChanged,
    this.onToggle,
    required this.typeCard,
    this.onRemove,
    required this.lPetAdmit,
    required this.isDisabled,
    this.onRefresh,
    this.drugTypeName,
    required this.petAdmit,
    required this.visit,
    required this.cb,
  }) : super(key: key);

  @override
  State<CardNoteWidget> createState() => _CardNoteWidgetState();
}

class _CardNoteWidgetState extends State<CardNoteWidget> {
  TextEditingController txtRemarkImages = TextEditingController();
  TextEditingController txtRemarkObs = TextEditingController();

  List<FileModel> mFile = [];
  List<ListPetModel> get lPetAdmit => widget.lPetAdmit;

  final savedStatuses = ['Complete', 'success', 'out', 'pass'];

  bool _isSaved = false;

  bool get isSaved => localDataNote.smw_transaction_order_id != null;
  bool get noOrderId => localDataNote.smw_transaction_order_id == null;
  bool isDoctorLoading = true;
  List<FileModel>? file;
  DoctorModel? selectedDoctor;
  late DataNoteModel localDataNote;
  List<DoctorModel> ListDoctors = [];
  String imgLastName = '';
  bool isLoading = false;
  late TextEditingController txtComment;
  List<DropdownMenuItem<DoctorModel>> drugItems = [];
  TextEditingController tSearchDoctor = TextEditingController();
  String normalizeFileName(String name) {
    final withoutExtension = name.replaceAll(RegExp(r'\(\d+\)'), '').trim();
    final extension = name.split('.').last;
    final baseName = withoutExtension.replaceAll(RegExp(r'\s+'), ' ').trim();
    return '$baseName.$extension'.toLowerCase();
  }

  Color getCardColor() {
    if (widget.isDisabled) {
      return Colors.grey.shade300;
    }

    switch (widget.typeCard) {
      case 'Drug':
        if ((widget.dataNote.drug_type_name ?? '').trim() == '[I]ยาฉีด') {
          return Color.fromARGB(255, 187, 238, 208);
        }
        if (widget.dataNote.time_slot?.trim() == 'ตามอาการ') {
          return const Color.fromARGB(255, 243, 171, 130);
        }
        return const Color.fromARGB(255, 194, 236, 255);
      case 'Food':
        return const Color(0xFFEEE0A9);
      default:
        return Colors.pink.shade100;
    }
  }

  Map<String, bool> mapCheckBoxValues = {
    'อาหารหมด': false,
    'งดอาหาร': false,
    'ให้แล้ว': false,
    'ยาหมด': false,
    'งดยา': false,
  };

  String getStatusFromCheckbox(String checkbox) {
    switch (checkbox) {
      case 'อาหารหมด':
      case 'ยาหมด':
        return 'out';
      case 'งดอาหาร':
      case 'งดยา':
        return 'pass';
      case 'ให้แล้ว':
        return 'success';
      default:
        return '';
    }
  }

  String selectedCheckbox = '';
  List<FileModel> localFiles = [];

  Color ColorSlot() {
    switch (widget.typeCard) {
      case 'Drug':
        if ((widget.dataNote.drug_type_name ?? '').trim() == '[I]ยาฉีด') {
          return Color.fromARGB(255, 56, 189, 112);
        }
        if (widget.dataNote.time_slot?.trim() == 'ตามอาการ') {
          return Color.fromARGB(255, 197, 109, 59);
        }
        return const Color.fromARGB(255, 120, 196, 231);
      case 'Food':
        return const Color.fromARGB(255, 185, 168, 100);
      default:
        return const Color.fromARGB(255, 219, 133, 163);
    }
  }

  @override
  void initState() {
    super.initState();

    _isSaved = widget.dataNote.smw_transaction_order_id != null;
    localDataNote = widget.dataNote;
    txtComment = TextEditingController(text: widget.dataNote.comment ?? '');
    localFiles = widget.dataNote.file ?? [];
    switch (widget.dataNote.status) {
      case 'success':
        selectedCheckbox = 'ให้แล้ว';
        break;
      case 'out':
        selectedCheckbox = widget.typeCard == 'Food' ? 'อาหารหมด' : 'ยาหมด';
        break;
      case 'pass':
        selectedCheckbox = widget.typeCard == 'Food' ? 'งดอาหาร' : 'งดยา';
        break;
      default:
        selectedCheckbox = '';
    }
  }

  void initDoctors() async {
    final result =
        await AdmitApi().loadDataDoctor(context, headers_: widget.headers);
    setState(() {
      ListDoctors = result;
      isDoctorLoading = false;
    });
  }

  Future<void> loadFiles() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    final files = await NoteApi().loadFile(
      context,
      orderId: widget.dataNote.smw_transaction_order_id ?? 0,
      headers_: widget.headers,
    );

    if (!mounted) return;
    setState(() {
   
      localFiles.removeWhere(
          (f) => files.any((apiFile) => apiFile.path_file == f.path));

      localFiles.addAll(
        files.map((f) => FileModel(
              path: f.path_file ?? '',
              remark: f.remark ?? '',
            )),
      );

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.note.id != null;
    final bool noOrderId = (widget.dataNote.smw_transaction_order_id == null ||
        widget.dataNote.smw_transaction_order_id == 0);
    return SizedBox(
        width: double.infinity,
        child: Stack(children: [
          Card(
              color: getCardColor(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(4),
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: text(
                              context,
                              '${widget.typeCard == 'Drug' ? 'ยา' : widget.typeCard == 'Food' ? 'อาหาร' : 'คำสั่งพิเสษ'} : ${widget.dataNote.item_name}',
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (widget.typeCard == 'Food')
                            Visibility(
                              visible: (widget.note.id == null ||
                                      widget.note.id == 0) &&
                                  widget.dataNote.pre_pare_status != 'ready',
                              child: Image.asset(
                                'assets/images/oh.png',
                                width: 35,
                                height: 35,
                              ),
                            ),
                          if (widget.typeCard == 'Drug' &&
                              widget.dataNote.time_slot?.trim() == 'ตามอาการ')
                            IconButton(
                              onPressed: isDisabled ? null : widget.onRemove,
                              icon: const Icon(Icons.cancel),
                              color: const Color.fromARGB(255, 182, 88, 16),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (widget.typeCard == 'Food' ||
                          widget.typeCard == 'Drug')
                        text(
                          context,
                          'วิธีให้ : ${widget.dataNote.dose_qty} ${widget.dataNote.unit_name}',
                        ),
                      if (widget.typeCard == 'Observe')
                        text(
                          context,
                          'หมายเหตุ : ${widget.dataNote.remark}',
                        ),
                      const SizedBox(height: 8),
                      if (widget.typeCard == 'Food')
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            text(context, 'วิธีเตรียม / หมายเหตุอื่นๆ : '),
                            text(
                              context,
                              '${widget.dataNote.remark}',
                            ),
                          ],
                        ),
                      const SizedBox(height: 8),
                      widget.dataNote.slot != null &&
                              widget.dataNote.slot!.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: ColorSlot(),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: text(
                                context,
                                '${widget.dataNote.slot}',
                              ),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 12),
                      (widget.typeCard == 'Food' || widget.typeCard == 'Drug')
                          ? FoodDrugCheckboxGroup(
                              typeCard: widget.typeCard,
                              selectedValue: selectedCheckbox,
                              isDisabled: isDisabled || _isSaved,
                              prePareStatus:
                                  widget.dataNote.pre_pare_status ?? '',
                              onChanged: (newValue) {
                                if (isDisabled || _isSaved) return;

                                setState(() {
                                  selectedCheckbox = newValue;
                                  widget.dataNote.status =
                                      getStatusFromCheckbox(newValue);

                                  if (newValue == 'ให้แล้ว') {
                                    widget.dataNote.pre_pare_status = 'ready';
                                  }
                                });
                              },
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 15),
                      if ((widget.dataNote.drug_type_name ?? '').trim() ==
                          '[I]ยาฉีด')
                        _isSaved &&
                                (widget.dataNote.doctor?.isNotEmpty ?? false)
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundImage: const AssetImage(
                                          'assets/images/doctor.png'),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    const SizedBox(width: 8),
                                    text(
                                      context,
                                      'แพทย์ที่ทำการรักษา: ${widget.dataNote.doctor}',
                                      color: Colors.teal[900],
                                    ),
                                  ],
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isDoctorLoading = true;
                                  });

                                  final result =
                                      await AdmitApi().loadDataDoctor(
                                    context,
                                    headers_: widget.headers,
                                  );

                                  setState(() {
                                    ListDoctors = result;
                                    isDoctorLoading = false;
                                  });

                                  if (ListDoctors.isEmpty) {
                                    return;
                                  }

                                  final doctor = await showDoctorDialog(
                                    context: context,
                                    doctorList: ListDoctors,
                                  );

                                  if (doctor != null) {
                                    setState(() {
                                      selectedDoctor = doctor;
                                      widget.dataNote.doctor =
                                          '${doctor.prename} ${doctor.full_nameth}';
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.person_search,
                                          color: Colors.teal, size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: text(
                                          context,
                                          selectedDoctor != null
                                              ? '${selectedDoctor!.prename} ${selectedDoctor!.full_nameth}'
                                              : 'คลิกเพื่อเลือกชื่อแพทย์ที่ทำการสั่งยา',
                                          color: Colors.teal[900],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                      const SizedBox(height: 12),
                      widget.typeCard == 'Observe' &&
                              widget.dataNote.smw_transaction_order_id == null
                          ? IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: isDisabled ? Colors.grey : null,
                              ),
                              onPressed: isDisabled
                                  ? null
                                  : () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return UploadImageDialog(
                                              card: widget.dataNote,
                                              headers: widget.headers,
                                              onUpdateMain: () {
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                loadFiles().then((_) {
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                });
                                              },
                                              onFileUploaded: (newFile) {
                                                setState(() {
                                                  final newFileName = newFile
                                                      .path
                                                      .split('/')
                                                      .last;

                                                  final alreadyExists =
                                                      localFiles.any((f) =>
                                                          f.path
                                                                  .split('/')
                                                                  .last
                                                                  .toLowerCase() ==
                                                              newFileName &&
                                                          f.remark.trim() ==
                                                              newFile.remark
                                                                  .trim());

                                                  if (!alreadyExists) {
                                                    localFiles.add(newFile);
                                                  }
                                                });
                                              });
                                        },
                                      );
                                    },
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 8),
                      if (widget.typeCard == 'Observe' &&
                          widget.dataNote.smw_transaction_order_id == null)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('รูป :',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: isLoading
                                  ? const Text(
                                      'กำลังโหลด...',
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  : localFiles
                                          .where((file) =>
                                              file.remark.trim().isNotEmpty)
                                          .isEmpty
                                      ? const Text(
                                          'ยังไม่ได้เลือกรูปภาพ',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: localFiles
                                              .where((file) =>
                                                  file.remark.trim().isNotEmpty)
                                              .map((file) {
                                            final fileName =
                                                file.path.split('/').last;
                                            final isPDF = fileName
                                                .toLowerCase()
                                                .endsWith('.pdf');

                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  text(
                                                                    context,
                                                                    'ชื่อรูปภาพ : ${fileName.isNotEmpty ? fileName : "-"}',
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        150,
                                                                        60,
                                                                        91),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          5),
                                                                  text(
                                                                    context,
                                                                    'หมายเหตุ : ${file.remark.trim().isNotEmpty ? file.remark : "-"}',
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        150,
                                                                        60,
                                                                        91),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            IconButton(
                                                              icon: const Icon(
                                                                  Icons.close),
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                            ),
                                                          ],
                                                        ),
                                                        content: isPDF
                                                            ? const Icon(
                                                                Icons
                                                                    .picture_as_pdf,
                                                                size: 100,
                                                                color:
                                                                    Colors.red,
                                                              )
                                                            : Image.network(
                                                                file.path),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Wrap(
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .center,
                                                        spacing: 4,
                                                        runSpacing: 4,
                                                        children: [
                                                          Icon(
                                                            isPDF
                                                                ? Icons
                                                                    .picture_as_pdf
                                                                : Icons.image,
                                                            size: 16,
                                                            color: isPDF
                                                                ? Colors.red
                                                                : const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    150,
                                                                    60,
                                                                    91),
                                                          ),
                                                          text(
                                                            context,
                                                            color: const Color
                                                                .fromARGB(255,
                                                                150, 60, 91),
                                                            fileName,
                                                          ),
                                                          IconButton(
                                                            onPressed:
                                                                isDisabled
                                                                    ? null
                                                                    : () async {
                                                                        if (file
                                                                            .path
                                                                            .isNotEmpty) {
                                                                          await delete(
                                                                            FilePath:
                                                                                file.path,
                                                                            headers:
                                                                                widget.headers,
                                                                          );
                                                                          setState(
                                                                              () {
                                                                            localFiles.remove(file);
                                                                          });
                                                                        }
                                                                      },
                                                            icon: const Icon(
                                                                Icons.cancel),
                                                            color: const Color
                                                                .fromARGB(255,
                                                                150, 60, 91),
                                                            constraints:
                                                                const BoxConstraints(),
                                                            padding:
                                                                EdgeInsets.zero,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 5),
                      //>> popup
                      if (widget.typeCard == 'Observe' &&
                          widget.dataNote.file_count != 0 &&
                          widget.dataNote.smw_transaction_order_id != null) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () async {
                                  setState(() => isLoading = true);
                                  await loadFiles();
                                  setState(() => isLoading = false);

                                  // if (localFiles.isEmpty) {
                                  //   return;
                                  // }

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      final width =
                                          MediaQuery.of(context).size.width;
                                      final crossAxisCount = width >= 1100
                                          ? 4
                                          : width >= 800
                                              ? 3
                                              : 2;

                                      return AlertDialog(
                                        content: SizedBox(
                                          width: double.maxFinite,
                                          child: GridView.builder(
                                            shrinkWrap: true,
                                            itemCount: localFiles.length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: crossAxisCount,
                                              crossAxisSpacing: 12,
                                              mainAxisSpacing: 12,
                                              childAspectRatio: 1,
                                            ),
                                            itemBuilder: (context, index) {
                                              final file = localFiles[index];
                                              final fileName =
                                                  file.path.split('/').last;
                                              final isPDF = fileName
                                                  .toLowerCase()
                                                  .endsWith('.pdf');

                                              return GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: Text(fileName),
                                                      content: isPDF
                                                          ? const Icon(
                                                              Icons
                                                                  .picture_as_pdf,
                                                              size: 100,
                                                              color: Colors.red,
                                                            )
                                                          : Image.network(
                                                              file.path,
                                                              headers: widget
                                                                  .headers,
                                                            ),
                                                    ),
                                                  );
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Stack(
                                                    children: [
                                                      Positioned.fill(
                                                          child: isPDF
                                                              ? Container(
                                                                  color: const Color(
                                                                      0xFFF7F7F7),
                                                                  child:
                                                                      const Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .picture_as_pdf,
                                                                      size: 56,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Image.network(
                                                                  file.path,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  headers: widget
                                                                      .headers, // <- ใส่ headers
                                                                  errorBuilder: (_,
                                                                          __,
                                                                          ___) =>
                                                                      Container(
                                                                    color: const Color(
                                                                        0xFFF7F7F7),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: const Icon(
                                                                        Icons
                                                                            .broken_image,
                                                                        size:
                                                                            40),
                                                                  ),
                                                                )),
                                                      Positioned(
                                                        left: 0,
                                                        right: 0,
                                                        bottom: 0,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 6,
                                                                  vertical: 4),
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient:
                                                                LinearGradient(
                                                              begin: Alignment
                                                                  .bottomCenter,
                                                              end: Alignment
                                                                  .topCenter,
                                                              colors: [
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.6),
                                                                Colors
                                                                    .transparent,
                                                              ],
                                                            ),
                                                          ),
                                                          child: Text(
                                                            file.remark
                                                                    .isNotEmpty
                                                                ? file.remark
                                                                : "-",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/pic1.png',
                                      width: 25,
                                      height: 25,
                                    ),
                                    text(
                                      context,
                                      'กดดูรูปภาพ',
                                      color: const Color.fromARGB(
                                          255, 13, 81, 116),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ],

                      const SizedBox(height: 5),
                      SizedBox(
                        child: widget.dataNote.smw_transaction_order_id == null
                            ? textFieldNote(
                                context,
                                'หมายเหตุ : ',
                                controller: txtComment,
                                color: Colors.black,
                                readOnly: isDisabled,
                                onChanged: (val) {
                                  widget.dataNote.comment = val;
                                  widget.cb(widget.dataNote.comment);
                                },
                              )
                            : widget.dataNote.smw_transaction_order_id != null
                                ? SizedBox(
                                    child: Text(
                                        'หมายเหตุ : ${widget.dataNote.comment}'),
                                  )
                                : null,
                      ),
                      const SizedBox(height: 4),
                      if (widget.note.date_slot != null)
                        Align(
                          alignment: Alignment.centerRight,
                          child: text(
                            context,
                            '${widget.dataNote.date_slot}',
                          ),
                        ),

                      const SizedBox(height: 5),
                      if ((widget.dataNote.save_by_name ?? '').isNotEmpty &&
                          _isSaved)
                        Align(
                          alignment: Alignment.centerRight,
                          child: text(
                            context,
                            'ผู้บันทึก : ${widget.dataNote.save_by_name}',
                          ),
                        ),
                      const SizedBox(height: 4),
                      if (widget.note.date_slot != null)
                        Align(
                          alignment: Alignment.centerRight,
                          child: text(
                            context,
                            'วัน/เวลา ที่บันทึก : ${widget.dataNote.create_date}',
                          ),
                        ),
                      // if ((widget.dataNote.drug_type_name ?? '').trim() ==
                      //         '[I]ยาฉีด' &&
                      //     (widget.dataNote.doctor?.isNotEmpty ?? false))
                      //   Text(
                      //     'แพทย์สั่งยา: ${widget.dataNote.doctor}',
                      //     style: const TextStyle(fontSize: 13),
                      //   ),
                      const SizedBox(height: 5),
                      if (!_isSaved && noOrderId)
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: isLoading ||
                                    ((widget.dataNote.drug_type_name ?? '')
                                                .trim() ==
                                            '[I]ยาฉีด' &&
                                        selectedDoctor == null)
                                ? null
                                : () async {
                                    setState(() => isLoading = true);
                                    final mPetAdmit =
                                        widget.lPetAdmit.firstWhere(
                                      (pet) =>
                                          pet.id == widget.note.smw_admit_id,
                                      orElse: () => widget.lPetAdmit.first,
                                    );

                                    final isChecked =
                                        (widget.dataNote.status ?? '')
                                            .trim()
                                            .isNotEmpty;

                                    if (widget.dataNote.type_card !=
                                            'Observe' &&
                                        !isChecked) {
                                      setState(() => isLoading = false);
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.warning,
                                        animType: AnimType.scale,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        desc: 'กรุณาติ๊ก checkbox ก่อนกดบันทึก',
                                        btnOkOnPress: () {},
                                      ).show();
                                      return;
                                    }
                                    //XXXXXXXX

                                    final mNoteDataDetail =
                                        CreateTransDetailModel(
                                      smw_admit_id:
                                          widget.note.smw_admit_id ?? 0,
                                      slot: widget.note.slot ?? '',
                                      date_slot: widget.note.date_slot ??
                                          DateFormat('yyyy-MM-dd')
                                              .format(DateTime.now()),
                                      tl_common_users_id:
                                          widget.lUserLogin.first.id ?? 0,
                                      dataNote: [
                                        DataTransectionModel(
                                          smw_transaction_order_id: widget
                                              .dataNote
                                              .smw_transaction_order_id,
                                          smw_admit_order_id: widget.dataNote
                                                  .smw_admit_order_id ??
                                              0,
                                          type_card:
                                              widget.dataNote.type_card ?? '',
                                          item_name:
                                              widget.dataNote.item_name ?? '',
                                          item_qty:
                                              widget.dataNote.item_qty ?? 0,
                                          unit_name:
                                              widget.dataNote.unit_name ?? '',
                                          dose_qty:
                                              widget.dataNote.dose_qty ?? '',
                                          meel_status:
                                              widget.dataNote.meal_timing ?? '',
                                          drug_instruction: widget
                                                  .dataNote.drug_instruction ??
                                              '',
                                          remark: widget.dataNote.remark ?? '',
                                          item_code:
                                              widget.dataNote.item_code ?? '',
                                          note_to_team:
                                              widget.dataNote.note_to_team ??
                                                  '',
                                          caution: widget.dataNote.caution,
                                          drug_description: widget
                                                  .dataNote.drug_description ??
                                              '',
                                          time_slot:
                                              widget.dataNote.time_slot ?? '',
                                          pre_pare_status:
                                              widget.dataNote.pre_pare_status ??
                                                  '',
                                          date_slot:
                                              widget.dataNote.date_slot ?? '',
                                          slot: widget.dataNote.slot ?? '',
                                          status: widget.dataNote.type_card ==
                                                  'Observe'
                                              ? 'Complete'
                                              : (widget.dataNote.status ?? ''),
                                          doctor: selectedDoctor != null
                                              ? '${selectedDoctor!.prename} ${selectedDoctor!.full_nameth}'
                                              : null,
                                          comment: widget.dataNote.comment,
                                          file: widget.dataNote.file ?? [],
                                        )
                                      ],
                                      // remark: widget.dataNote.remark ?? '',
                                    );

                                    await NoteApi().CreateTransectionDetail(
                                      context,
                                      headers_: widget.headers,
                                      mNoteDataDetail: mNoteDataDetail,
                                      mPetAdmit_: mPetAdmit,
                                      mUser: widget.lUserLogin.first,
                                    );

                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.success,
                                      animType: AnimType.scale,
                                      title: 'บันทึกสำเร็จ',
                                      desc: 'ข้อมูลถูกบันทึกเรียบร้อยแล้ว',
                                      dismissOnTouchOutside: false,
                                      btnOkOnPress: () async {
                                        // isLoading = true;
                                        // setState(() {});
                                        final updatedNotes =
                                            await NoteApi().loadNoteDetail(
                                          context,
                                          visitId: widget.visit,
                                          headers_: widget.headers,
                                          date_time: '',
                                        );

                                        final updatedNote =
                                            updatedNotes.firstWhere(
                                          (e) =>
                                              e.slot == widget.note.slot &&
                                              e.smw_admit_id ==
                                                  widget.note.smw_admit_id,
                                          // orElse: () => widget.note,
                                        );

                                        final updatedItem =
                                            updatedNote.dataNote.firstWhere(
                                          (e) =>
                                              e.item_code ==
                                                  widget.dataNote.item_code &&
                                              e.type_card ==
                                                  widget.dataNote.type_card &&
                                              e.doctor ==
                                                  widget.dataNote.doctor &&
                                              e.time_slot ==
                                                  widget.dataNote.time_slot,
                                          orElse: () => widget.dataNote,
                                        );

                                        final files = await NoteApi().loadFile(
                                          context,
                                          orderId: updatedItem
                                                  .smw_transaction_order_id ??
                                              0,
                                          headers_: widget.headers,
                                        );
                                        updatedItem.file = files
                                            .map((f) => FileModel(
                                                  path: f.path_file ?? '',
                                                  remark: f.remark ?? '',
                                                ))
                                            .toList();

                                        setState(() {
                                          localDataNote = updatedItem;
                                          _isSaved = true;
                                          isLoading = false;
                                          widget.dataNote.status =
                                              updatedItem.status;
                                          widget.dataNote.doctor =
                                              updatedItem.doctor;
                                          widget.dataNote.save_by_name =
                                              updatedItem.save_by_name;
                                          widget.dataNote
                                                  .smw_transaction_order_id =
                                              updatedItem
                                                  .smw_transaction_order_id;
                                          widget.dataNote.file =
                                              updatedItem.file;
                                          widget.onRefresh?.call();
                                        });
                                      },
                                    ).show();
                                  },
                            icon: isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                  )
                                : const Icon(Icons.save_alt, size: 18),
                            label: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 3.0, vertical: 8.0),
                              child: Text(
                                isLoading ? 'กำลังบันทึก...' : 'บันทึก',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.green,
                              elevation: 1,
                              side: const BorderSide(
                                  color: Colors.green, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 1),
                            ),
                          ),
                        ),
                      if (_isSaved)
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            '✔ บันทึกแล้ว',
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                    ],
                  ))),
          // if (!isDisabled && !isSaved && widget.typeCard == 'Observe')
          //   Positioned(
          //     top: 8,
          //     right: 8,
          //     child: IconButton(
          //       icon: const Icon(Icons.cancel, color: Colors.red),
          //       tooltip: 'ลบรายการนี้',
          //       onPressed: widget.onRemove,
          //     ),
          //   ),
        ]));
  }

  Future<void> delete({
    required String FilePath,
    required Map<String, String> headers,
  }) async {
    final formData = FormData.fromMap({
      "path_file": FilePath,
    });

    const String api = '${TlConstant.syncApi}/deleteFile';
    final dio = Dio();

    try {
      final response = await dio.post(
        api,
        data: formData,
        options: Options(
          headers: headers,
          followRedirects: false,
          validateStatus: (status) => true,
        ),
      );

      final code = response.data['code'];

      if (code == 1) {
        // print('Delete Success for: $FilePath');
      } else if (code == 401) {
        // print('Unauthorized access while deleting: $FilePath');
      } else {
        // print('Error deleting file: $FilePath\nMessage: $message');
      }
    } catch (e) {}
  }

  Future<DoctorModel?> showDoctorDialog({
    required BuildContext context,
    required List<DoctorModel> doctorList,
  }) async {
    TextEditingController searchController = TextEditingController();
    List<DoctorModel> filteredList = List.from(doctorList);

    return await showDialog<DoctorModel>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: text(context, 'เลือกแพทย์ผู้รักษา',
                color: Colors.teal[900], fontSize: 16),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: 'ค้นหาชื่อหรือรหัสแพทย์',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (query) {
                      final search = query.toLowerCase();
                      setState(() {
                        filteredList = doctorList.where((doctor) {
                          final name =
                              '${doctor.prename ?? ''} ${doctor.full_nameth ?? ''}'
                                  .toLowerCase();
                          final code = (doctor.key_search ?? '').toLowerCase();
                          return name.contains(search) || code.contains(search);
                        }).toList();
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final doctor = filteredList[index];
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.asset(
                              'assets/images/doctor.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: text(
                              context,
                              color: Colors.teal,
                              '${doctor.prename ?? ''} ${doctor.full_nameth ?? ''}'),
                          subtitle: text(
                              context,
                              color: Colors.teal,
                              'รหัส: ${doctor.key_search ?? '-'}'),
                          onTap: () {
                            Navigator.pop(context, doctor);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    text(context, color: Colors.teal, 'ยกเลิก', fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }
}
