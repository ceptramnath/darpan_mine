import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'RegisterLetterDBModel.g.dart';

const tableFormRegisterLetter = SqfEntityTable(
    tableName: 'registerLetterTable',
    primaryKeyName: 'ArticleNumber',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('Weight', DbType.text),
      SqfEntityField('WeightAmount', DbType.text),
      SqfEntityField('PrepaidAmount', DbType.integer),
      SqfEntityField('AcknowledgementService', DbType.integer),
      SqfEntityField('InsuranceService', DbType.text),
      SqfEntityField('ValuePayableService', DbType.text),
      SqfEntityField('RegistrationFee', DbType.real),
      SqfEntityField('AmountToBeCollected', DbType.text),
      SqfEntityField('SenderName', DbType.text),
      SqfEntityField('SenderAddress', DbType.text),
      SqfEntityField('SenderPincode', DbType.integer),
      SqfEntityField('SenderCity', DbType.text),
      SqfEntityField('SenderState', DbType.text),
      SqfEntityField('SenderMobileNumber', DbType.text),
      SqfEntityField('SenderEmail', DbType.text),
      SqfEntityField('AddresseeName', DbType.text),
      SqfEntityField('AddresseeAddress', DbType.text),
      SqfEntityField('AddresseePincode', DbType.integer),
      SqfEntityField('AddresseeCity', DbType.text),
      SqfEntityField('AddresseeState', DbType.text),
      SqfEntityField('AddresseeMobileNumber', DbType.text),
      SqfEntityField('AddresseeEmail', DbType.text),
      SqfEntityField('RemarkDate', DbType.text),
    ]);

@SqfEntityBuilder(formLetterModel)
const formLetterModel = SqfEntityModel(
    modelName: 'registerLetterFormModel',
    databaseName: 'registerLetterForm.db',
    databaseTables: [tableFormRegisterLetter],
    bundledDatabasePath: null);
