import 'package:floor/floor.dart';

@DatabaseView('''
  SELECT 
    strftime('%Y-%m', date) AS month, 
    type, 
    SUM(value) AS total 
  FROM financialentryentity 
  GROUP BY month, type
''')
class MonthlyTotalView {
  final String month;
  final String type;
  final double total;

  MonthlyTotalView(this.month, this.type, this.total);
}
