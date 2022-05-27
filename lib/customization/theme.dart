import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarter/customization/hex_color.dart';

var smallPadding = 8.00.r;
var mediumPadding = 16.00.r;
var largePadding = 32.00.r;

//light theme colors
var primaryColor = HexColor('f3e5f5');
var primaryLightColor = HexColor('ffffff');
var primaryDarkColor = HexColor('c0b3c2');
var primaryTextColor = HexColor('000000');

//dark theme colors
var primaryColorDark = HexColor('212121');
var primaryLightColorDark = HexColor('a4a4a4');
var primaryDarkColorDark = HexColor('000000');
var primaryTextColorDark = HexColor('ffffff');

class MyTheme {
  static var lightTheme = ThemeData(
    scaffoldBackgroundColor: primaryLightColor,
    primarySwatch: generateMaterialColorFromColor(primaryDarkColor),
    appBarTheme: AppBarTheme(
//change  color of any icon in appbar
      iconTheme: IconThemeData(color: primaryTextColor),
      color: primaryColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: primaryTextColor,
        fontSize: 32,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: primaryDarkColor,
      ),
    ),
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      headline1: TextStyle(
          color: primaryTextColor, fontSize: 32, fontWeight: FontWeight.w300),
      subtitle1: TextStyle(color: primaryTextColor, fontSize: 18),
    ),
  );

  static var darkTheme = ThemeData(
    scaffoldBackgroundColor: primaryLightColorDark,
    primarySwatch: generateMaterialColorFromColor(primaryDarkColorDark),
    appBarTheme: AppBarTheme(
//change  color of any icon in appbar
      iconTheme: IconThemeData(color: primaryTextColorDark),
      color: primaryColorDark,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: primaryTextColorDark,
        fontSize: 32,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: primaryDarkColorDark,
      ),
    ),
    textTheme: GoogleFonts.latoTextTheme()
        .copyWith(
          headline1: TextStyle(
              color: primaryColorDark,
              fontSize: 32,
              fontWeight: FontWeight.w300),
          subtitle1: TextStyle(color: primaryColorDark, fontSize: 18),
        )
        .apply(
          bodyColor: primaryColorDark,
        ),
    drawerTheme: DrawerThemeData(
      backgroundColor: primaryLightColorDark,
    ),
    iconTheme: IconThemeData(color: primaryColorDark),
  );

  static MaterialColor generateMaterialColorFromColor(Color color) {
    return MaterialColor(color.value, {
      50: Color.fromRGBO(color.red, color.green, color.blue, 0.1),
      100: Color.fromRGBO(color.red, color.green, color.blue, 0.2),
      200: Color.fromRGBO(color.red, color.green, color.blue, 0.3),
      300: Color.fromRGBO(color.red, color.green, color.blue, 0.4),
      400: Color.fromRGBO(color.red, color.green, color.blue, 0.5),
      500: Color.fromRGBO(color.red, color.green, color.blue, 0.6),
      600: Color.fromRGBO(color.red, color.green, color.blue, 0.7),
      700: Color.fromRGBO(color.red, color.green, color.blue, 0.8),
      800: Color.fromRGBO(color.red, color.green, color.blue, 0.9),
      900: Color.fromRGBO(color.red, color.green, color.blue, 1.0),
    });
  }
}
