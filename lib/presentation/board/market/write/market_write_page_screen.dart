import 'dart:io';

import 'package:dongsoop/core/presentation/components/custom_action_sheet.dart';
import 'package:dongsoop/core/presentation/components/detail_header.dart';
import 'package:dongsoop/core/presentation/components/primary_bottom_button.dart';
import 'package:dongsoop/presentation/board/common/components/board_require_label.dart';
import 'package:dongsoop/ui/color_styles.dart';
import 'package:dongsoop/ui/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class MarketWritePageScreen extends StatefulWidget {
  const MarketWritePageScreen({super.key});

  @override
  State<MarketWritePageScreen> createState() => _MarketWritePageScreenState();
}

class _MarketWritePageScreenState extends State<MarketWritePageScreen> {
  final List<String> types = ['판매', '구매'];
  int? selectedIndex;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final priceController = TextEditingController();
  bool isFormValid = false;

  // 숫자 포맷 함수
  String formatWithCommas(String input) {
    final numeric = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (numeric.isEmpty) return '';

    final buffer = StringBuffer();
    for (int i = 0; i < numeric.length; i++) {
      buffer.write(numeric[numeric.length - 1 - i]);
      if ((i + 1) % 3 == 0 && i + 1 != numeric.length) {
        buffer.write(',');
      }
    }
    return buffer.toString().split('').reversed.join();
  }

  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  void _updateFormValidState() {
    final hasType = selectedIndex != null;
    final hasTitle = titleController.text.trim().isNotEmpty;
    final hasContent = contentController.text.trim().isNotEmpty;
    final hasPrice = priceController.text.trim().isNotEmpty;

    setState(() {
      isFormValid = hasType && hasTitle && hasContent && hasPrice;
    });
  }

  Future<void> _pickImage() async {
    if (_images.length >= 4) return;
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _images.add(picked);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _showDeleteImageActionSheet(int index) async {
    customActionSheet(
      context,
      onDelete: () => _removeImage(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorStyles.white,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: DetailHeader(title: '장터 등록'),
        ),
        bottomNavigationBar: PrimaryBottomButton(
          label: '등록하기',
          isEnabled: isFormValid,
          onPressed: () {
            // 등록 로직 추후에 추가
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RequiredLabel('글 유형'),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    children: List.generate(types.length, (index) {
                      final isSelected = selectedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                          _updateFormValidState();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: isSelected
                                  ? ColorStyles.primary100
                                  : ColorStyles.gray2,
                            ),
                          ),
                          child: Text(
                            types[index],
                            style: TextStyles.normalTextRegular.copyWith(
                              color: isSelected
                                  ? ColorStyles.primary100
                                  : ColorStyles.gray4,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),
                  RequiredLabel('제목'),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: titleController,
                    onChanged: (_) => _updateFormValidState(),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      hintText: '글 제목을 입력해 주세요',
                      hintStyle: TextStyles.normalTextRegular
                          .copyWith(color: ColorStyles.gray3),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.gray2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.primary100),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  RequiredLabel('내용'),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: contentController,
                    onChanged: (_) => _updateFormValidState(),
                    maxLines: 6,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      hintText: '세부 내용을 입력해 주세요',
                      hintStyle: TextStyles.normalTextRegular
                          .copyWith(color: ColorStyles.gray3),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.gray2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.primary100),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  RequiredLabel('가격'),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // 숫자만 입력
                    ],
                    onChanged: (value) {
                      final formatted = formatWithCommas(value);
                      priceController.value = TextEditingValue(
                        text: formatted,
                        selection:
                            TextSelection.collapsed(offset: formatted.length),
                      );
                      _updateFormValidState();
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      hintText: '희망 가격을 입력해 주세요',
                      hintStyle: TextStyles.normalTextRegular.copyWith(
                        color: ColorStyles.gray3,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.gray2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorStyles.primary100),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RequiredLabel('사진'),
                      const SizedBox(width: 8),
                      Text(
                        '최대 4개까지 첨부 가능해요',
                        style: TextStyles.smallTextRegular
                            .copyWith(color: ColorStyles.gray4),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    children: [
                      ...List.generate(_images.length, (index) {
                        return GestureDetector(
                          onTap: () => _showDeleteImageActionSheet(index),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_images[index].path),
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      }),
                      if (_images.length < 4)
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              border: Border.all(color: ColorStyles.gray2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.camera_alt,
                                size: 24.0,
                                color: ColorStyles.gray4,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
