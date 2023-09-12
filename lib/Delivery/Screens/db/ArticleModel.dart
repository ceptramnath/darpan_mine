import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'ArticleModel.g.dart';

const tablelogin = SqfEntityTable(
    tableName: 'logintable',
    primaryKeyName: 'id',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('PostmanName', DbType.text),
      SqfEntityField(
        'BeatNo',
        DbType.text,
      ),
      SqfEntityField(
        'BatchNo',
        DbType.text,
      ),
      SqfEntityField('Pincode', DbType.text),
      SqfEntityField('DelOfficeCode', DbType.text),
      SqfEntityField('OfficeName', DbType.text),
      SqfEntityField('MobileNumber', DbType.text),
      SqfEntityField('FacilityId', DbType.text),
      SqfEntityField('EmpId', DbType.text),
      SqfEntityField('is_Active', DbType.integer),
    ]);

const nonDeliveryReasonsTable = SqfEntityTable(
    tableName: 'reasons',
    primaryKeyName: 'reasonId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('reasonCode', DbType.text),
      SqfEntityField('reasonText', DbType.text),
      SqfEntityField('remarkCode', DbType.text),
      SqfEntityField('remarkText', DbType.text),
      SqfEntityField('actionCode', DbType.text),
      SqfEntityField('actionText', DbType.text),
    ]);

const returnArticleTable = SqfEntityTable(
    tableName: 'returnArticle',
    primaryKeyName: 'returnArticleId',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('addressee', DbType.text),
      SqfEntityField('date', DbType.text),
    ]);

const takeReturnArticleTable = SqfEntityTable(
    tableName: 'takeReturnArticle',
    primaryKeyName: 'articleNumber',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('addressee', DbType.text),
      SqfEntityField('articleType', DbType.text),
    ]);

const takeArticleReturnTable = SqfEntityTable(
    tableName: 'takeArticleReturn',
    primaryKeyName: 'articleNumber',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('addressee', DbType.text),
      SqfEntityField('invoiceDate', DbType.text),
      SqfEntityField('remarkDate', DbType.text),
      SqfEntityField('isListArticle', DbType.integer),
      SqfEntityField('articleType', DbType.text),
      SqfEntityField('articleStatus', DbType.text),
    ]);

const artRetTable = SqfEntityTable(
    tableName: 'artRet',
    primaryKeyName: 'articleNumber',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('addressee', DbType.text),
      SqfEntityField('invoiceDate', DbType.text),
      SqfEntityField('isListArticle', DbType.integer),
    ]);

const articleReturnTable = SqfEntityTable(
    tableName: 'articleReturn',
    primaryKeyName: 'articleNumber',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('addressee', DbType.text),
      SqfEntityField('invoiceDate', DbType.text),
      SqfEntityField('isListArticle', DbType.integer),
      SqfEntityField('articleType', DbType.text),
    ]);

const retArtTable = SqfEntityTable(
    tableName: 'retArt',
    primaryKeyName: 'articleNumber',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('addressee', DbType.text),
      SqfEntityField('invoiceDate', DbType.text),
      SqfEntityField('isListArticle', DbType.integer),
      SqfEntityField('articleType', DbType.text),
    ]);

const returnsNotTakenTable = SqfEntityTable(
    tableName: 'returnsNotTakenTable',
    primaryKeyName: 'articleNumber',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('addressee', DbType.text),
      SqfEntityField('invoiceDate', DbType.text),
      SqfEntityField('isListArticle', DbType.integer),
      SqfEntityField('articleType', DbType.text),
    ]);

const scannedArticleTable = SqfEntityTable(
    tableName: 'scannedArticle',
    primaryKeyName: 'articleNumber',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('invoiceDate', DbType.text, isPrimaryKeyField: true),
      SqfEntityField('beat', DbType.text, isPrimaryKeyField: true),
      SqfEntityField('batch', DbType.text, isPrimaryKeyField: true),
      SqfEntityField('invoicedDate', DbType.text),
      SqfEntityField('facilityID', DbType.text),
      SqfEntityField('invoiceTime', DbType.text),
      SqfEntityField('postmanID', DbType.text),
      SqfEntityField('articleType', DbType.text),
      SqfEntityField('articleStatus', DbType.text),
      SqfEntityField('remarkDate', DbType.text),
      SqfEntityField('reasonCode', DbType.text),
      SqfEntityField('actionCode', DbType.text),
      SqfEntityField('addressee', DbType.text),
      SqfEntityField('deliveredTo', DbType.text),
      SqfEntityField('addresseeType', DbType.text),
      SqfEntityField('latitude', DbType.text),
      SqfEntityField('longitude', DbType.text),
      SqfEntityField('isLTM', DbType.integer),
      SqfEntityField('isListArticle', DbType.integer),
      SqfEntityField('listCode', DbType.text),
      SqfEntityField('customerId', DbType.text),
      SqfEntityField('epds', DbType.integer),
      SqfEntityField('boxID', DbType.text),
      SqfEntityField('isCommunicated', DbType.integer),
      SqfEntityField('remarkTime', DbType.text),
      SqfEntityField('postman', DbType.text),
      SqfEntityField('deviceID', DbType.text),
      SqfEntityField('rubberStamp', DbType.blob),
      SqfEntityField('signature', DbType.blob),
      SqfEntityField('sync_time', DbType.text),
      SqfEntityField("sofficeid", DbType.text),
      SqfEntityField("dofficeid", DbType.text),
      SqfEntityField("bookdate", DbType.datetime),
      SqfEntityField("bookid", DbType.text),
      SqfEntityField("insurance", DbType.text),
      SqfEntityField("moneytocollect", DbType.integer),
      SqfEntityField("moneycollected", DbType.integer),
      SqfEntityField("commission", DbType.integer),
      SqfEntityField("moneytodeliver", DbType.integer),
      SqfEntityField("moneydelivered", DbType.integer),
      SqfEntityField("windowdelivery", DbType.text),
      SqfEntityField("totmoney", DbType.integer),
      SqfEntityField("vpp", DbType.text),
      SqfEntityField("redirectpin", DbType.integer),
      SqfEntityField("modpin", DbType.integer),
      SqfEntityField("sourcepin", DbType.integer),
      SqfEntityField("destpin", DbType.integer),
      SqfEntityField("emomessage", DbType.text),
      SqfEntityField("cashreturned", DbType.integer),
      SqfEntityField('cod', DbType.text),
      SqfEntityField('receiver', DbType.text),
    ]);

const tempemotable = SqfEntityTable(
    tableName: 'EMOTable',
    primaryKeyName: 'SNo',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField("artNo", DbType.text),
    ]);

const articleType = SqfEntityTable(
    tableName: 'ARTICLETYPEMASTER',
    primaryKeyName: 'sno',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('material', DbType.text),
      SqfEntityField('description', DbType.text),
      SqfEntityField('category', DbType.text),

    ]);


@SqfEntityBuilder(articleModel)
const articleModel = SqfEntityModel(
    modelName: 'articleModel',
    password: '!@w"N,oR8!hD]*',
    databaseName: 'article.db',
    // dbVersion: 1,
    databaseTables: [
      nonDeliveryReasonsTable,
      scannedArticleTable,
      artRetTable,
      articleReturnTable,
      takeReturnArticleTable,
      takeArticleReturnTable,
      tablelogin,
      tempemotable,
      articleType
    ],
    // bundledDatabasePath: null
    // bundledDatabasePath: 'assets/article.db'
);
