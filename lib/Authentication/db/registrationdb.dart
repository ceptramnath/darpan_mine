import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'registrationdb.g.dart';

const userdetails = SqfEntityTable(
    tableName: 'USERDETAILS',
    primaryKeyName: 'EMPID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('MobileNumber', DbType.text),
      SqfEntityField('IMEINumber', DbType.text),
      SqfEntityField('DeviceID', DbType.text),
      SqfEntityField('EmployeeEmail', DbType.text),
      SqfEntityField('EmployeeName', DbType.text),
      SqfEntityField('DOB', DbType.text),
      SqfEntityField('BOFacilityID', DbType.text),
      SqfEntityField('BOName', DbType.text),
      SqfEntityField('Pincode', DbType.text),
      SqfEntityField('DOName', DbType.text),
      SqfEntityField('DOCode', DbType.text),
      SqfEntityField('ClientID', DbType.text),
      SqfEntityField('AppToken', DbType.text),
    ]);

const UserLoginDetails = SqfEntityTable(
    tableName: 'USERLOGINDETAILS',
    primaryKeyName: 'EMPID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('MobileNumber', DbType.text),
      SqfEntityField('IMEINumber', DbType.text),
      SqfEntityField('DeviceID', DbType.text),
      SqfEntityField('EmployeeEmail', DbType.text),
      SqfEntityField('EmployeeName', DbType.text),
      SqfEntityField('Password', DbType.text),
      SqfEntityField('AccessToken', DbType.text),
      SqfEntityField('RefreshToken', DbType.text),
      SqfEntityField('Validity', DbType.text),
      SqfEntityField('DOVerified', DbType.text),
      SqfEntityField('Active', DbType.bool, defaultValue: false),
      SqfEntityField('ClientID', DbType.text),
      SqfEntityField('AppToken', DbType.text),
    ]);

const userValidation = SqfEntityTable(
    tableName: 'USERVALIDATION',
    primaryKeyName: 'EMPID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('MobileNumber', DbType.text),
      SqfEntityField('IMEINumber', DbType.text),
      SqfEntityField('DeviceID', DbType.text),
      SqfEntityField('EmployeeEmail', DbType.text),
      SqfEntityField('EmployeeName', DbType.text),
      SqfEntityField('Password', DbType.text),
      SqfEntityField('Pincode', DbType.text),
      SqfEntityField('OTPVerified', DbType.text),
      SqfEntityField('Active', DbType.bool, defaultValue: false),
    ]);

const ofcmasterdata = SqfEntityTable(
    tableName: 'OFCMASTERDATA',
    primaryKeyName: 'EMPID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('MobileNumber', DbType.text),
      SqfEntityField('EmployeeEmail', DbType.text),
      SqfEntityField('EmployeeName', DbType.text),
      SqfEntityField('DOB', DbType.text),
      SqfEntityField('BOFacilityID', DbType.text),
      SqfEntityField('BOName', DbType.text),
      SqfEntityField('EMOCODE', DbType.text),
      SqfEntityField('SOLID', DbType.text),
      SqfEntityField('Pincode', DbType.text),
      SqfEntityField('AOName', DbType.text),
      SqfEntityField('AOCode', DbType.text),
      SqfEntityField('DOName', DbType.text),
      SqfEntityField('DOCode', DbType.text),
      SqfEntityField('OB', DbType.text),
      SqfEntityField('CASHINHAND', DbType.text),
      SqfEntityField('MINBAL', DbType.text),
      SqfEntityField('MAXBAL', DbType.text),
      SqfEntityField('POSTAMPBAL', DbType.text),
      SqfEntityField('REVSTAMPBAL', DbType.text),
      SqfEntityField('CRFSTAMPBAL', DbType.text),
      SqfEntityField('MAILSCHEDULE', DbType.text),
      SqfEntityField('PAIDLEAVE', DbType.text),
      SqfEntityField('EMGLEAVE', DbType.text),
      SqfEntityField('MATERNITYLEAVE', DbType.text),
      SqfEntityField('ONETIMECUSTCODE', DbType.text),
          SqfEntityField('FUTURE_USE1', DbType.text),
          SqfEntityField('FUTURE_USE2', DbType.text),
          SqfEntityField('FUTURE_USE3', DbType.text),

    ]);

const fileCreation = SqfEntityTable(
    tableName: 'FILEMASTERDATA',
    primaryKeyName: 'FILETYPE',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('DIVISION', DbType.text),
      SqfEntityField('ORDERTYPE_SP', DbType.text),
      SqfEntityField('ORDERTYPE_LETTERPARCEL', DbType.text),
      SqfEntityField('ORDERTYPE_EMO', DbType.text),
      SqfEntityField('PRODUCT_TYPE', DbType.text),
      SqfEntityField('MATERIALGROUP_SP', DbType.text),
      SqfEntityField('MATERIALGROUP_LETTER', DbType.text),
      SqfEntityField('MATERIALGROUP_EMO', DbType.text),
    ]);

