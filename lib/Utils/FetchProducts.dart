import 'package:darpan_mine/Mails/Bagging/Model/BagModel.dart';

class FetchProducts {
  static Future<List<Map<String, String>>> getProducts(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    List<ProductsTable> products = [];
    if (query.isNotEmpty) {
      products = await ProductsTable()
          .select()
          .startBlock
          .Price
          .contains(query.toString())
          .or
          .Name
          .contains(query.toString())
          .endBlock
          .toList();
    }
    return List.generate(products.length, (index) {
      return {
        'price': products[index].Price.toString(),
        'name': products[index].Name.toString(),
        'stock': products[index].Quantity.toString(),
        'productid':products[index].ProductID.toString(),
      };
    });
  }
}
