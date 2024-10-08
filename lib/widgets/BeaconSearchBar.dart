import 'package:beacon/util/theme.dart';
import 'package:flutter/material.dart';

class BeaconSearchBar extends StatelessWidget {
  final FigmaColours? figmaColours = FigmaColours();
  final TextEditingController? controller;
  final String? hintText;
  final Function(String)? onChanged;
  final double? width;
  final bool? autofocus;

  BeaconSearchBar({
    @required this.controller,
    @required this.onChanged,
    @required this.width,
    this.hintText,
    this.autofocus = false,
  });

  TextField searchBar() {
    return TextField(
      autofocus: autofocus!,
      textAlignVertical: TextAlignVertical.center,
      autocorrect: false,
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          color: Color(figmaColours!.greyLight),
        ),
        isCollapsed: true,
        hintText: hintText ?? "",
        hintStyle: TextStyle(
          color: Color(figmaColours!.greyLight),
          fontSize: 18.0,
        ),
        fillColor: Color(figmaColours!.greyDark),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white.withOpacity(0)),
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: UnderlineInputBorder(
          // borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.clear,
            color: Color(figmaColours!.highlight),
          ),
          onPressed: () {
            onChanged!('');
            controller!.clear();
          },
        ),
      ),
      onChanged: (value) {
        onChanged!(value);
        if (value == '') {
          controller!.clear();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 60,
      child: Padding(padding: const EdgeInsets.all(8.0), child: searchBar()),
    );
  }
}
