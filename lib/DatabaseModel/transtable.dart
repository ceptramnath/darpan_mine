import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
part 'transtable.g.dart';

const tranMainModel = SqfEntityTable(
    tableName: 'TransactionTable',
    primaryKeyName: 'Sl',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('tranid', DbType.text),
      SqfEntityField('tranType', DbType.text),
      SqfEntityField('tranDescription', DbType.text),
      SqfEntityField('tranDate', DbType.text, isPrimaryKeyField: true),
      SqfEntityField('tranTime', DbType.text, isPrimaryKeyField: true),
      SqfEntityField('tranAmount', DbType.real),
      SqfEntityField('valuation', DbType.text),
    ]);

const tableCash = SqfEntityTable(
    tableName: 'CashTable',
    primaryKeyName: 'Sl',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    // primaryKeyName: 'Cash_ID',
    // primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('Cash_ID', DbType.text),
      SqfEntityField('Cash_Amount', DbType.real),
      SqfEntityField('Cash_Description', DbType.text),
      SqfEntityField('Cash_Type', DbType.text),
      SqfEntityField('Cash_Date', DbType.text, isPrimaryKeyField: true),
      SqfEntityField('Cash_Time', DbType.text, isPrimaryKeyField: true),
    ]);
const DE_DETAILS = SqfEntityTable(
    tableName: 'DataEntry_DETAILS',
    primaryKeyName: 'Sl',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
          SqfEntityField('TRANSACTION_DATE', DbType.text),
          SqfEntityField('TRANSACTION_TIME', DbType.text),
          SqfEntityField('ENTRY_TYPE', DbType.text),
          SqfEntityField('TOTAL_DEPOSITS', DbType.text),
          SqfEntityField('TOTAL_DEPOSIT_AMOUNT', DbType.text),
          SqfEntityField('TOTAL_WITHDRAWALS', DbType.text),
          SqfEntityField('TOTAL_WITHDRAWAL_AMOUNT', DbType.text),
          SqfEntityField('Remarks', DbType.text),
    ]);
const IPPBAPI_DETAILS = SqfEntityTable(
    tableName: 'IppbApi',
    primaryKeyName: 'Sl',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('ReqDATE', DbType.text),
      SqfEntityField('ReqTime', DbType.text),
      SqfEntityField('FacId', DbType.text),
      SqfEntityField('TranDate', DbType.text),
      SqfEntityField('FromDateTime', DbType.text),
      SqfEntityField('ToDateTime', DbType.text),
      SqfEntityField('TotalDeposit', DbType.text),
      SqfEntityField('TotalWithdrawl', DbType.text),
      SqfEntityField('Status', DbType.text),
      SqfEntityField('Remarks', DbType.text),

    ]);
@SqfEntityBuilder(cashModel)
const cashModel = SqfEntityModel(
    modelName: 'transactionsMain',
    databaseName: 'transactionsMain.db',
    password: '7A9vvD7*@f2Hj-',
    databaseTables: [tranMainModel, tableCash,DE_DETAILS,IPPBAPI_DETAILS],
    databasePath: 'storage/emulated/0/Darpan_Mine/Databases');
