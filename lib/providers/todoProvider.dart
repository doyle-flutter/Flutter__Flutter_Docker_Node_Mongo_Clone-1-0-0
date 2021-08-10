import 'dart:convert';

import 'package:dockerflutter/repos/todoConnect.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TodoProvider with ChangeNotifier{
  List _datas = [];
  List get datas => this._datas;
  set datas(List newDatas){
    this._datas = newDatas;
    this.notifyListeners();
    return;
  }

  TodoProvider(){
    Future.delayed(
      Duration(seconds: 3),
      () async => await Future.microtask(this._readAll)
    );
  }

  TodoConnect _connect = TodoConnect();

  Future<void> _readAll() async{
    const String _path = "/todo/all";
    List _result =  await this._connect.httpGet<List>(
      path: _path,
      res: <List>(http.Response res) => json.decode(res.body)
    );
    this.datas = _result;
    return;
  }

  Future<bool> update({required String updateData, required String id}) async{
    const String _path = "/todo/update";
    final Map<String, String> _body = {"id": id, "update":updateData};
    Map<String, dynamic> _checkList = await _connect.httpPost<Map<String, dynamic>>(
      path: _path,
      body: _body,
      res: <List>(http.Response res) => json.decode(res.body)
    );
    if(_checkList.isEmpty) return false;
    this.datas = [];
    await this._readAll();
    return true;
  }

  Future<bool> add({required String data}) async{
    const String _path = "/todo/add";
    final List _result = await this._connect.httpPost<List>(
      path: _path,
      body: {"data": data},
      res: <List>(http.Response res) => json.decode(res.body)
    );
    if(_result.isEmpty) return false;
    this.datas = [];
    this._readAll();
    return true;
  }

  Future<bool> delete({required String id}) async{
    const String _path = "/todo/delete";
    Map<String, dynamic> _result = await this._connect.httpPost<Map<String, dynamic>>(
      path: _path,
      body: {"id":id},
      res: <Map>(http.Response res) => json.decode(res.body)
    );
    if(_result.isEmpty) return false;
    this.datas = [];
    this._readAll();
    return true;
  }
}
