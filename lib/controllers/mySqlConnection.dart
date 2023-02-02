import 'package:mysql1/mysql1.dart';

class MySQLConnection {
  static final MySQLConnection _singleton = MySQLConnection._internal();

  factory MySQLConnection() {
    return _singleton;
  }

  MySQLConnection._internal();

  Future<MySqlConnection> getConnection() async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: '192.185.16.172',
        port: 3306,
        user: 'mahmoodd_repmeadmin',
        password: 'Rep@Me123',
        db: 'mahmoodd_repmedata',
      ),
    );
    return conn;
  }
}