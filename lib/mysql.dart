import 'package:mysql_client/mysql_client.dart';

class Mysql {
  static String host = 'bqquhv7hiskomx4izkti-mysql.services.clever-cloud.com';
  static String user = 'ucavnwuvwpt2fdby';
  static String password = 'V8PQZ8r0QlbmEJriBE5f';
  static String db = 'bqquhv7hiskomx4izkti';

  static int port = 3306;

  Mysql();

  Future<MySQLConnection> getConnection() async {
    return await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
  }

  Future<Iterable<ResultSetRow>> getResults(String query) async {
    var conn = await getConnection();
    await conn.connect();
    var results = await conn.execute(query);
    conn.close();
    return results.rows;
  }
}
