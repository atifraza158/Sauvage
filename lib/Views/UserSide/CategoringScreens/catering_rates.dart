import 'package:dine_in/Views/Utils/Styles/text_styles.dart';
import 'package:dine_in/Views/Utils/Styles/theme.dart';
import 'package:flutter/material.dart';

class CateringScreen extends StatefulWidget {
  const CateringScreen({super.key});

  @override
  State<CateringScreen> createState() => _CateringScreenState();
}

class _CateringScreenState extends State<CateringScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.themeColor,
          title: Text(
            "Catering",
            style: CustomTextStyles.appBarWhiteStyle,
          ),
        ),
        body: DataTable(
          columnSpacing: 30.0,
          columns: <DataColumn>[
            DataColumn(
                label: Text(
              "Dish",
              style: CustomTextStyles.mediumBlackColorStyle2,
            )),
            DataColumn(
                label: Text(
              "Small",
              style: CustomTextStyles.mediumBlackColorStyle2,
            )),
            DataColumn(
                label: Text(
              "Medium",
              style: CustomTextStyles.mediumBlackColorStyle2,
            )),
            DataColumn(
                label: Text(
              "Large",
              style: CustomTextStyles.mediumBlackColorStyle2,
            )),
          ],
          rows: <DataRow>[
            DataRow(cells: [
              DataCell(Text(
                "Chicken Karahi",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$80",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$150",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$220",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
            ]),
            DataRow(cells: [
              DataCell(Text(
                "Butter Chicken",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$70",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$135",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$200",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
            ]),
            DataRow(cells: [
              DataCell(Text(
                "Nahri",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
               DataCell(Text(
                "\$70",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$135",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$200",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
            ]),
            DataRow(cells: [
              DataCell(Text(
                "Lahori Hareesa",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
               DataCell(Text(
                "\$70",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$135",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$200",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
            ]),
            DataRow(cells: [
              DataCell(Text(
                "Paneer Karahi",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$75",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$145",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$215",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
            ]),
            DataRow(cells: [
              DataCell(Text(
                "Palak Paneer",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$55",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$100",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$150",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
            ]),
            DataRow(cells: [
              DataCell(Text(
                "Lahori Chana",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$55",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$100",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$150",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
            ]),
            DataRow(cells: [
              DataCell(Text(
                "Chicken Biryani",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$45",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$90",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$120",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
            ]),
        
             DataRow(cells: [
              DataCell(Text(
                "Veal Palo",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "N/A",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "N/A",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$150",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
            ]),
        
             DataRow(cells: [
              DataCell(Text(
                "Khoya Kheer",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$70",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$120",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
              DataCell(Text(
                "\$180",
                style: CustomTextStyles.smallGreyColorStyle,
              )),
            ]),
          ],
        ));
  }
}
