import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:http/http.dart' as http;

part 'BagModel.g.dart';

const tableBag = SqfEntityTable(
    tableName: 'bagReceivedTable',
    primaryKeyName: 'BagNumber',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('ReceivedDate', DbType.text),
      SqfEntityField('ReceivedTime', DbType.text),
      SqfEntityField('OpenedDate', DbType.text),
      SqfEntityField('OpenedTime', DbType.text),
      SqfEntityField('ArticlesCount', DbType.text),
      SqfEntityField('StampsCount', DbType.text),
      SqfEntityField('CashCount', DbType.text),
      SqfEntityField('DocumentsCount', DbType.text),
      SqfEntityField('ArticlesStatus', DbType.text),
      SqfEntityField('CashStatus', DbType.text),
      SqfEntityField('StampsStatus', DbType.text),
      SqfEntityField('DocumentsStatus', DbType.text),
      SqfEntityField('Status', DbType.text),
    ]);

const tableCloseBag = SqfEntityTable(
    tableName: 'bagCloseTable',
    primaryKeyName: 'BagNumber',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('ClosedDate', DbType.text),
      SqfEntityField('ClosedTime', DbType.text),
      SqfEntityField('TotalArticlesCount', DbType.text),
      SqfEntityField('CashCount', DbType.text),
      SqfEntityField('Status', DbType.text),
      SqfEntityField('DispatchDate', DbType.text),
      SqfEntityField('DispatchTime', DbType.text),
    ]);

const tableBagArticles = SqfEntityTable(
    tableName: 'bagArticlesTable',
    primaryKeyName: 'Sl',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    // primaryKeyName: 'ArticleNumber',
    // primaryKeyType: PrimaryKeyType.text,
    fields: [
          SqfEntityField('ArticleNumber', DbType.text, isPrimaryKeyField: true),
          SqfEntityField('BagNumber', DbType.text, isPrimaryKeyField: true),
      SqfEntityField('ArticleType', DbType.text),
      SqfEntityField('Status', DbType.text),
      SqfEntityField("IS_COMMUNICATED", DbType.text),
      SqfEntityField("FILE_NAME", DbType.text),
    ]);

const tableJSONBagArticles = SqfEntityTable(
    tableName: 'jsonBagArticlesTable',
    primaryKeyName: 'ArticleNumber',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('BagNumber', DbType.text),
      SqfEntityField('ArticleType', DbType.text),
      SqfEntityField('Status', DbType.text),
    ]);

const tableCloseArticles = SqfEntityTable(
    tableName: 'closeArticlesTable',
    primaryKeyName: 'Sl',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    // primaryKeyName: 'ArticleNumber',
    // primaryKeyType: PrimaryKeyType.text,
    fields: [
          SqfEntityField('ArticleNumber', DbType.text, isPrimaryKeyField: true),
      SqfEntityField('BagNumber', DbType.text, isPrimaryKeyField: true),
      SqfEntityField('ArticleType', DbType.text),
      SqfEntityField('IsExcess', DbType.text),
      SqfEntityField('IsScanned', DbType.text),
      SqfEntityField('IsBooked', DbType.text),
      SqfEntityField('Status', DbType.text),
    ]);

const tableBagExcessArticles = SqfEntityTable(
    tableName: 'bagExcessArticlesTable',
    primaryKeyName: 'ArticleNumber',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('BagNumber', DbType.text),
      SqfEntityField('ArticleType', DbType.text),
      SqfEntityField('Status', DbType.text),
    ]);

const tableBagInventory = SqfEntityTable(
    tableName: 'bagInventory',
    primaryKeyName: 'InventoryID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('BagNumber', DbType.text),
      SqfEntityField('InventoryName', DbType.text),
      SqfEntityField('InventoryPrice', DbType.text),
      SqfEntityField('InventoryQuantity', DbType.text),
    ]);

const tableJSONBagInventory = SqfEntityTable(
    tableName: 'jsonBagInventory',
    primaryKeyName: 'InventoryID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('BagNumber', DbType.text),
      SqfEntityField('InventoryName', DbType.text),
      SqfEntityField('InventoryPrice', DbType.text),
      SqfEntityField('InventoryQuantity', DbType.text),
    ]);

const tableBagStamps = SqfEntityTable(
    tableName: 'bagStampsTable',
    primaryKeyName: 'StampID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('BagNumber', DbType.text),
      SqfEntityField('StampPrice', DbType.text),
      SqfEntityField('StampName', DbType.text),
      SqfEntityField('StampQuantity', DbType.text),
      SqfEntityField('StampAmountTotal', DbType.text),
      SqfEntityField('StampDate', DbType.text),
      SqfEntityField('StampTime', DbType.text),
      SqfEntityField('Status', DbType.text),
    ]);

