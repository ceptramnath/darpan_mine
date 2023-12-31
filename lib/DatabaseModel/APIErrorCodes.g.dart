// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'APIErrorCodes.dart';

// **************************************************************************
// SqfEntityGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names

//  These classes was generated by SqfEntity
//  Copyright (c) 2019, All rights reserved. Use of this source code is governed by a
//  Apache license that can be found in the LICENSE file.

//  To use these SqfEntity classes do following:
//  - import model.dart into where to use
//  - start typing ex:API_Error_code.select()... (add a few filters with fluent methods)...(add orderBy/orderBydesc if you want)...
//  - and then just put end of filters / or end of only select()  toSingle() / or toList()
//  - you can select one or return List<yourObject> by your filters and orders
//  - also you can batch update or batch delete by using delete/update methods instead of tosingle/tolist methods
//    Enjoy.. Huseyin Tokpunar

// BEGIN TABLES
// API_Error_code TABLE
class TableAPI_Error_code extends SqfEntityTableBase {
  TableAPI_Error_code() {
    // declare properties of EntityTable
    tableName = 'API_Error_codes';
    primaryKeyName = 'API_Err_code';
    primaryKeyType = PrimaryKeyType.text;
    useSoftDeleting = false;
    // when useSoftDeleting is true, creates a field named 'isDeleted' on the table, and set to '1' this field when item deleted (does not hard delete)

    // declare fields
    fields = [
      SqfEntityFieldBase('Description', DbType.text),
    ];
    super.init();
  }
  static SqfEntityTableBase? _instance;
  static SqfEntityTableBase get getInstance {
    return _instance = _instance ?? TableAPI_Error_code();
  }
}
// END TABLES

// BEGIN DATABASE MODEL
class APIErrorCodes extends SqfEntityModelProvider {
  APIErrorCodes() {
    databaseName = aadharModel.databaseName;
    password = aadharModel.password;
    dbVersion = aadharModel.dbVersion;
    preSaveAction = aadharModel.preSaveAction;
    logFunction = aadharModel.logFunction;
    databaseTables = [
      TableAPI_Error_code.getInstance,
    ];

    bundledDatabasePath = aadharModel
        .bundledDatabasePath; //'assets/sample.db'; // This value is optional. When bundledDatabasePath is empty then EntityBase creats a new database when initializing the database
    databasePath = aadharModel.databasePath;
  }
  Map<String, dynamic> getControllers() {
    final controllers = <String, dynamic>{};

    return controllers;
  }
}
// END DATABASE MODEL

// BEGIN ENTITIES
// region API_Error_code
class API_Error_code extends TableBase {
  API_Error_code({this.API_Err_code, this.Description}) {
    _setDefaultValues();
    softDeleteActivated = false;
  }
  API_Error_code.withFields(this.API_Err_code, this.Description) {
    _setDefaultValues();
  }
  API_Error_code.withId(this.API_Err_code, this.Description) {
    _setDefaultValues();
  }
  // fromMap v2.0
  API_Error_code.fromMap(Map<String, dynamic> o,
      {bool setDefaultValues = true}) {
    if (setDefaultValues) {
      _setDefaultValues();
    }
    API_Err_code = o['API_Err_code'].toString();
    if (o['Description'] != null) {
      Description = o['Description'].toString();
    }

    isSaved = true;
  }
  // FIELDS (API_Error_code)
  String? API_Err_code;
  String? Description;
  bool? isSaved;
  // end FIELDS (API_Error_code)

  static const bool _softDeleteActivated = false;
  API_Error_codeManager? __mnAPI_Error_code;

  API_Error_codeManager get _mnAPI_Error_code {
    return __mnAPI_Error_code = __mnAPI_Error_code ?? API_Error_codeManager();
  }

  // METHODS
  @override
  Map<String, dynamic> toMap(
      {bool forQuery = false, bool forJson = false, bool forView = false}) {
    final map = <String, dynamic>{};
    map['API_Err_code'] = API_Err_code;
    if (Description != null || !forView) {
      map['Description'] = Description;
    }

    return map;
  }

