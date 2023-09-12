import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:http/http.dart' as http;

part 'cbsdb.g.dart';

const TRAN_DETAILS = SqfEntityTable(
    tableName: 'TBCBS_TRAN_DETAILS',
    primaryKeyName: 'TRANSACTION_ID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('CUST_ACC_NUM', DbType.text),
      SqfEntityField('REFERENCE_NO', DbType.text),
      SqfEntityField('OFFICE_ACC_NUM', DbType.text),
      SqfEntityField('ACCOUNT_TYPE', DbType.text),
      SqfEntityField('MAIN_HOLDER_NAME', DbType.text),
      SqfEntityField('MAIN_HOLDER_CIFID', DbType.text),
      SqfEntityField('JOINT_HOLDER1_NAME', DbType.text),
      SqfEntityField('JOINT_HOLDER1_CIFID', DbType.text),
      SqfEntityField('JOINT_HOLDER2_NAME', DbType.text),
      SqfEntityField('JOINT_HOLDER2_CIFID', DbType.text),
      SqfEntityField('TRANSACTION_AMT', DbType.text),
      SqfEntityField('CURRENCY', DbType.text),
      SqfEntityField('TENURE', DbType.text),
      SqfEntityField('REMARKS', DbType.text),
      SqfEntityField('TRAN_TYPE', DbType.text),
      SqfEntityField('TRAN_DATE', DbType.text),
      SqfEntityField('TRAN_TIME', DbType.text),
      SqfEntityField('FIN_SOLBOD_DATE', DbType.text),
      SqfEntityField('MODE_OF_TRAN', DbType.text),
      SqfEntityField('SCHEME_TYPE', DbType.text),
      SqfEntityField('INSTALMENT_AMT', DbType.text),
      SqfEntityField('NO_OF_INSTALMENTS', DbType.text),
      SqfEntityField('REBATE_AMT', DbType.text),
      SqfEntityField('DEFAULT_FEE', DbType.text),
      SqfEntityField('APPR_STATUS', DbType.text),
      SqfEntityField('TENURE_INW', DbType.text),
      SqfEntityField('R_CRE_TIME', DbType.text),
      SqfEntityField('R_MOD_TIME', DbType.text),
      SqfEntityField('OPERATOR_ID', DbType.text),
      SqfEntityField('MINOR_FLAG', DbType.text),
      SqfEntityField('GUARDIAN_CIFID', DbType.text),
      SqfEntityField('GUARDIAN_NAME', DbType.text),
      SqfEntityField('MINOR_DOB', DbType.text),
      SqfEntityField('GUARDIAN_RELATION', DbType.text),
      SqfEntityField('DEVICE_TRAN_ID', DbType.text),
      SqfEntityField('STATUS', DbType.text),
      SqfEntityField('DEVICE_TRAN_TYPE', DbType.text),
      SqfEntityField('REQUEST_DATE', DbType.text),
      SqfEntityField('FUTURE_USE_1', DbType.text),
      SqfEntityField('FUTURE_USE_2', DbType.text),
      SqfEntityField('FUTURE_USE_3', DbType.text),
      SqfEntityField('FUTURE_USE_4', DbType.text),
    ]);

const SOL_DETAILS = SqfEntityTable(
    tableName: 'TBCBS_SOL_DETAILS',
    primaryKeyName: 'BO_ID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('SOL_ID', DbType.text),
      SqfEntityField('SOL_DESC', DbType.text),
      SqfEntityField('R_CRE_TIME', DbType.text),
      SqfEntityField('R_MOD_TIME', DbType.text),
      SqfEntityField('OPERATOR_ID', DbType.text),
      SqfEntityField('FUTURE_USE_1', DbType.text),
      SqfEntityField('FUTURE_USE_2', DbType.text),
      SqfEntityField('FUTURE_USE_3', DbType.text),
      SqfEntityField('FUTURE_USE_4', DbType.text),
    ]);