const tableBagExcessStamps = SqfEntityTable(
    tableName: 'bagExcessStampsTable',
    primaryKeyName: 'StampID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('BagNumber', DbType.text),
      SqfEntityField('StampPrice', DbType.text),
      SqfEntityField('StampName', DbType.text),
      SqfEntityField('Name', DbType.text),
      SqfEntityField('StampQuantity', DbType.text),
      SqfEntityField('StampAmountTotal', DbType.text),
      SqfEntityField('Status', DbType.text),
    ]);

const tableBagCash = SqfEntityTable(
    tableName: 'bagCashTable',
    primaryKeyName: 'CashID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('BagNumber', DbType.text),
      SqfEntityField('BagDate', DbType.text),
      SqfEntityField('CashReceived', DbType.text),
      SqfEntityField('CashAmount', DbType.text),
      SqfEntityField('CashType', DbType.text),
      SqfEntityField('Status', DbType.text),
    ]);

const tableJSONBagCash = SqfEntityTable(
    tableName: 'bagJSONCashTable',
    primaryKeyName: 'CashID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('BagNumber', DbType.text),
      SqfEntityField('CashReceived', DbType.text),
      SqfEntityField('CashAmount', DbType.text),
      SqfEntityField('CashType', DbType.text),
      SqfEntityField('Status', DbType.text),
    ]);

const tableBagDocuments = SqfEntityTable(
    tableName: 'bagDocumentsTable',
    primaryKeyName: 'DocumentID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('BagNumber', DbType.text),
      SqfEntityField('DocumentName', DbType.text),
      SqfEntityField('ReceivedDate', DbType.text),
      SqfEntityField('ReceivedTime', DbType.text),
      SqfEntityField('IsAdded', DbType.text),
      SqfEntityField('DocumentStatus', DbType.text),
    ]);

const tableDocuments = SqfEntityTable(
    tableName: 'documentsTable',
    primaryKeyName: 'DocumentID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('BagNumber', DbType.text),
      SqfEntityField('DocumentName', DbType.text),
    ]);

const tableJSONDocuments = SqfEntityTable(
    tableName: 'jsonDocumentsTable',
    primaryKeyName: 'DocumentID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('BagNumber', DbType.text),
      SqfEntityField('DocumentName', DbType.text),
    ]);

const tableProducts = SqfEntityTable(
    tableName: 'productsTable',
    primaryKeyName: 'ProductID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('Name', DbType.text),
      SqfEntityField('Price', DbType.text),
      SqfEntityField('Quantity', DbType.text),
      SqfEntityField('Value', DbType.text),
    ]);

const excessBagCashTable = SqfEntityTable(
    tableName: 'ExcessBagCashTable',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('SOSlipNumber', DbType.text),
      SqfEntityField('ChequeNumber', DbType.text),
      SqfEntityField('GenerationDate', DbType.text),
      SqfEntityField('BOName', DbType.text),
      SqfEntityField('SOName', DbType.text),
      SqfEntityField('CashAmount', DbType.text),
      SqfEntityField('Weight', DbType.text),
      SqfEntityField('ChequeAmount', DbType.text),
      SqfEntityField('TypeOfPayment', DbType.text),
      SqfEntityField('Miscellaneous', DbType.text),
      SqfEntityField('BagNumber', DbType.text),
      SqfEntityField('FileCreated', DbType.text),
      SqfEntityField('FileName', DbType.text),
      SqfEntityField('FileCreatedDateTime', DbType.text),
      SqfEntityField('FileTransmitted', DbType.text),
      SqfEntityField('FileTransmittedDateTime', DbType.text),
    ]);

const documentTable = SqfEntityTable(
    tableName: 'DocumentTable',
    primaryKeyName: 'DocumentId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('BOAccountNumber', DbType.text),
      SqfEntityField('CreatedOn', DbType.text),
      SqfEntityField('FromOffice', DbType.text),
      SqfEntityField('DocumentDetails', DbType.text),
      SqfEntityField('BagNumber', DbType.text),
      SqfEntityField('FileCreated', DbType.text),
      SqfEntityField('FileName', DbType.text),
      SqfEntityField('FileCreatedDateTime', DbType.text),
      SqfEntityField('FileTransmitted', DbType.text),
      SqfEntityField('FileTransmittedDateTime', DbType.text),
    ]);

const bagTable = SqfEntityTable(
    tableName: 'bagTable',
    primaryKeyName: 'BagNumber',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('BagDate', DbType.text),
      SqfEntityField('BagTime', DbType.text),
      SqfEntityField('BagType', DbType.text),
    ]);

@SqfEntityBuilder(formLetterModel)
const formLetterModel = SqfEntityModel(
    modelName: 'bagModel',
    password: '23a]p!)x{e~[5Z',
    databaseName: 'bag.db',
    databaseTables: [
      tableBag,
      tableBagArticles,
      tableBagStamps,
      tableBagCash,
      tableBagDocuments,
      tableBagInventory,
      tableBagExcessArticles,
      tableBagExcessStamps,
      tableProducts,
      tableDocuments,
      tableCloseBag,
      tableCloseArticles,
      excessBagCashTable,
      documentTable,
      bagTable
    ],
    bundledDatabasePath: null);
