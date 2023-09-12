import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'DarpanDBModel.g.dart';

const tableDelivery = SqfEntityTable(
    tableName: 'Delivery',
    primaryKeyName: 'ART_NUMBER',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      // SqfEntityField("ART_NUMBER",DbType.text,isPrimaryKeyField: true),
      SqfEntityField("invoiceDate", DbType.text),
      SqfEntityField("invoiced", DbType.text),
      SqfEntityField("SOFFICE_ID ", DbType.text),
      SqfEntityField("DOFFICE_ID", DbType.text),
      SqfEntityField("BOOK_DATE", DbType.text),
      SqfEntityField("BOOK_ID", DbType.text),
      SqfEntityField("LINE_ITEM", DbType.real),
      SqfEntityField("BAG_ID", DbType.text),
      SqfEntityField("INSURANCE", DbType.text),
      SqfEntityField("ON_HOLD", DbType.text),
      SqfEntityField("HOLD_DATE", DbType.date),
      SqfEntityField("HOLD_TILL_DATE", DbType.date),
      SqfEntityField("PENSIONER_ID", DbType.text),
      SqfEntityField("REASON_FOR_NONDELIVERY", DbType.text),
      SqfEntityField("REASON_TYPE", DbType.text),
      SqfEntityField("ACTION", DbType.text),
      SqfEntityField("MONEY_TO_BE_COLLECTED", DbType.real),
      SqfEntityField("MONEY_COLLECTED", DbType.real, defaultValue: 0),
      SqfEntityField("POST_DUE", DbType.real),
      SqfEntityField("DEM_CHARGE", DbType.real),
      SqfEntityField("COMMISSION", DbType.real),
      SqfEntityField("MONEY_TO_BE_DELIVERED", DbType.real),
      SqfEntityField("MONEY_DELIVERED", DbType.real),
      SqfEntityField("NO_OF_HOLD_DAYS", DbType.real),
      SqfEntityField("DATE_OF_DELIVERY", DbType.date),
      SqfEntityField("DATE_OF_DELIVERY_CONFIRM", DbType.date),
      SqfEntityField("TIME_OF_DELIVERY_CONFIRM", DbType.datetime),
      SqfEntityField("DATE_OF_1ST_DELIVERY_CONFIRM", DbType.date),
      SqfEntityField("DATE_OF_2ND_DELIVERY_CONFIRM", DbType.date),
      SqfEntityField("DATE_OF_3RD_DELIVERY_CONFIRM", DbType.date),
      SqfEntityField("DELIVERY_TIME", DbType.datetime),
      SqfEntityField("DEL_DATE", DbType.date),
      SqfEntityField("ID_PROOF_DOC", DbType.text),
      SqfEntityField("ID_PROOF_NMBR", DbType.text),
      SqfEntityField("ISSUING_AUTHORITY", DbType.text),
      SqfEntityField("ID_PROOF_VALIDITY_DATE", DbType.date),
      SqfEntityField("WINDOW_DELIVERY", DbType.text),
      SqfEntityField("REDIRECTION_FEE", DbType.real),
      SqfEntityField("RETRN_DATE", DbType.date),
      SqfEntityField("RETRN_TIME", DbType.datetime),
      SqfEntityField("BEAT_NO", DbType.text),
      SqfEntityField("PERNR", DbType.real),
      SqfEntityField("ART_STATUS", DbType.text),
      SqfEntityField("ART_RECEIVE_DATE", DbType.text),
      SqfEntityField("ART_RECEIVE_TIME", DbType.text),
      SqfEntityField("REMARKS", DbType.text),
      SqfEntityField("ZCONDITION", DbType.text),
      SqfEntityField("TOTAL_MONEY", DbType.real),
      SqfEntityField("POSTAGE_NOT_COLLECTED", DbType.real),
      SqfEntityField("MOP", DbType.text),
      SqfEntityField("VPP", DbType.text),
      SqfEntityField("BATCH_ID", DbType.text),
      SqfEntityField("SHIFT_NO", DbType.text),
      SqfEntityField("RET_RCL_RDL_STOPDELV_STATUS2", DbType.text),
      SqfEntityField("TYPE_OF_PAYEE", DbType.text),
      SqfEntityField("REDIRECT_PIN", DbType.integer),
      SqfEntityField("MOD_PIN", DbType.integer),
      SqfEntityField("SOURCE_PINCODE", DbType.integer),
      SqfEntityField("DESTN_PINCODE", DbType.integer),
      SqfEntityField("EMO_MESSAGE", DbType.text),
      SqfEntityField("REGISTERED", DbType.text),
      SqfEntityField("RETURN_SERVICE", DbType.text),
      SqfEntityField("COD", DbType.text),
      SqfEntityField("RT", DbType.text),
      SqfEntityField("RT_DATE", DbType.date),
      SqfEntityField("RT_TIME", DbType.datetime),
      SqfEntityField("RD", DbType.text),
      SqfEntityField("RD_DATE", DbType.date),
      SqfEntityField("RD_TIME", DbType.datetime),
      SqfEntityField("SP", DbType.text),
      SqfEntityField("SP_DATE", DbType.date),
      SqfEntityField("SP_TIME", DbType.datetime),
      SqfEntityField("POSTE_RESTANTE", DbType.text),
      SqfEntityField("BO_ID", DbType.text),
      SqfEntityField("LAST_CHANGED_USER", DbType.text),
      SqfEntityField("BELNR", DbType.text),
      SqfEntityField("ALREADY_RTN_FLAG", DbType.text),
      SqfEntityField("ALREADY_RD_FLAG", DbType.text),
      SqfEntityField("REDIRECT_BO_ID", DbType.text),
      SqfEntityField("IFS_SOFFICE_NAME", DbType.text),
      SqfEntityField("CHECT", DbType.text),
      SqfEntityField("TREASURY_SUBMIT_DONE", DbType.text),
      SqfEntityField("TREASURY_SUBMIT_DATE", DbType.date),
      SqfEntityField("REDIRECTION_SL", DbType.real),
      SqfEntityField("TRANSACTION_DATE", DbType.date),
      SqfEntityField("TRANSACTION_TIME", DbType.datetime),
      SqfEntityField("IS_COMMUNICATED", DbType.text),
      SqfEntityField("IS_PREVIOUS_DAY_DEPOSIT", DbType.text),
      SqfEntityField("E_PROOF", DbType.text),
      SqfEntityField("MATNR", DbType.text),
      SqfEntityField("CASH_ID", DbType.text),
      SqfEntityField("REMARK_DATE", DbType.date),
      SqfEntityField("CASH_RETURNED", DbType.text),
      SqfEntityField("FILE_NAME", DbType.text),
      SqfEntityField("REPORTING_SO_ID", DbType.text),
      SqfEntityField("despatchStatus", DbType.text),
      SqfEntityField("CUST_DUTY", DbType.real),
      SqfEntityField("BO_SLIP", DbType.text),
      SqfEntityField("ZIP_FILE_NAME", DbType.text),
    ]);

