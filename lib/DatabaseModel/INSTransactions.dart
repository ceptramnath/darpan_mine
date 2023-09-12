import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'INSTransactions.g.dart';

const officeModel = SqfEntityTable(
    tableName: 'officeDetails',
    primaryKeyName: 'SNo',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('BOOFFICETYPE', DbType.text),
      SqfEntityField('dateTime', DbType.text),
      SqfEntityField('BOOFFICECODE', DbType.text),
      SqfEntityField('COOFFICETYPE', DbType.text),
      SqfEntityField('HOOFFICEADDRESS', DbType.text),
      SqfEntityField('HOOFFICECODE', DbType.text),
      SqfEntityField('HOOFFICETYPE', DbType.text),
      SqfEntityField('BOOFFICEADDRESS', DbType.text),
      SqfEntityField('OFFICECODE_6', DbType.text),
      SqfEntityField('OFFICECODE_4', DbType.text),
      SqfEntityField('OFFICECODE_5', DbType.text),
      SqfEntityField('OFFICECODE_2', DbType.text),
      SqfEntityField('OFFICECODE_3', DbType.text),
      SqfEntityField('OFFICECODE_1', DbType.text),
      SqfEntityField('POCode', DbType.text),
      SqfEntityField('OFFICETYPE_3', DbType.text),
      SqfEntityField('OFFICEADDRESS_4', DbType.text),
      SqfEntityField('OFFICEADDRESS_3', DbType.text),
      SqfEntityField('OFFICETYPE_4', DbType.text),
      SqfEntityField('OFFICETYPE_1', DbType.text),
      SqfEntityField('OFFICEADDRESS_6', DbType.text),
      SqfEntityField('OFFICETYPE_2', DbType.text),
      SqfEntityField('OFFICEADDRESS_5', DbType.text),
      SqfEntityField('COOFFICEADDRESS', DbType.text),
      SqfEntityField('OFFICEADDRESS_2', DbType.text),
      SqfEntityField('OFFICETYPE_5', DbType.text),
      SqfEntityField('COOFFICECODE', DbType.text),
      SqfEntityField('OFFICEADDRESS_1', DbType.text),
      SqfEntityField('OFFICETYPE_6', DbType.text),
    ]);

const insmodel = SqfEntityTable(
    tableName: 'ins_transactions',
    primaryKeyName: 'SNo',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('policyNumber', DbType.text),
      SqfEntityField('tranType', DbType.text),
      SqfEntityField('policyType', DbType.text),
      SqfEntityField('amount', DbType.text),
      SqfEntityField('tranDate', DbType.text),
      SqfEntityField('tranTime', DbType.text),
    ]);

const dailyindexingr = SqfEntityTable(
    tableName: 'DAILY_INDEXING_REPORT',
    primaryKeyName: 'RECEIPT_NUM',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('TRAN_DATE', DbType.text),
      SqfEntityField('POLICY_NO', DbType.text),
      SqfEntityField('PROPOSAL_NUM', DbType.text),
      SqfEntityField('R_CRE_TIME', DbType.text),
      SqfEntityField('CREATED_DATE', DbType.text),
      SqfEntityField('POLICY_TYPE', DbType.text, isNotNull: true),
      SqfEntityField('OPERATOR_ID', DbType.text, isNotNull: true),
      SqfEntityField('REQ_TYPE', DbType.text, isNotNull: true),
      SqfEntityField('FUTURE_USE_1', DbType.text),
      SqfEntityField('FUTURE_USE_2', DbType.text),
      SqfEntityField('FUTURE_USE_3', DbType.text),
      SqfEntityField('FUTURE_USE_4', DbType.text),
      SqfEntityField('FUTURE_USE_5', DbType.text),
      SqfEntityField('FUTURE_USE_6', DbType.text),
      SqfEntityField('FUTURE_USE_7', DbType.text),
      SqfEntityField('GSTN_ID', DbType.text),
    ]);

