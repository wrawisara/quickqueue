import 'package:flutter/material.dart';

class TableInfo {
  int table_id;
  int r_id;
  // List<Map<String, int>> table_type;
  String table_type;
  int capacity;
  int total_capacity;
  bool available;
  String table_name;

  TableInfo(this.table_id,this.r_id,this.table_type,this.capacity,this.total_capacity,this.available,this.table_name);

  static TableInfo generateTableInfo() {
    return 
      TableInfo(1,678,'A',10,60,true,'A001');
    
    
  }
}