const tableAddress = SqfEntityTable(
    tableName: 'Address',
    primaryKeyName: 'ART_NUMBER',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('SEND_CUST_N ', DbType.text),
      SqfEntityField('SEND_ADD1', DbType.text),
      SqfEntityField('SEND_ADD2', DbType.text),
      SqfEntityField('SEND_ADD3', DbType.text),
      SqfEntityField('SEND_STREET', DbType.text),
      SqfEntityField('SEND_CITY', DbType.text),
      SqfEntityField('SEND_COUNTRY', DbType.text),
      SqfEntityField('SEND_STATE', DbType.text),
      SqfEntityField('SEND_EMAIL', DbType.text),
      SqfEntityField('SEND_PIN', DbType.integer),
      SqfEntityField('SEND_FAX', DbType.text),
      SqfEntityField('SEND_MOB', DbType.text),
      SqfEntityField('REC_NAME', DbType.text),
      SqfEntityField('REC_ADDRESS1', DbType.text),
      SqfEntityField('REC_ADDRESS2', DbType.text),
      SqfEntityField('REC_ADDRESS3', DbType.text),
      SqfEntityField('REC_COUNTRY', DbType.text),
      SqfEntityField('REC_STATE', DbType.text),
      SqfEntityField('REC_STREET', DbType.text),
      SqfEntityField('REC_CITY', DbType.text),
      SqfEntityField('REC_PIN', DbType.integer),
      SqfEntityField('MOD_PIN', DbType.real),
      SqfEntityField('REC_MOB', DbType.text),
      SqfEntityField('REC_EMAIL', DbType.text),
      SqfEntityField('REC_FAX', DbType.text),
      SqfEntityField('RECIPIENT_NAME', DbType.text),
      SqfEntityField('REDIRECT_REC_ADD1', DbType.text),
      SqfEntityField('REDIRECT_REC_ADD2', DbType.text),
      SqfEntityField('REDIRECT_REC_ADD3', DbType.text),
      SqfEntityField('REDIRECT_REC_STREET', DbType.text),
      SqfEntityField('REDIRECT_REC_CITY', DbType.text),
      SqfEntityField('REDIRECT_REC_COUNTRY', DbType.text),
      SqfEntityField('REDIRECT_REC_STATE', DbType.text),
      SqfEntityField('REDIRECT_REC_PIN', DbType.real),
      SqfEntityField('REDIRECT_REC_MOB', DbType.real),
      SqfEntityField('REDIRECT_REC_EMAIL', DbType.text),
      SqfEntityField('REDIRECT_REC_FAX', DbType.text),
      SqfEntityField('REDIRECT_FROM_PIN', DbType.real),
      SqfEntityField('REDIRECT_FROM_BO_ID', DbType.text),
      SqfEntityField('BOOK_ID', DbType.text),
      SqfEntityField('BAG_ID', DbType.text),
      SqfEntityField('BO_SLIP', DbType.text),
    ]);

