import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color darkBlue = const Color.fromARGB(137, 2, 16, 46);
Color txtBoxbg = Colors.white;
bigGradient() {
  return LinearGradient(
    colors: [
      const Color.fromARGB(255, 1, 17, 21).withOpacity(1),
      const Color.fromARGB(255, 112, 151, 164).withOpacity(0.7),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

txtNormal(
  String txt,
  double fsize,
  Color col,
  FontWeight fw,
  double ls,
) {
  return Text(
    txt,
    style: GoogleFonts.openSans(
      textStyle: TextStyle(
        fontSize: fsize,
        color: col,
        fontWeight: fw,
        letterSpacing: ls,
      ),
    ),
  );
}

buttons(String txt, Color bg, Color txtColor, double wid) {
  return Container(
    height: 65,
    width: wid,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: bg,
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 12,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Center(
      child: txtNormal(
        txt,
        21,
        txtColor,
        FontWeight.bold,
        2,
      ),
    ),
  );
}

txtField(
  TextEditingController cont,
  double wid,
  Icon img,
  String htxt,
  bool obsc,
  TextInputType kbt,

) {
  return Center(
    child: Container(
      width: wid,
      decoration: BoxDecoration(
        color: txtBoxbg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 15,
        ),
        child: TextField(
          controller: cont,
          autocorrect: false,
          textCapitalization: TextCapitalization.none,
          obscureText: obsc,
          decoration: InputDecoration(
            icon: img,
            border: InputBorder.none,
            hintText: htxt,
            hintStyle: GoogleFonts.openSans(
              textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black26,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
