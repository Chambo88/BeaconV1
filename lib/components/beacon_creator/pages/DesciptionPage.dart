import 'package:flutter/material.dart';

import 'CreatorPage.dart';

typedef void DescriptionCallback(String desc);

class DescriptionPage extends StatefulWidget {
  final VoidCallback onBackClick;
  final VoidCallback onClose;
  final DescriptionCallback onContinue;
  final String continueText;
  final int totalPageCount;
  final int currentPageIndex;

  DescriptionPage(
      {@required this.onBackClick,
      @required this.onClose,
      @required this.onContinue,
      @required this.totalPageCount,
      @required this.currentPageIndex,
      this.continueText = 'Next'});

  @override
  _DescriptionPageState createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CreatorPage(
      title: 'Beacon\ndescription',
      onClose: widget.onClose,
      onBackClick: widget.onBackClick,
      continueText: widget.continueText,
      totalPageCount: widget.totalPageCount,
      currentPageIndex: widget.currentPageIndex,
      onContinuePressed: () {
        widget.onContinue(_descriptionController.text);
      },
      child: Padding(
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
            hintStyle: TextStyle(color: Colors.grey),
            fillColor: Color(0xFF242424),
            filled: true,
          ),
        ),
      ),
    );
  }
}