const tableArticleMaster = SqfEntityTable(
    tableName: 'ARTICLEMASTER',
    primaryKeyName: 'SNo',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('ARTICLETYPE', DbType.text),
      SqfEntityField('ARTICLECODE', DbType.text),
    ]);

const tableReasons = SqfEntityTable(
    tableName: 'Reason',
    primaryKeyName: 'SNo',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('MANDT', DbType.text),
      SqfEntityField('SERIAL', DbType.real),
      SqfEntityField('REASON_FOR_NDELI', DbType.text),
      SqfEntityField('APPLICABLE_FOR', DbType.text),
      SqfEntityField('REASON_TYPE', DbType.text),
      SqfEntityField('ACTION', DbType.text),
      SqfEntityField('REASON_NDEL_TEXT', DbType.text),
      SqfEntityField('APPL_FOR_TEXT', DbType.text),
      SqfEntityField('REASON_TYPE_TEXT', DbType.text),
      SqfEntityField('ACTION_TEXT', DbType.text),
      SqfEntityField('DELE_FLAG', DbType.text),
    ]);

const tablereceivedarticleDetails = SqfEntityTable(
    tableName: 'RECEIVEDARTDETAILS',
    primaryKeyName: 'SNo',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('ART_NUMBER', DbType.text),
      SqfEntityField('BAGNUMBER', DbType.text),
      SqfEntityField('ART_RECEIVE_DATE', DbType.date),
      SqfEntityField('ART_RECEIVE_TIME', DbType.datetime),
      SqfEntityField('MATNR', DbType.text),
      SqfEntityField('IS_COMMUNICATED', DbType.text),
      SqfEntityField('FILE_NAME', DbType.text),
    ]);

const tablelogin = SqfEntityTable(
    tableName: 'Login',
    primaryKeyName: 'SNo',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('IMEI', DbType.text),
      SqfEntityField('empName', DbType.text),
      SqfEntityField('empId', DbType.text),
      SqfEntityField('mobile', DbType.text),
      SqfEntityField('pincode', DbType.text),
      SqfEntityField('facilityID', DbType.text),
      SqfEntityField('digitalToken', DbType.text),
    ]);

const tabledespatch = SqfEntityTable(
    tableName: 'DESPATCHBAG',
    primaryKeyName: 'SNo',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('SCHEDULE', DbType.text),
      SqfEntityField('SCHEDULED_TIME', DbType.text),
      SqfEntityField('MAILLIST_TO_OFFICE', DbType.text),
      SqfEntityField('BAGNUMBER', DbType.text),
      SqfEntityField('FROM_OFFICE', DbType.text),
      SqfEntityField('TO_OFFICE', DbType.text),
      SqfEntityField('CLOSING_DATE', DbType.text),
      SqfEntityField('REMARKS', DbType.text),
      SqfEntityField('IS_COMMUNICATED', DbType.text),
      SqfEntityField('IS_RCVD', DbType.text),
    ]);

const tablebostamp = SqfEntityTable(
    tableName: 'BOSLIP_STAMP1',
    primaryKeyName: 'SNo',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('BO_SLIP_NO', DbType.text),
      SqfEntityField('ZMOFACILITYID', DbType.text),
      SqfEntityField('MATNR', DbType.text),
      SqfEntityField('ZINV_PARTICULAR', DbType.text),
      SqfEntityField('MENGE_D', DbType.text),
      SqfEntityField('ZCREATEDT', DbType.text),
      SqfEntityField('ZMOCREATEDBY', DbType.text),
      SqfEntityField('IS_RCVD', DbType.text),
      SqfEntityField('IS_COMMUNICATED', DbType.text),
    ]);