  @override
  Future<Map<String, dynamic>> toMapWithChildren(
      [bool forQuery = false,
      bool forJson = false,
      bool forView = false]) async {
    final map = <String, dynamic>{};
    map['API_Err_code'] = API_Err_code;
    if (Description != null || !forView) {
      map['Description'] = Description;
    }

    return map;
  }

  /// This method returns Json String [API_Error_code]
  @override
  String toJson() {
    return json.encode(toMap(forJson: true));
  }

  /// This method returns Json String [API_Error_code]
  @override
  Future<String> toJsonWithChilds() async {
    return json.encode(await toMapWithChildren(false, true));
  }

  @override
  List<dynamic> toArgs() {
    return [API_Err_code, Description];
  }

  @override
  List<dynamic> toArgsWithIds() {
    return [API_Err_code, Description];
  }

  static Future<List<API_Error_code>?> fromWebUrl(Uri uri,
      {Map<String, String>? headers}) async {
    try {
      final response = await http.get(uri, headers: headers);
      return await fromJson(response.body);
    } catch (e) {
      debugPrint(
          'SQFENTITY ERROR API_Error_code.fromWebUrl: ErrorMessage: ${e.toString()}');
      return null;
    }
  }

  Future<http.Response> postUrl(Uri uri, {Map<String, String>? headers}) {
    return http.post(uri, headers: headers, body: toJson());
  }

