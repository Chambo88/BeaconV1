import 'package:beacon/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SearchBar extends StatelessWidget {

  FigmaColours figmaColours = FigmaColours();
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;

  SearchBar({
    @required this.controller,
    @required this.onChanged,
    this.hintText,

  });

  TextField searchBar() {
    return TextField(
      autofocus: true,
      textAlignVertical: TextAlignVertical.center,
      autocorrect: false,
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.search,
          color: Color(figmaColours.greyLight),
        ),
        isCollapsed: true,
        hintText: hintText ?? "",
        hintStyle: TextStyle(
          color: Color(figmaColours.greyLight),
          fontSize: 18.0,
        ),
        fillColor: Color(figmaColours.greyMedium),
        filled: true,

        focusedBorder: OutlineInputBorder(
          // borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),

        enabledBorder: UnderlineInputBorder(
          // borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
        ),


        suffixIcon: IconButton(
          icon: Icon(Icons.clear,
            color: Color(figmaColours.highlight),
          ),
          onPressed: () {
            onChanged('');
            controller.clear();
          },
        ),


      ),

      onChanged: (value) {
        onChanged(value);
      },

    );
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: searchBar()

        ),
      ),
    );
  }
}