const tablebocash = SqfEntityTable(
    tableName: 'BOSLIP_CASH1',
    primaryKeyName: 'SNo',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('BO_SLIP_NO', DbType.text),
      SqfEntityField('DATE_OF_SENT', DbType.text),
      SqfEntityField('SO_PROFIT_CENTER', DbType.text),
      SqfEntityField('BO_PROFIT_CENTER', DbType.text),
      SqfEntityField('AMOUNT', DbType.text),
      SqfEntityField('WEIGHT_OF_CASH_BAG', DbType.text),
      SqfEntityField('CHEQUE_NO', DbType.text),
      SqfEntityField('CHEQUE_AMOUNT', DbType.text),
      SqfEntityField('CASHORCHEQUE', DbType.text),
      SqfEntityField('LESS_CASH', DbType.text),
      SqfEntityField('OVER_CASH', DbType.text),
      SqfEntityField('ACTUAL_CASH', DbType.text),
      SqfEntityField('IS_RCVD', DbType.text),
      SqfEntityField('IS_COMMUNICATED', DbType.text),
    ]);

const tableboslipdoc = SqfEntityTable(
    tableName: 'BOSLIP_DOCUMENT1',
    primaryKeyName: 'SNo',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('BO_SLIP_NO', DbType.text),
      SqfEntityField('DOCUMENT_DETAILS', DbType.text),
      SqfEntityField('FROMOFFICE', DbType.text),
      SqfEntityField('TOOFFICE', DbType.text),
      SqfEntityField('IS_RCVD', DbType.text),
      SqfEntityField('IS_COMMUNICATED', DbType.text),
    ]);

const tablebsrdetails = SqfEntityTable(
    tableName: 'BSRDETAILS_NEW',
    primaryKeyName: 'SNo',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('BOSLIPID', DbType.text),
      SqfEntityField('BAGNUMBER', DbType.text),
      SqfEntityField('RECEIVEDATE', DbType.text),
      SqfEntityField('BO_SLIP_DATE', DbType.text),
      SqfEntityField('CLOSING_BALANCE', DbType.text),
      SqfEntityField('CB_DATE', DbType.text),
      SqfEntityField('IS_COMMUNICATED', DbType.text),
      SqfEntityField('CASH_STATUS', DbType.text),
      SqfEntityField('STAMP_STATUS', DbType.text),
      SqfEntityField('DOCUMENT_STATUS', DbType.text),
    ]);

const tablebagdetails = SqfEntityTable(
    tableName: 'BAGDETAILS_NEW',
    primaryKeyName: 'SNo',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('FROMOFFICE', DbType.text),
      SqfEntityField('TOOFFICE', DbType.text),
      SqfEntityField('TDATE', DbType.text),
      SqfEntityField('TIME', DbType.text),
      SqfEntityField('USERID', DbType.text),
      SqfEntityField('BAGNUMBER', DbType.text),
      SqfEntityField('BAGSTATUS', DbType.text),
      SqfEntityField('BOTDATE', DbType.text),
      SqfEntityField('IS_RCVD', DbType.text),
      SqfEntityField('IS_COMMUNICATED', DbType.text),
      SqfEntityField('BOSLIPNO', DbType.text),
      SqfEntityField('NO_OF_ARTICLES', DbType.text),
    ]);
const tablefilesyncdetails = SqfEntityTable(
    tableName: 'FILE_SYNC_DETAILS',
    primaryKeyName: 'CLIENT_TRANSACTION_ID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('FILE_NAME', DbType.text),
      SqfEntityField('ZIP_FILE_NAME', DbType.text, isIndex: true),
      SqfEntityField('FILE_PATH', DbType.text),
      SqfEntityField('SERVICE', DbType.text),
      SqfEntityField('STATUS', DbType.text),
      SqfEntityField('LAST_UPDATED_DT', DbType.text),
      SqfEntityField('PROCESSED', DbType.text),
    ]);
const VPMO = SqfEntityTable(
    tableName: 'VPPEMO',
    primaryKeyName: 'Sl',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
          SqfEntityField('VP_ART', DbType.text),
          SqfEntityField("MONEY_TO_BE_COLLECTED", DbType.real),
          SqfEntityField("COMMISSION", DbType.real),
          SqfEntityField("DATE_OF_DELIVERY", DbType.text),
          SqfEntityField('EMO_NUMBER', DbType.text),
          SqfEntityField('REMARKS', DbType.text),
    ]);
@SqfEntityBuilder(deliveryModel)
const deliveryModel = SqfEntityModel(
  modelName: 'DeliveryModel',
  databaseName: 'delivery.db',
  password: '9VlW]<nK27c)f)',
  // dbVersion: 1,
  databaseTables: [
    tableDelivery,
    tableAddress,
    tableReasons,
    tablereceivedarticleDetails,
    tableArticleMaster,
    tablelogin,
    tabledespatch,
    tablebostamp,
    tablebocash,
    tableboslipdoc,
    tablebsrdetails,
    tablebagdetails,
    tablefilesyncdetails,
        VPMO

  ],
  bundledDatabasePath: null,
  // databasePath: 'storage/emulated/0/Darpan_Mine/Databases',
);