  static Future<List<API_Error_code>> fromJson(String jsonBody) async {
    final Iterable list = await json.decode(jsonBody) as Iterable;
    var objList = <API_Error_code>[];
    try {
      objList = list
          .map((api_error_code) =>
              API_Error_code.fromMap(api_error_code as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint(
          'SQFENTITY ERROR API_Error_code.fromJson: ErrorMessage: ${e.toString()}');
    }
    return objList;
  }

  static Future<List<API_Error_code>> fromMapList(List<dynamic> data,
      {bool preload = false,
      List<String>? preloadFields,
      bool loadParents = false,
      List<String>? loadedFields,
      bool setDefaultValues = true}) async {
    final List<API_Error_code> objList = <API_Error_code>[];
    loadedFields = loadedFields ?? [];
    for (final map in data) {
      final obj = API_Error_code.fromMap(map as Map<String, dynamic>,
          setDefaultValues: setDefaultValues);

      objList.add(obj);
    }
    return objList;
  }

  /// returns API_Error_code by ID if exist, otherwise returns null
  /// Primary Keys: String? API_Err_code
  /// bool preload: if true, loads all related child objects (Set preload to true if you want to load all fields related to child or parent)
  /// ex: getById(preload:true) -> Loads all related objects
  /// List<String> preloadFields: specify the fields you want to preload (preload parameter's value should also be "true")
  /// ex: getById(preload:true, preloadFields:['plField1','plField2'... etc])  -> Loads only certain fields what you specified
  /// bool loadParents: if true, loads all parent objects until the object has no parent

  /// <returns>returns [API_Error_code] if exist, otherwise returns null
  Future<API_Error_code?> getById(String? API_Err_code,
      {bool preload = false,
      List<String>? preloadFields,
      bool loadParents = false,
      List<String>? loadedFields}) async {
    if (API_Err_code == null) {
      return null;
    }
    API_Error_code? obj;
    final data = await _mnAPI_Error_code.getById([API_Err_code]);
    if (data.length != 0) {
      obj = API_Error_code.fromMap(data[0] as Map<String, dynamic>);
    } else {
      obj = null;
    }
    return obj;
  }

  /// Saves the (API_Error_code) object. If the Primary Key (API_Err_code) field is null, returns Error.
  /// INSERTS (If not exist) OR REPLACES (If exist) data while Primary Key is not null.
  /// Call the saveAs() method if you do not want to save it when there is another row with the same API_Err_code
  /// <returns>Returns BoolResult
  @override
  Future<BoolResult> save({bool ignoreBatch = true}) async {
    final result = BoolResult(success: false);
    try {
      await _mnAPI_Error_code.rawInsert(
          'INSERT ${isSaved! ? 'OR REPLACE' : ''} INTO API_Error_codes (API_Err_code, Description)  VALUES (?,?)',
          toArgsWithIds(),
          ignoreBatch);
      result.success = true;
      isSaved = true;
    } catch (e) {
      result.errorMessage = e.toString();
    }

    saveResult = result;
    return result;
  }

  /// saveAll method saves the sent List<API_Error_code> as a bulk in one transaction
  /// Returns a <List<BoolResult>>
  static Future<List<dynamic>> saveAll(List<API_Error_code> api_error_codes,
      {bool? exclusive, bool? noResult, bool? continueOnError}) async {
    List<dynamic>? result = [];
    // If there is no open transaction, start one
    final isStartedBatch = await APIErrorCodes().batchStart();
    for (final obj in api_error_codes) {
      await obj.save();
    }
    if (!isStartedBatch) {
      result = await APIErrorCodes().batchCommit(
          exclusive: exclusive,
          noResult: noResult,
          continueOnError: continueOnError);
    }
    return result!;
  }

  /// Updates if the record exists, otherwise adds a new row
  /// <returns>Returns 1
  @override
  Future<int?> upsert({bool ignoreBatch = true}) async {
    try {
      final result = await _mnAPI_Error_code.rawInsert(
          'INSERT OR REPLACE INTO API_Error_codes (API_Err_code, Description)  VALUES (?,?)',
          [API_Err_code, Description],
          ignoreBatch);
      if (result! > 0) {
        saveResult = BoolResult(
            success: true,
            successMessage:
                'API_Error_code API_Err_code=$API_Err_code updated successfully');
      } else {
        saveResult = BoolResult(
            success: false,
            errorMessage:
                'API_Error_code API_Err_code=$API_Err_code did not update');
      }
      return 1;
    } catch (e) {
      saveResult = BoolResult(
          success: false,
          errorMessage: 'API_Error_code Save failed. Error: ${e.toString()}');
      return null;
    }
  }

  /// Updates if the record exists, otherwise adds a new row
  /// <returns>Returns 1
  @override
  Future<int?> upsert1({bool ignoreBatch = true}) async {
    try {
      final result = await _mnAPI_Error_code.rawInsert(
          'INSERT OR IGNORE INTO API_Error_codes (API_Err_code, Description)  VALUES (?,?)',
          [API_Err_code, Description],
          ignoreBatch);
      if (result! > 0) {
        saveResult = BoolResult(
            success: true,
            successMessage:
                'API_Error_code API_Err_code=$API_Err_code updated successfully');
      } else {
        saveResult = BoolResult(
            success: false,
            errorMessage:
                'API_Error_code API_Err_code=$API_Err_code did not update');
      }
      return 1;
    } catch (e) {
      saveResult = BoolResult(
          success: false,
          errorMessage: 'API_Error_code Save failed. Error: ${e.toString()}');
      return null;
    }
  }

  /// Deletes API_Error_code

  /// <returns>BoolResult res.success= true (Deleted), false (Could not be deleted)
  @override
  Future<BoolResult> delete([bool hardDelete = false]) async {
    debugPrint(
        'SQFENTITIY: delete API_Error_code invoked (API_Err_code=$API_Err_code)');
    if (!_softDeleteActivated || hardDelete) {
      return _mnAPI_Error_code.delete(QueryParams(
          whereString: 'API_Err_code=?', whereArguments: [API_Err_code]));
    } else {
      return _mnAPI_Error_code.updateBatch(
          QueryParams(
              whereString: 'API_Err_code=?', whereArguments: [API_Err_code]),
          {'isDeleted': 1});
    }
  }

  @override
  Future<BoolResult> recover([bool recoverChilds = true]) {
    // not implemented because:
    final msg =
        'set useSoftDeleting:true in the table definition of [API_Error_code] to use this feature';
    throw UnimplementedError(msg);
  }

  @override
  API_Error_codeFilterBuilder select(
      {List<String>? columnsToSelect, bool? getIsDeleted}) {
    return API_Error_codeFilterBuilder(this, getIsDeleted)
      ..qparams.selectColumns = columnsToSelect;
  }

  @override
  API_Error_codeFilterBuilder distinct(
      {List<String>? columnsToSelect, bool? getIsDeleted}) {
    return API_Error_codeFilterBuilder(this, getIsDeleted)
      ..qparams.selectColumns = columnsToSelect
      ..qparams.distinct = true;
  }

  void _setDefaultValues() {
    isSaved = false;
  }

  @override
  void rollbackPk() {
    if (isInsert == true) {
      API_Err_code = null;
    }
  }

  // END METHODS
  // BEGIN CUSTOM CODE
  /*
      you can define customCode property of your SqfEntityTable constant. For example:
      const tablePerson = SqfEntityTable(
      tableName: 'person',
      primaryKeyName: 'id',
      primaryKeyType: PrimaryKeyType.integer_auto_incremental,
      fields: [
        SqfEntityField('firstName', DbType.text),
        SqfEntityField('lastName', DbType.text),
      ],
      customCode: '''
       String fullName()
       { 
         return '$firstName $lastName';
       }
      ''');
     */
  // END CUSTOM CODE
}
// endregion api_error_code

// region API_Error_codeField
class API_Error_codeField extends FilterBase {
  API_Error_codeField(API_Error_codeFilterBuilder api_error_codeFB)
      : super(api_error_codeFB);

  @override
  API_Error_codeFilterBuilder equals(dynamic pValue) {
    return super.equals(pValue) as API_Error_codeFilterBuilder;
  }

  @override
  API_Error_codeFilterBuilder equalsOrNull(dynamic pValue) {
    return super.equalsOrNull(pValue) as API_Error_codeFilterBuilder;
  }

  @override
  API_Error_codeFilterBuilder isNull() {
    return super.isNull() as API_Error_codeFilterBuilder;
  }

  @override
  API_Error_codeFilterBuilder contains(dynamic pValue) {
    return super.contains(pValue) as API_Error_codeFilterBuilder;
  }

  @override
  API_Error_codeFilterBuilder startsWith(dynamic pValue) {
    return super.startsWith(pValue) as API_Error_codeFilterBuilder;
  }

  @override
  API_Error_codeFilterBuilder endsWith(dynamic pValue) {
    return super.endsWith(pValue) as API_Error_codeFilterBuilder;
  }

  @override
  API_Error_codeFilterBuilder between(dynamic pFirst, dynamic pLast) {
    return super.between(pFirst, pLast) as API_Error_codeFilterBuilder;
  }

  @override
  API_Error_codeFilterBuilder greaterThan(dynamic pValue) {
    return super.greaterThan(pValue) as API_Error_codeFilterBuilder;
  }

  @override
  API_Error_codeFilterBuilder lessThan(dynamic pValue) {
    return super.lessThan(pValue) as API_Error_codeFilterBuilder;
  }

  @override
  API_Error_codeFilterBuilder greaterThanOrEquals(dynamic pValue) {
    return super.greaterThanOrEquals(pValue) as API_Error_codeFilterBuilder;
  }

  @override
  API_Error_codeFilterBuilder lessThanOrEquals(dynamic pValue) {
    return super.lessThanOrEquals(pValue) as API_Error_codeFilterBuilder;
  }

  @override
  API_Error_codeFilterBuilder inValues(dynamic pValue) {
    return super.inValues(pValue) as API_Error_codeFilterBuilder;
  }

  @override
  API_Error_codeField get not {
    return super.not as API_Error_codeField;
  }
}
// endregion API_Error_codeField

// region API_Error_codeFilterBuilder
class API_Error_codeFilterBuilder extends ConjunctionBase {
  API_Error_codeFilterBuilder(API_Error_code obj, bool? getIsDeleted)
      : super(obj, getIsDeleted) {
    _mnAPI_Error_code = obj._mnAPI_Error_code;
    _softDeleteActivated = obj.softDeleteActivated;
  }

  bool _softDeleteActivated = false;
  API_Error_codeManager? _mnAPI_Error_code;

  /// put the sql keyword 'AND'
  @override
  API_Error_codeFilterBuilder get and {
    super.and;
    return this;
  }

  /// put the sql keyword 'OR'
  @override
  API_Error_codeFilterBuilder get or {
    super.or;
    return this;
  }

  /// open parentheses
  @override
  API_Error_codeFilterBuilder get startBlock {
    super.startBlock;
    return this;
  }

  /// String whereCriteria, write raw query without 'where' keyword. Like this: 'field1 like 'test%' and field2 = 3'
  @override
  API_Error_codeFilterBuilder where(String? whereCriteria,
      {dynamic parameterValue}) {
    super.where(whereCriteria, parameterValue: parameterValue);
    return this;
  }

  /// page = page number,
  /// pagesize = row(s) per page
  @override
  API_Error_codeFilterBuilder page(int page, int pagesize) {
    super.page(page, pagesize);
    return this;
  }

  /// int count = LIMIT
  @override
  API_Error_codeFilterBuilder top(int count) {
    super.top(count);
    return this;
  }

  /// close parentheses
  @override
  API_Error_codeFilterBuilder get endBlock {
    super.endBlock;
    return this;
  }

  /// argFields might be String or List<String>.
  /// Example 1: argFields='name, date'
  /// Example 2: argFields = ['name', 'date']
  @override
  API_Error_codeFilterBuilder orderBy(dynamic argFields) {
    super.orderBy(argFields);
    return this;
  }

  /// argFields might be String or List<String>.
  /// Example 1: argFields='field1, field2'
  /// Example 2: argFields = ['field1', 'field2']
  @override
  API_Error_codeFilterBuilder orderByDesc(dynamic argFields) {
    super.orderByDesc(argFields);
    return this;
  }

  /// argFields might be String or List<String>.
  /// Example 1: argFields='field1, field2'
  /// Example 2: argFields = ['field1', 'field2']
  @override
  API_Error_codeFilterBuilder groupBy(dynamic argFields) {
    super.groupBy(argFields);
    return this;
  }

  /// argFields might be String or List<String>.
  /// Example 1: argFields='name, date'
  /// Example 2: argFields = ['name', 'date']
  @override
  API_Error_codeFilterBuilder having(dynamic argFields) {
    super.having(argFields);
    return this;
  }

  API_Error_codeField _setField(
      API_Error_codeField? field, String colName, DbType dbtype) {
    return API_Error_codeField(this)
      ..param = DbParameter(
          dbType: dbtype, columnName: colName, wStartBlock: openedBlock);
  }

  API_Error_codeField? _API_Err_code;
  API_Error_codeField get API_Err_code {
    return _API_Err_code =
        _setField(_API_Err_code, 'API_Err_code', DbType.integer);
  }

  API_Error_codeField? _Description;
  API_Error_codeField get Description {
    return _Description = _setField(_Description, 'Description', DbType.text);
  }

  /// Deletes List<API_Error_code> bulk by query
  ///
  /// <returns>BoolResult res.success= true (Deleted), false (Could not be deleted)
  @override
  Future<BoolResult> delete([bool hardDelete = false]) async {
    buildParameters();
    var r = BoolResult(success: false);

    if (_softDeleteActivated && !hardDelete) {
      r = await _mnAPI_Error_code!.updateBatch(qparams, {'isDeleted': 1});
    } else {
      r = await _mnAPI_Error_code!.delete(qparams);
    }
    return r;
  }

  /// using:
  /// update({'fieldName': Value})
  /// fieldName must be String. Value is dynamic, it can be any of the (int, bool, String.. )
  @override
  Future<BoolResult> update(Map<String, dynamic> values) {
    buildParameters();
    if (qparams.limit! > 0 || qparams.offset! > 0) {
      qparams.whereString =
          'API_Err_code IN (SELECT API_Err_code from API_Error_codes ${qparams.whereString!.isNotEmpty ? 'WHERE ${qparams.whereString}' : ''}${qparams.limit! > 0 ? ' LIMIT ${qparams.limit}' : ''}${qparams.offset! > 0 ? ' OFFSET ${qparams.offset}' : ''})';
    }
    return _mnAPI_Error_code!.updateBatch(qparams, values);
  }

  /// This method always returns [API_Error_code] Obj if exist, otherwise returns null
  /// bool preload: if true, loads all related child objects (Set preload to true if you want to load all fields related to child or parent)
  /// ex: toSingle(preload:true) -> Loads all related objects
  /// List<String> preloadFields: specify the fields you want to preload (preload parameter's value should also be "true")
  /// ex: toSingle(preload:true, preloadFields:['plField1','plField2'... etc])  -> Loads only certain fields what you specified
  /// bool loadParents: if true, loads all parent objects until the object has no parent

  /// <returns> API_Error_code?
  @override
  Future<API_Error_code?> toSingle(
      {bool preload = false,
      List<String>? preloadFields,
      bool loadParents = false,
      List<String>? loadedFields}) async {
    buildParameters(pSize: 1);
    final objFuture = _mnAPI_Error_code!.toList(qparams);
    final data = await objFuture;
    API_Error_code? obj;
    if (data.isNotEmpty) {
      obj = API_Error_code.fromMap(data[0] as Map<String, dynamic>);
    } else {
      obj = null;
    }
    return obj;
  }

  /// This method always returns [API_Error_code]
  /// bool preload: if true, loads all related child objects (Set preload to true if you want to load all fields related to child or parent)
  /// ex: toSingle(preload:true) -> Loads all related objects
  /// List<String> preloadFields: specify the fields you want to preload (preload parameter's value should also be "true")
  /// ex: toSingle(preload:true, preloadFields:['plField1','plField2'... etc])  -> Loads only certain fields what you specified
  /// bool loadParents: if true, loads all parent objects until the object has no parent

  /// <returns> API_Error_code?
  @override
  Future<API_Error_code> toSingleOrDefault(
      {bool preload = false,
      List<String>? preloadFields,
      bool loadParents = false,
      List<String>? loadedFields}) async {
    return await toSingle(
            preload: preload,
            preloadFields: preloadFields,
            loadParents: loadParents,
            loadedFields: loadedFields) ??
        API_Error_code();
  }

  /// This method returns int. [API_Error_code]
  /// <returns>int
  @override
  Future<int> toCount(
      [VoidCallback Function(int c)? api_error_codeCount]) async {
    buildParameters();
    qparams.selectColumns = ['COUNT(1) AS CNT'];
    final api_error_codesFuture = await _mnAPI_Error_code!.toList(qparams);
    final int count = api_error_codesFuture[0]['CNT'] as int;
    if (api_error_codeCount != null) {
      api_error_codeCount(count);
    }
    return count;
  }

  /// This method returns List<API_Error_code> [API_Error_code]
  /// bool preload: if true, loads all related child objects (Set preload to true if you want to load all fields related to child or parent)
  /// ex: toList(preload:true) -> Loads all related objects
  /// List<String> preloadFields: specify the fields you want to preload (preload parameter's value should also be "true")
  /// ex: toList(preload:true, preloadFields:['plField1','plField2'... etc])  -> Loads only certain fields what you specified
  /// bool loadParents: if true, loads all parent objects until the object has no parent

  /// <returns>List<API_Error_code>
  @override
  Future<List<API_Error_code>> toList(
      {bool preload = false,
      List<String>? preloadFields,
      bool loadParents = false,
      List<String>? loadedFields}) async {
    final data = await toMapList();
    final List<API_Error_code> api_error_codesData =
        await API_Error_code.fromMapList(data,
            preload: preload,
            preloadFields: preloadFields,
            loadParents: loadParents,
            loadedFields: loadedFields,
            setDefaultValues: qparams.selectColumns == null);
    return api_error_codesData;
  }

  /// This method returns Json String [API_Error_code]
  @override
  Future<String> toJson() async {
    final list = <dynamic>[];
    final data = await toList();
    for (var o in data) {
      list.add(o.toMap(forJson: true));
    }
    return json.encode(list);
  }

  /// This method returns Json String. [API_Error_code]
  @override
  Future<String> toJsonWithChilds() async {
    final list = <dynamic>[];
    final data = await toList();
    for (var o in data) {
      list.add(await o.toMapWithChildren(false, true));
    }
    return json.encode(list);
  }

  /// This method returns List<dynamic>. [API_Error_code]
  /// <returns>List<dynamic>
  @override
  Future<List<dynamic>> toMapList() async {
    buildParameters();
    return await _mnAPI_Error_code!.toList(qparams);
  }

  /// This method returns Primary Key List SQL and Parameters retVal = Map<String,dynamic>. [API_Error_code]
  /// retVal['sql'] = SQL statement string, retVal['args'] = whereArguments List<dynamic>;
  /// <returns>List<String>
  @override
  Map<String, dynamic> toListPrimaryKeySQL([bool buildParams = true]) {
    final Map<String, dynamic> _retVal = <String, dynamic>{};
    if (buildParams) {
      buildParameters();
    }
    _retVal['sql'] =
        'SELECT `API_Err_code` FROM API_Error_codes WHERE ${qparams.whereString}';
    _retVal['args'] = qparams.whereArguments;
    return _retVal;
  }

  /// This method returns Primary Key List<String>.
  /// <returns>List<String>
  @override
  Future<List<String>> toListPrimaryKey([bool buildParams = true]) async {
    if (buildParams) {
      buildParameters();
    }
    final List<String> API_Err_codeData = <String>[];
    qparams.selectColumns = ['API_Err_code'];
    final API_Err_codeFuture = await _mnAPI_Error_code!.toList(qparams);

    final int count = API_Err_codeFuture.length;
    for (int i = 0; i < count; i++) {
      API_Err_codeData.add(API_Err_codeFuture[i]['API_Err_code'] as String);
    }
    return API_Err_codeData;
  }

  /// Returns List<dynamic> for selected columns. Use this method for 'groupBy' with min,max,avg..  [API_Error_code]
  /// Sample usage: (see EXAMPLE 4.2 at https://github.com/hhtokpinar/sqfEntity#group-by)
  @override
  Future<List<dynamic>> toListObject() async {
    buildParameters();

    final objectFuture = _mnAPI_Error_code!.toList(qparams);

    final List<dynamic> objectsData = <dynamic>[];
    final data = await objectFuture;
    final int count = data.length;
    for (int i = 0; i < count; i++) {
      objectsData.add(data[i]);
    }
    return objectsData;
  }

  /// Returns List<String> for selected first column
  /// Sample usage: await API_Error_code.select(columnsToSelect: ['columnName']).toListString()
  @override
  Future<List<String>> toListString(
      [VoidCallback Function(List<String> o)? listString]) async {
    buildParameters();

    final objectFuture = _mnAPI_Error_code!.toList(qparams);

    final List<String> objectsData = <String>[];
    final data = await objectFuture;
    final int count = data.length;
    for (int i = 0; i < count; i++) {
      objectsData.add(data[i][qparams.selectColumns![0]].toString());
    }
    if (listString != null) {
      listString(objectsData);
    }
    return objectsData;
  }
}
// endregion API_Error_codeFilterBuilder

// region API_Error_codeFields
class API_Error_codeFields {
  static TableField? _fAPI_Err_code;
  static TableField get API_Err_code {
    return _fAPI_Err_code = _fAPI_Err_code ??
        SqlSyntax.setField(_fAPI_Err_code, 'api_err_code', DbType.integer);
  }

  static TableField? _fDescription;
  static TableField get Description {
    return _fDescription = _fDescription ??
        SqlSyntax.setField(_fDescription, 'Description', DbType.text);
  }
}
// endregion API_Error_codeFields

//region API_Error_codeManager
class API_Error_codeManager extends SqfEntityProvider {
  API_Error_codeManager()
      : super(APIErrorCodes(),
            tableName: _tableName,
            primaryKeyList: _primaryKeyList,
            whereStr: _whereStr);
  static const String _tableName = 'API_Error_codes';
  static const List<String> _primaryKeyList = ['API_Err_code'];
  static const String _whereStr = 'API_Err_code=?';
}

//endregion API_Error_codeManager
class APIErrorCodesSequenceManager extends SqfEntityProvider {
  APIErrorCodesSequenceManager() : super(APIErrorCodes());
}
// END OF ENTITIES
