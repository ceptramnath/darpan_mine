import 'package:intl/intl.dart';

class DateTimeDetails {
  var now = DateTime.now();
  var yesterdayDate = DateTime.now().subtract(const Duration(days: 1));
  var Dminus2Date = DateTime.now().subtract(const Duration(days: 2));
  var Dminus7Date = DateTime.now().subtract(const Duration(days: 7));

  currentDateTime() {
    var formatter = new DateFormat('dd-MM-yyyy HH:mm:ss');
    return formatter.format(now);
  }

  oD() {
    var formatter = new DateFormat('yyyyMMdd');

    return formatter.format(now);
  }

  oT() {
    var formatter = new DateFormat('HH:mm:ss');
    return formatter.format(now);
  }

  onlyDate() {
    var formatter = new DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  proposalDate() {
    var formatter = new DateFormat('dd/MM/yyyy');
    return formatter.format(now);
  }

  onlyTime() {
    final String formattedTime = DateFormat.jm().format(now).toString();
    return formattedTime;
  }

  CurrentDateTime() {
    var formatter = new DateFormat.yMMMMd('en-US').add_jms();
    return formatter.format(now);
  }

  selectedDateTime(String date) {
    print("Date Received:" + date);
    // var s=new DateFormat('YYYY-MM-dd').parse(date);
    var temp1 = date.split('/').reversed.join('-');
    print(temp1);
    // var temp=DateFormat('dd-MM-yyyy').parse(temp1);
    // print(temp);
    //
    //
    // var s=DateFormat('yyyy-MM-dd').format(DateFormat('dd-MM-yyyy').parse(temp1));
    //
    // print(s);

    // var t=DateFormat.yMd('en-us').format(DateTime.parse(temp1));
    // // var t=DateFormat.yMMMMd('en-us').format(s);
    // // var t=DateFormat.yMMMMd('en-us').format();
    // print("date changed"+t.toString());
    return temp1;
  }

  headerTime() {
    var formatter = new DateFormat("yyyy-MM-ddTHH:mm:ss").format(now);
    return formatter;
  }

  cbsdatetime() {
    var formatter = new DateFormat("yyyyMMddHHmmss").format(now);
    return formatter;
  }

  cbsdate() {
    var formatter = new DateFormat("yyyyMMdd").format(now);
    return formatter;
  }

  dbdatetime() {
    var formatter = new DateFormat("HH:mm:ss").format(now);
    return formatter;
  }

  filetimeformat() {
    var formatter = new DateFormat("ddMMyyyyHHMMss").format(now);
    return formatter;
  }

  renDateTime() {
    var formatter = new DateFormat('yyyy-MM-ddTHH:mm:ss');
    return formatter.format(now);
  }

  dateCharacter() {
    var formatter = DateFormat('ddMMyyyy');
    return formatter.format(now);
  }

  timeCharacter() {
    var formatter = DateFormat('Hms');
    return formatter.format(now).toString().replaceAll(RegExp(':'), '');
  }


  previousDate() {
    var formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(yesterdayDate);
  }
  Dminus2DateOnly() {
    var formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(Dminus2Date);
  }
  Dminus7DateOnly() {
    var formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(Dminus7Date);
  }

  previousDay() {
    return DateFormat('EEEE').format(yesterdayDate);
  }

  currentDateTimeUSType() {
    var formatter = DateFormat.yMMMMd('en-US').add_jms();
    return formatter.format(now);
  }

  currentDate() {
    var formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(now);
  }

  onlyExpDateTime() {
    var formatter = new DateFormat('dd-MM-yyyy HH:mm:ss');
    return formatter.format(now);
  }

  onlyExpDate() {
    var formatter = new DateFormat('dd-MM-yyyy');
    return formatter.format(now);
  }

  onlyDatewithFormat() {
    var formatter = new DateFormat('dd-MM-yyyy');
    return formatter.format(now);
  }

  cbsRefdatetime() {
    var formatter = new DateFormat("yyMMddHHmmss").format(now);
    return formatter;
  }

  bqdate() {
    var formatter = new DateFormat('MM/dd/yyyy');
    return formatter.format(now);
  }

  servicerequestIndexingDate() {
    var formatter = new DateFormat('dd-MM-yy');
    return formatter.format(now);
  }

  tranUpdateTime() {
    var formatter = new DateFormat('yyyy-MM-ddTHH:mm:ss.SSS');
    return formatter.format(now);
  }
   String FrmIppbConvert(String date){
    // 08-FEB-23 to 08-02-2023
    List<String> a = [];
    a = date.split("-");
    List month = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN","JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
    String converted = "${a[0]}-${(month.indexOf(a[1])+1).toString().length==1 ? "0${month.indexOf(a[1])+1}" : "${month.indexOf(a[1])+1}"}-${a[2].length==2?"20${a[2]}": "${a[2]}"}";
    return converted;
  }
  String ToIppbConvert(String date){
    //  08-02-2023 to 08-FEB-23 to
    List<String> a = [];
    a = date.split("-");
    List month = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN","JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
    String converted = "${a[0]}-${month[int.parse(a[1])+1]}-${a[2].length==4?"${a[2].substring(2)}": "${a[2]}"}";
    return converted;
  }
}