const CONFIG_DETAILS = SqfEntityTable(
    tableName: 'TBCBS_CONFIG_DETAILS',
    primaryKeyName: 'CONFIG_NAME',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('CONFIG_VALUE', DbType.text),
      SqfEntityField('R_CRE_TIME', DbType.text),
      SqfEntityField('R_MOD_TIME', DbType.text),
      SqfEntityField('OPERATOR_ID', DbType.text),
      SqfEntityField('FUTURE_USE_1', DbType.text),
      SqfEntityField('FUTURE_USE_2', DbType.text),
      SqfEntityField('FUTURE_USE_3', DbType.text),
      SqfEntityField('FUTURE_USE_4', DbType.text),
    ]);

const EXCEP_DETAILS = SqfEntityTable(
    tableName: 'TBCBS_EXCEP_DETAILS',
    primaryKeyName: 'REQUEST_NUMBER',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('REQUEST_DATE', DbType.text),
      SqfEntityField('ACCOUNT_NUMBER', DbType.text),
      SqfEntityField('REQUEST_STATUS', DbType.text),
      SqfEntityField('R_CRE_TIME', DbType.text),
      SqfEntityField('R_MOD_TIME', DbType.text),
      SqfEntityField('OPERATOR_ID', DbType.text),
      SqfEntityField('FUTURE_USE_1', DbType.text),
      SqfEntityField('FUTURE_USE_2', DbType.text),
      SqfEntityField('FUTURE_USE_3', DbType.text),
      SqfEntityField('FUTURE_USE_4', DbType.text),
    ]);

const IPPBTRAN_DETAILS = SqfEntityTable(
    tableName: 'IPPBCBS_DETAILS',
    primaryKeyName: 'TRANSACTION_DATE',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('TRANSACTION_TIME', DbType.text),
      SqfEntityField('TOTAL_DEPOSITS', DbType.text),
      SqfEntityField('TOTAL_DEPOSIT_AMOUNT', DbType.text),
      SqfEntityField('TOTAL_WITHDRAWALS', DbType.text),
      SqfEntityField('TOTAL_WITHDRAWAL_AMOUNT', DbType.text),
          SqfEntityField('Remarks', DbType.text),
    ]);
const LEAVETRAN_DETAILS = SqfEntityTable(
    tableName: 'LEAVE_DETAILS',
    primaryKeyName: 'REQUEST_ID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('GDS_ID', DbType.text),
      SqfEntityField('GENDER', DbType.text),
      SqfEntityField('TYPE_OF_LEAVE', DbType.text),
      SqfEntityField('LEAVE_REASON', DbType.text),
      SqfEntityField('LEAVE_FROM_DATE', DbType.text),
      SqfEntityField('LEAVE_TO_DATE', DbType.text),
      SqfEntityField('EMP_ADDRESS1', DbType.text),
      SqfEntityField('EMP_ADDRESS2', DbType.text),
      SqfEntityField('SUBSTITUTE_ID', DbType.text),
      SqfEntityField('SUBSTITUTE_NAME', DbType.text),
      SqfEntityField('SUBSTITUTE_ADDRESS1', DbType.text),
      SqfEntityField('SUBSTITUTE_ADDRESS2', DbType.text),
      SqfEntityField('SUBSTITUTE_AGE', DbType.text),
      SqfEntityField('SUBSTITUTE_QUALIFICATION', DbType.text),
      SqfEntityField('STATUS', DbType.text),
    ]);

const cbslimits = SqfEntityTable(
    tableName: 'CBS_LIMITS_CONFIG',
    primaryKeyName: 'type',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('tranlimits', DbType.text),
    ]);

const cbserrors = SqfEntityTable(
    tableName: 'CBS_ERROR_CODES',
    primaryKeyName: 'Error_code',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('Error_message', DbType.text),
    ]);

@SqfEntityBuilder(reportModel)
const reportModel =
    SqfEntityModel(modelName: 'CBS', databaseName: 'CBS.db',
        password: 'kzWp#E37Xj49wL',
        databaseTables: [
  TRAN_DETAILS,
  SOL_DETAILS,
  CONFIG_DETAILS,
  EXCEP_DETAILS,
  IPPBTRAN_DETAILS,
  LEAVETRAN_DETAILS,
  cbserrors,
  cbslimits,
]);
