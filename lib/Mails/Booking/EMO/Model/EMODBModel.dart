import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'EMODBModel.g.dart';

const tableFormEMO = SqfEntityTable(
    tableName: 'emoTable',
    primaryKeyName: 'emoId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('EMOValue', DbType.integer),
      SqfEntityField('Message', DbType.text),
      SqfEntityField('Commission', DbType.integer),
      SqfEntityField('EMOAmount', DbType.integer),
      SqfEntityField('SenderName', DbType.text),
      SqfEntityField('SenderAddress', DbType.text),
      SqfEntityField('SenderPincode', DbType.integer),
      SqfEntityField('SenderCity', DbType.text),
      SqfEntityField('SenderState', DbType.text),
      SqfEntityField('SenderMobileNumber', DbType.text),
      SqfEntityField('SenderEmail', DbType.text),
      SqfEntityField('PayeeName', DbType.text),
      SqfEntityField('PayeeAddress', DbType.text),
      SqfEntityField('PayeePincode', DbType.integer),
      SqfEntityField('PayeeCity', DbType.text),
      SqfEntityField('PayeeState', DbType.text),
      SqfEntityField('PayeeMobileNumber', DbType.text),
      SqfEntityField('PayeeEmail', DbType.text),
      SqfEntityField('Type', DbType.text),
      SqfEntityField('RemarkDate', DbType.text),
    ]);

@SqfEntityBuilder(formLetterModel)
const formLetterModel = SqfEntityModel(
    modelName: 'emoFormModel',
    databaseName: 'emoForm.db',
    databaseTables: [
      tableFormEMO,
    ],
    bundledDatabasePath: null);
