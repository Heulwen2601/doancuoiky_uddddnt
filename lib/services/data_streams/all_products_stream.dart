import 'package:do_an_ck_uddddnt/services/data_streams/data_stream.dart';
import 'package:do_an_ck_uddddnt/services/database/product_database_helper.dart';

class AllProductsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final allProductsFuture = ProductDatabaseHelper().allProductsList;
    allProductsFuture.then((favProducts) {
      addData(favProducts);
    }).catchError((e) {
      addError(e);
    });
  }
}
