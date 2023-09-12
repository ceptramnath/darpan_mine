import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'ReportsModel.g.dart';

const inventoryMainModel = SqfEntityTable(
    tableName: 'InventoryMainTable',
    primaryKeyName: 'InventoryID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('ItemCode', DbType.text),
      SqfEntityField('ItemName', DbType.text),
      SqfEntityField('ItemDenomination', DbType.text),
      SqfEntityField('ItemBalance', DbType.text)
    ]);

const inventoryDailyTable = SqfEntityTable(
    tableName: 'InventoryDailyTable',
    primaryKeyName: 'InventoryID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('ItemCode', DbType.text),
      SqfEntityField('ItemName', DbType.text),
      SqfEntityField('ItemDenomination', DbType.text),
      SqfEntityField('ReportDate', DbType.text),
      SqfEntityField('OpeningStock', DbType.text),
      SqfEntityField('ClosingStock', DbType.text),
      SqfEntityField('SaleStock', DbType.text),
    ]);

const inventoryReceiveTable = SqfEntityTable(
    tableName: 'InventoryReceiveTable',
    primaryKeyName: 'InventoryID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('InventoryPrice', DbType.text),
      SqfEntityField('InventoryName', DbType.text),
      SqfEntityField('InventoryQuantity', DbType.text),
      SqfEntityField('InventoryOpeningDate', DbType.text),
      SqfEntityField('InventoryOpeningTime', DbType.text),
      SqfEntityField('InventoryClosingDate', DbType.text),
      SqfEntityField('InventoryClosingTime', DbType.text),
      SqfEntityField('InventoryOpeningBalance', DbType.text),
      SqfEntityField('InventoryClosingBalance', DbType.text),
    ]);

const cashReceiveTable = SqfEntityTable(
    tableName: 'CashReceiveTable',
    primaryKeyName: 'CashID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('CashOpeningDate', DbType.text),
      SqfEntityField('CashOpeningTime', DbType.text),
      SqfEntityField('CashOpeningBalance', DbType.text),
      SqfEntityField('CashClosingDate', DbType.text),
      SqfEntityField('CashClosingTime', DbType.text),
      SqfEntityField('CashClosingBalance', DbType.text),
    ]);

const syncDetails = SqfEntityTable(
    tableName: 'FileSyncDetails',
    primaryKeyName: 'ClientTransactionId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('FileName', DbType.text),
      SqfEntityField('FilePath', DbType.text),
      SqfEntityField('ServiceText', DbType.text),
      SqfEntityField('Status', DbType.text),
      SqfEntityField('UpdatedAt', DbType.text),
      SqfEntityField('Processed', DbType.text),
    ]);

const tableCash = SqfEntityTable(
    tableName: 'CashTableBackup',
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

const tranMainModel = SqfEntityTable(
    tableName: 'TransactionTableBackup',
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


const checkPincode = SqfEntityTable(
    tableName: 'PincodeUpdateTable',
    primaryKeyName: 'appversion',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('versiondate', DbType.text),
      SqfEntityField('pincodecount', DbType.text),
      SqfEntityField('status', DbType.text , defaultValue: "N"),

    ]);



@SqfEntityBuilder(reportModel)
const reportModel = SqfEntityModel(
    modelName: 'reportModel',
    databaseName: 'report.db',
    password: '@U4QRj"Al_5^H)',
    databaseTables: [
      inventoryMainModel,
      inventoryReceiveTable,
      cashReceiveTable,
      syncDetails,
          tableCash,tranMainModel,checkPincode
    ]);
