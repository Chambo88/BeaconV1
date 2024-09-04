import 'package:flutter/material.dart';

import 'CreatorPage.dart';

typedef void DescriptionCallback(String title, String desc);

class DescriptionPage extends StatefulWidget {
  final VoidCallback? onBackClick;
  final VoidCallback? onClose;
  final DescriptionCallback? onContinue;
  final String? continueText;
  final int? totalPageCount;
  final int? currentPageIndex;
  final bool? hasTitleField;
  final String? initTitle;
  final String? initDesc;

  DescriptionPage({
    @required this.onBackClick,
    @required this.onClose,
    @required this.onContinue,
    @required this.totalPageCount,
    @required this.currentPageIndex,
    this.hasTitleField = false,
    this.initTitle = '',
    this.initDesc = '',
    this.continueText = 'Next',
  });

  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  bool _nextEnabled = true;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.initTitle!;
    _descriptionController.text = widget.initDesc!;
    _setNextEnabled();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  _setNextEnabled() {
    setState(() {
      _nextEnabled = !widget.hasTitleField! || _titleController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CreatorPage(
      title: 'Beacon Description',
      onClose: widget.onClose,
      onBackClick: widget.onBackClick,
      continueText: widget.continueText,
      totalPageCount: widget.totalPageCount,
      currentPageIndex: widget.currentPageIndex,
      onContinuePressed: _nextEnabled
          ? () => widget.onContinue!(
              _titleController.text, _descriptionController.text)
          : null,
      child: Column(
        children: [
          if (widget.hasTitleField!)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: TextField(
                controller: _titleController,
                keyboardType: TextInputType.multiline,
                onChanged: (s) => _setNextEnabled(),
                style: TextStyle(
                  color: Colors.white,
                ),
                maxLines: 1,
                maxLength: 30,
                decoration: InputDecoration(
                  enabledBorder: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(8.0),
                  hintText: 'Enter a title',
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Color(0xFF242424),
                  filled: true,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: TextField(
              controller: _descriptionController,
              keyboardType: TextInputType.multiline,
              style: TextStyle(
                color: Colors.white,
              ),
              maxLines: 10,
              maxLength: 180,
              decoration: InputDecoration(
                enabledBorder: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                focusedBorder: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                hintText: 'Come study with me!',
                contentPadding: const EdgeInsets.all(8.0),
                hintStyle: TextStyle(color: Colors.grey),
                fillColor: Color(0xFF242424),
                filled: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
