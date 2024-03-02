import 'package:flutter/material.dart';
import '../../utility/color.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const MyInputField({Key? key, required this.title, required this.hint, this.controller, this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,

          ),
          Container(
            height: 52,
            margin: const EdgeInsets.only(top:8.0),
            padding: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: widget==null?false:true,
                    autofocus: false,
                    cursorColor: Colors.grey,
                    controller: controller,
                    style: subTitleStyle,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitleStyle,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 0,
                        )
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 0,
                          )
                      ),
                    ),
                  ),
                ),
                widget==null?Container():Container(child: widget,),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
