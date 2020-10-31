//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

part of table_calendar;

class _CellWidget extends StatelessWidget {
  final String text;
  final bool isUnavailable;
  final bool isSelected;
  final bool isToday;
  final bool isWeekend;
  final bool isOutsideMonth;
  final bool isHoliday;
  final BoxDecoration selectedDecoration;
  final EdgeInsets cellMargin;
  final CalendarStyle calendarStyle;

  const _CellWidget({
    Key key,
    @required this.text,
    this.isUnavailable = false,
    this.isSelected = false,
    this.isToday = false,
    this.isWeekend = false,
    this.isOutsideMonth = false,
    this.cellMargin = const EdgeInsets.only(left: 8.0,right: 8.0,top: 8.0,bottom: 8.0),
    this.selectedDecoration = const BoxDecoration(shape: BoxShape.rectangle),
    this.isHoliday = false,
    @required this.calendarStyle,
  })  : assert(text != null),
        assert(calendarStyle != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: _buildCellDecoration(),
      margin: cellMargin,
      alignment: Alignment.center,
      child: Text(
        text,
        style: _buildCellTextStyle(),
      ),
    );
  }

  Decoration _buildCellDecoration() {
    if (isSelected) {
      return selectedDecoration ?? BoxDecoration(shape: BoxShape.rectangle,border: Border.all(width: 0.7,color: Colors.black));
    } else if (isToday && calendarStyle.highlightToday) {
      return  BoxDecoration(shape: BoxShape.rectangle);
    } else if (isSelected && calendarStyle.highlightSelected) {
      return  BoxDecoration(shape: BoxShape.rectangle);
    } else {
      return BoxDecoration(shape: BoxShape.rectangle);
    }
  }

  TextStyle _buildCellTextStyle() {
//    if (isUnavailable) {
//      return calendarStyle.unavailableStyle;
//    } else if (isSelected &&
//        calendarStyle.renderSelectedFirst &&
//        calendarStyle.highlightSelected) {
//      return calendarStyle.selectedStyle;
//    } else if (isToday && calendarStyle.highlightToday) {
//      return calendarStyle.todayStyle;
    if (isSelected) {
      return calendarStyle.selectedStyle;}
//    } else if (isOutsideMonth && isHoliday) {
//      return calendarStyle.outsideHolidayStyle;
//    } else if (isHoliday) {
//      return calendarStyle.holidayStyle;
//    } else if (isOutsideMonth && isWeekend) {
//      return calendarStyle.outsideWeekendStyle;
     else if (isOutsideMonth) {
      return calendarStyle.outsideStyle;
    } else if (isWeekend) {
      return calendarStyle.weekendStyle;
    } else {
      return calendarStyle.weekdayStyle;
    }
  }
}
