import 'package:silkroad/receive/entity/receive_item.dart';

abstract class ReceiveRepository {
  Stream<ReceiveItem> listen(String connectionPoint);
  void close();
}