const daiyIndexingr = SqfEntityTable(
    tableName: 'DAY_INDEXING_REPORT',
    primaryKeyName: 'RECEIPT_NO',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('POLICY_NO', DbType.text),
      SqfEntityField('PROPOSAL_NUM', DbType.text),
      SqfEntityField('R_CRE_TIME', DbType.text),
      SqfEntityField('POLICY_TYPE', DbType.text, isNotNull: true),
      SqfEntityField('TRAN_TYPE', DbType.text, isNotNull: true),
      SqfEntityField('OPERATOR_ID', DbType.text, isNotNull: true),
      SqfEntityField('AMOUNT', DbType.text, isNotNull: true),
      SqfEntityField('CREATED_DATE', DbType.text),
      SqfEntityField('FUTURE_USE_1', DbType.text),
      SqfEntityField('FUTURE_USE_2', DbType.text),
      SqfEntityField('FUTURE_USE_3', DbType.text),
      SqfEntityField('FUTURE_USE_4', DbType.text),
      SqfEntityField('FUTURE_USE_5', DbType.text),
      SqfEntityField('FUTURE_USE_6', DbType.text),
      SqfEntityField('FUTURE_USE_7', DbType.text),
    ]);

const dtr = SqfEntityTable(
    tableName: 'DAY_TRANSACTION_REPORT',
    primaryKeyName: 'RECEIPT_NO',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('STATUS', DbType.text),
      SqfEntityField('TRAN_ID', DbType.text),
      SqfEntityField('FROM_DATE', DbType.text),
      SqfEntityField('TO_DATE', DbType.text),
      SqfEntityField('TRAN_PAYMENT_TYPE', DbType.text),
      SqfEntityField('POLICY_NO', DbType.text),
      SqfEntityField('PROPOSAL_NUM', DbType.text),
      SqfEntityField('R_CRE_TIME', DbType.text),
      SqfEntityField('POLICY_TYPE', DbType.text),
      SqfEntityField('TRAN_TYPE', DbType.text),
      SqfEntityField('TRAN_DATE', DbType.text),
      SqfEntityField('OPERATOR_ID', DbType.text),
      SqfEntityField('AMOUNT', DbType.text),
      SqfEntityField('INTIAL_AMOUNT', DbType.text),
      SqfEntityField('RENEWAL_AMOUNT', DbType.text),
      SqfEntityField('CREATED_DATE', DbType.text),
      SqfEntityField('I_CGST', DbType.text),
      SqfEntityField('I_SGST', DbType.text),
      SqfEntityField('I_UGST', DbType.text),
      SqfEntityField('R_CGST', DbType.text),
      SqfEntityField('R_SGST', DbType.text),
      SqfEntityField('R_UGST', DbType.text),
      SqfEntityField('REBATE', DbType.text),
      SqfEntityField('BAL_AMT', DbType.text),
      SqfEntityField('PAYMENT_MODE', DbType.text),
      SqfEntityField('CGST', DbType.text),
      SqfEntityField('SGST', DbType.text),
      SqfEntityField('UGST', DbType.text),
      SqfEntityField('TOTAL_GST', DbType.text),
      SqfEntityField('GSTN_ID', DbType.text),
      SqfEntityField('PAYMENT_CATEGORY', DbType.text),
      SqfEntityField('PREM_AMNT', DbType.text),
      SqfEntityField('DEFAULT_FEE', DbType.text),
    ]);

const inserrors = SqfEntityTable(
    tableName: 'INS_ERROR_CODES',
    primaryKeyName: 'SNo',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('Error_code', DbType.text),
      SqfEntityField('Error_message', DbType.text),
    ]);
const inscirclecodes = SqfEntityTable(
    tableName: 'INS_CIRCLE_CODES',
    primaryKeyName: 'SNo',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
          SqfEntityField('Circle_code', DbType.text),
          SqfEntityField('CO_CODE', DbType.text),
    ]);

@SqfEntityBuilder(tranModel)
const tranModel = SqfEntityModel(
    modelName: 'insTran',
    databaseName: 'insTrans.db',
    password: 'xGyZEr8l@loiuy',
    databaseTables: [
      dailyindexingr,
      daiyIndexingr,
      dtr,      insmodel,
      officeModel,
      inserrors,
          inscirclecodes
    ]);
