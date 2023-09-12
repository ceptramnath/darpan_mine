
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:intl/intl.dart';

class PdfGeneration {
  String generatedPdfFilePath = "";

  Future<String> generateExampleDocument(
      String receipttype,
      //based on type the same will be shown as header in the report
      List<String> basicinformation, //basic information shown in the report
      List<String> accountnumbers,
      List<String> type,
      List<String> status,
      List<String> amount,
      String defaultAmount,
      String rebateAmount,
      String totalDeposit,
      String totalWithdraw,
      String ArtNumber) async {
    print("inside pdf dart file..!");

    var htmlContent = "";
    var tableContent1 = "";
    var tableContent2 = "";
    final htmlHeader = """<!DOCTYPE html>
    <html>
      <head>
       <style>
 th, td {
  
  padding: 5px;
}
.center {
  margin-left: auto;
  margin-right: auto;
}

hr.new2 {
  border-top: 1px dashed red;
}

</style>
      </head>
      <body>
		 
		<h1><img src="https://2.bp.blogspot.com/-3a7iMhpW5T8/Vg84-GHzZ4I/AAAAAAAAIU8/ZmLvzCQnwIw/s1600/India%2BPost%2BLOGO.jpg" alt="web-img"width="100" height="50"> INDIA POST
        </h1>""";

    if (receipttype == "Regd. Letter" ||
        receipttype == "eMO" ||
        receipttype == "Speed Letter" ||
        receipttype == "PARCEL") {
      for (int i = 0; i < basicinformation.length; i++) {
        print("value of list at " +
            i.toString() +
            " is - " +
            basicinformation[i]);
        tableContent1 = tableContent1 +
            """<tr><td>""" +
            basicinformation[i] +
            """</td></tr>""";
      }
      htmlContent = htmlHeader +
          """<h3>""" +
          receipttype +
          """</h3><hr class="new2"  style="width:20%;text-align:left;margin-left:0">
                    <table>""" +
          tableContent1 +
          """<tr><td style="border-top:1px solid black;" colspan="5"></td></tr>
                    </table></body></html>""";
      print("HTML Content is - " + htmlContent);
    }
    if (receipttype == "Daily Report") {
      for (int i = 0; i < basicinformation.length; i++) {
        tableContent1 = """<tr><td>""" + basicinformation[i] + """</td></tr>""";
      }

      for (int i = 0; i < accountnumbers.length; i++) {
        tableContent2 = """<tr><td>""" +
            (i + 1).toString() +
            """</td><td>""" +
            accountnumbers[i] +
            """</td><td>""" +
            type[i] +
            """</td><td>""" +
            status[i] +
            """</td><td>""" +
            amount[i] +
            """</td></tr>""";
      }

      htmlContent = htmlHeader +
          """<h3>""" +
          receipttype +
          """</h3><table>
        <tr><td style="border-top:1px solid black;" colspan="3"></td></tr>""" +
          tableContent1 +
          """</table><hr class="new2"  style="width:20%;text-align:left;margin-left:0">
          <table><tr><th>S No</th><th>A/C No</th><th>Type</th><th>Status</th><th>Amount</th></tr>
          <tr><td style="border-top:1px solid black;" colspan="5"></td></tr>""" +
          tableContent2 +
          """<tr><td style="border-top:1px solid black;" colspan="5"></td></tr>
          </table>
       <p style="text-align:left">Defualt fee Total &nbsp;  -   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Rs.""" +
          defaultAmount +
          """</p>
       <p style="text-align:left">Rebate fee Total &nbsp;&nbsp;  -   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Rs. """ +
          rebateAmount +
          """</p>
       <p style="text-align:left">Summary </p>
       <p style="text-align:left">Total Cash Deposited &nbsp;  -   &nbsp;&nbsp;&nbsp;&nbsp;Rs. """ +
          totalDeposit +
          """</p>
       <p style="text-align:left">In words Six Thousand Two Hundred Only &nbsp;</p>
       <p style="text-align:left">Total Cash Withdrawn &nbsp;  -   &nbsp;&nbsp;&nbsp;&nbsp;Rs.""" +
          totalWithdraw +
          """</p>
       <p style="text-align:left">In words One Hundred rupees only &nbsp;</p>
      </body>
    </html>
    """;
    }
    final f = new DateFormat('ddMMyyyyhhmmss');
    String date = f.format(new DateTime.now());
    print(date);
    final targetPath = "storage/emulated/0/Darpan_Mine/Reports";
    final targetFileName = ArtNumber + "_" + date;
    // final targetFileName = receipttype.trim()+ "_PDF";

    final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        htmlContent, targetPath, targetFileName);
    generatedPdfFilePath = generatedPdfFile.path;
    print(generatedPdfFilePath.toString());

    return generatedPdfFilePath.toString();
  }
}
