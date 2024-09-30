import 'package:drawingapp/features/shared/colors.dart';
import 'package:flutter/material.dart';

import 'picker_item.dart';
import 'package:google_fonts/google_fonts.dart';

List<String?> allFonts = [
  GoogleFonts.roboto().fontFamily,
  GoogleFonts.lato().fontFamily,
  GoogleFonts.openSans().fontFamily,
  GoogleFonts.montserrat().fontFamily,
  GoogleFonts.poppins().fontFamily,
  GoogleFonts.raleway().fontFamily,
  GoogleFonts.oswald().fontFamily,
  GoogleFonts.inter().fontFamily,
  GoogleFonts.playfair().fontFamily,
  GoogleFonts.merriweather().fontFamily,
  GoogleFonts.notoSans().fontFamily,
  GoogleFonts.alegreya().fontFamily,
  GoogleFonts.nunito().fontFamily,
  GoogleFonts.cormorant().fontFamily,
  GoogleFonts.rubik().fontFamily,
  GoogleFonts.firaSans().fontFamily,
  GoogleFonts.lora().fontFamily,
  GoogleFonts.libreBaskerville().fontFamily,
  GoogleFonts.ptSans().fontFamily,
  GoogleFonts.workSans().fontFamily,
  GoogleFonts.lobster().fontFamily,
].where((element) => (element ?? "").isNotEmpty).toList();
// Map<String, String?> fontsMap = {
//   "roboto": GoogleFonts.roboto().fontFamily,
//   "lato": GoogleFonts.lato().fontFamily,
//   "opensans": GoogleFonts.openSans().fontFamily,
//   "montserrat": GoogleFonts.montserrat().fontFamily,
//   "poppins": GoogleFonts.poppins().fontFamily,
//   "raleway": GoogleFonts.raleway().fontFamily,
//   "oswald": GoogleFonts.oswald().fontFamily,
//   "inter": GoogleFonts.inter().fontFamily,
//   "playfair": GoogleFonts.playfair().fontFamily,
//   "merriweather": GoogleFonts.merriweather().fontFamily,
//   "notsans": GoogleFonts.notoSans().fontFamily,
//   "alegreya": GoogleFonts.alegreya().fontFamily,
//   "nunito": GoogleFonts.nunito().fontFamily,
//   "cormorant": GoogleFonts.cormorant().fontFamily,
//   "rubik": GoogleFonts.rubik().fontFamily,
//   "firasans": GoogleFonts.firaSans().fontFamily,
//   "lora": GoogleFonts.lora().fontFamily,
//   "librebaskerville": GoogleFonts.libreBaskerville().fontFamily,
//   "ptsans": GoogleFonts.ptSans().fontFamily,
//   "worksans": GoogleFonts.workSans().fontFamily,
//   "lobster": GoogleFonts.lobster().fontFamily,
// };

class FontPicker extends StatelessWidget {
  final String? selectedFont;
  final ValueChanged<String> onSelect;
  const FontPicker({super.key, this.selectedFont, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return PickerItem(
        title: "Font",
        itemCount: allFonts.length,
        itemBuilder: (context, index) {
          final font = allFonts[index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () => onSelect(font!),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black54,
                      border: selectedFont != font
                          ? null
                          : Border.all(color: Colors.white, width: 2)),
                  alignment: Alignment.center,
                  child: Text(
                    "Aa",
                    style: TextStyle(
                        color: Colors.white, fontSize: 14, fontFamily: font),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              CircleAvatar(
                backgroundColor:
                    selectedFont == font ? Colors.white : Colors.transparent,
                radius: 2,
              ),
            ],
          );
        });
  }
}