const PaySlipCreation = SqfEntityTable(
    tableName: 'PaySlipData',
    // primaryKeyName: 'EMPLOYEE_ID',
    // primaryKeyType: PrimaryKeyType.text,
    fields: [
          SqfEntityField('EMPLOYEE_ID', DbType.text,isPrimaryKeyField: true),
          SqfEntityField('EMPLOYEE_NAME', DbType.text),
          SqfEntityField('OFFICE', DbType.text),
          SqfEntityField('POSITION', DbType.text),
          SqfEntityField('MONTH', DbType.text,isPrimaryKeyField: true),
          SqfEntityField('YEAR', DbType.text,isPrimaryKeyField: true),
          SqfEntityField('ACCOUNT_NUMBER', DbType.text),
          SqfEntityField('TRCA', DbType.text),
          SqfEntityField('DEARNESS_ALLOWANCE', DbType.text),
          SqfEntityField('FIXED_STATIONERY_CHARGES', DbType.text),
          SqfEntityField('BOAT_ALLOWANCE', DbType.text),
          SqfEntityField('CYCLE_MAINTENANCE_ALLOWANCE', DbType.text),
          SqfEntityField('OFFICE_MAINTENANCE_ALLOWANCE', DbType.text),
          SqfEntityField('CDA', DbType.text),
          SqfEntityField('COMBINATION_DELIVERY_ALLOWANCE', DbType.text),
          SqfEntityField('COMPENSATION_MAIL_CARRIER', DbType.text),
          SqfEntityField('RETAINERSHIP_ALLOWANCE', DbType.text),
          SqfEntityField('CASH_CONVEYANCE_ALLOWANCE', DbType.text),
          SqfEntityField('PERSONAL_ALLOWANCE_GDS', DbType.text),
          SqfEntityField('BONUS_GDS', DbType.text),
          SqfEntityField('EXGRATIA_GRATUITY', DbType.text),
          SqfEntityField('SEVERANCE_AMOUNT', DbType.text),
          SqfEntityField('INCENTIVES', DbType.text),
          SqfEntityField('DA_ARREARS_GDS', DbType.text),
          SqfEntityField('TOTAL_EARNINGS', DbType.text),
          SqfEntityField('TRCA_ALLOWANCE_ARREARS', DbType.text),
          SqfEntityField('DEARNESS_ALLOWANCE_ARREAR', DbType.text),
          SqfEntityField('DEARNESS_RELIEF_CDAARREAR', DbType.text),
          SqfEntityField('TOTAL_ARREARS', DbType.text),
          SqfEntityField('COURT_ATTACHMENT_ODFM', DbType.text),
          SqfEntityField('RD', DbType.text),
          SqfEntityField('COURT_ATTACHMENT_DFM', DbType.text),
          SqfEntityField('LICENSE_FEE', DbType.text),
          SqfEntityField('SDBS', DbType.text),
          SqfEntityField('AUDIT_OFFICE_RECOVERY', DbType.text),
          SqfEntityField('COOP_CREDIT_SOCIETY', DbType.text),
          SqfEntityField('RELIEF_FUND', DbType.text),
          SqfEntityField('DEATH_RELIEF_FUND', DbType.text),
          SqfEntityField('WATER_TAX', DbType.text),
          SqfEntityField('ELECTRICITY_CHARGES', DbType.text),
          SqfEntityField('AOR_NONTAX', DbType.text),
          SqfEntityField('POSTAL_RELIEF_FUND', DbType.text),
          SqfEntityField('PLI_PREMIUM', DbType.text),
          SqfEntityField('RECREATION_CLUB', DbType.text),
          SqfEntityField('UNION_ASSOCIATION', DbType.text),
          SqfEntityField('WELFARE_FUND', DbType.text),
          SqfEntityField('CGEGIS', DbType.text),
          SqfEntityField('CGHS', DbType.text),
          SqfEntityField('EDAGIS_92', DbType.text),
          SqfEntityField('LIC_PREMIUM', DbType.text),
          SqfEntityField('CGIS', DbType.text),
          SqfEntityField('RPLI', DbType.text),
          SqfEntityField('PLI_SERVICE_TAX', DbType.text),
          SqfEntityField('CONNECTIONS', DbType.text),
          SqfEntityField('CGEWCC', DbType.text),
          SqfEntityField('SOCIETIES', DbType.text),
          SqfEntityField('FNPO', DbType.text),
          SqfEntityField('ED_GIS', DbType.text),
          SqfEntityField('SECURITY_BONDS', DbType.text),
          SqfEntityField('EXTRA_DEPARTMENTAL_UNIONS', DbType.text),
          SqfEntityField('CGEGIS_INSURANCE_FUND', DbType.text),
          SqfEntityField('POSTAL_COOP_SOCIETY', DbType.text),
          SqfEntityField('COOP_BANK_REC', DbType.text),
          SqfEntityField('DIVISION_SPORTS_BOARD', DbType.text),
          SqfEntityField('MISC_DEDUCTIONS', DbType.text),
          SqfEntityField('BONDS', DbType.text),
          SqfEntityField('CWFGDS', DbType.text),
          SqfEntityField('FESTIVAL_ADVANCE_SPECIAL', DbType.text),
          SqfEntityField('TOTAL_DEDUCTIONS', DbType.text),
          SqfEntityField('TOTAL_GROSS_AMOUNT', DbType.text),
          SqfEntityField('NET_PAY', DbType.text),

    ]);

@SqfEntityBuilder(formUserModel)
const formUserModel = SqfEntityModel(
      password: 'Rt55B"fa36JlhQ',
    modelName: 'userDB',
    databaseName: 'user.db',
    databaseTables: [
      userdetails,
      UserLoginDetails,
      userValidation,
      ofcmasterdata,
      fileCreation,
          PaySlipCreation
    ],
    bundledDatabasePath: null);