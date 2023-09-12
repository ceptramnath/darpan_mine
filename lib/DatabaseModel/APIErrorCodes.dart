import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
part 'APIErrorCodes.g.dart';

const AErrorCodes = SqfEntityTable(
    tableName: 'API_Error_codes',
    primaryKeyName: 'API_Err_code',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('Description', DbType.text),
    ]);

@SqfEntityBuilder(aadharModel)
const aadharModel = SqfEntityModel(
    modelName: 'APIErrorCodes', databaseName: 'APIErrorCodes.db',


     password: 'Wkq@gJ9z7ACPYVQ',
    databaseTables: [AErrorCodes]);
