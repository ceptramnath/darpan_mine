import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
part 'uidaiErrCodes.g.dart';

const ErrorCodes = SqfEntityTable(
    tableName: 'API_Errcodes',
    primaryKeyName: 'API_Err_code',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('Description', DbType.text),
      SqfEntityField('Suggestion', DbType.text),
    ]);

const otpErrorCodes=SqfEntityTable(
  tableName: 'Aadhar_OTP_ErrCodes',
  primaryKeyName: 'API_Err_code',
  primaryKeyType: PrimaryKeyType.text,
  fields: [
    SqfEntityField('Description',DbType.text)
  ]
);

@SqfEntityBuilder(aadharModel)
const aadharModel = SqfEntityModel(
    modelName: 'UIDAIErrorCodes', databaseName: 'UIDAIErrorCodes.db',
    password: 'B2t4ktY~zwG27Z',
    // bundledDatabasePath: 'assets/UIDAIErrCodes.db',

    // password: 'xGyZEr8l@loiuy',
    databaseTables: [ErrorCodes,otpErrorCodes]);
