import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:http/http.dart' as http;

part 'PostOfficeModel.g.dart';

const tableBaseTariffBP = SqfEntityTable(
    tableName: 'Base_Tariff_BP',
    primaryKeyName: 'Productcode',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('ValidTo', DbType.real),
      SqfEntityField('ProductDescription', DbType.text),
      SqfEntityField('Distance', DbType.text),
      SqfEntityField('DistanceDescription', DbType.text),
      SqfEntityField('Weight', DbType.text),
      SqfEntityField('WeightDescriptionStart', DbType.integer),
      SqfEntityField('WeightDescriptionEnd', DbType.integer),
      SqfEntityField('Conditionrate', DbType.real),
      SqfEntityField('ServiceTax', DbType.real),
    ]);

const tableBaseTariffSP = SqfEntityTable(
    tableName: 'Base_Tariff_SP',
    primaryKeyName: 'Productcode',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('ValidTo', DbType.text),
      SqfEntityField('ProductDescription', DbType.text),
      SqfEntityField('Distance', DbType.text),
      SqfEntityField('DistanceDescriptionStart', DbType.integer),
      SqfEntityField('DistanceDescriptionEnd', DbType.integer),
      SqfEntityField('Weight', DbType.text),
      SqfEntityField('WeightDescriptionStart', DbType.integer),
      SqfEntityField('WeightDescriptionEnd', DbType.integer),
      SqfEntityField('Conditionrate', DbType.real),
      SqfEntityField('ServiceTax', DbType.real),
    ]);

const tablebNeighbouringState = SqfEntityTable(
    tableName: 'Book_State_Neighbour',
    primaryKeyName: 'BookingStatecode',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('Bookingstatename', DbType.text),
      SqfEntityField('NeighbouringStatecode', DbType.integer),
      SqfEntityField('NeighbouringState', DbType.text),
    ]);

const tableCityState = SqfEntityTable(
    tableName: 'city_state',
    primaryKeyName: 'city',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('citycode', DbType.integer),
      SqfEntityField('statecode', DbType.integer),
      SqfEntityField('capital', DbType.text),
      SqfEntityField('metro_indicator', DbType.text),
      SqfEntityField('ncr_indicator', DbType.text),
    ]);

const tableInsurance = SqfEntityTable(
    tableName: 'Insurance',
    primaryKeyName: 'ServiceID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('MinAmount', DbType.real),
      SqfEntityField('MaxAmount', DbType.real),
      SqfEntityField('Commission', DbType.real),
      SqfEntityField('ActivationDate', DbType.real),
      SqfEntityField('ExpiryDate', DbType.real),
    ]);

const tableLocalPin = SqfEntityTable(
    tableName: 'Local_pin',
    primaryKeyName: 'SourcePinCode',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('LocalPinCode', DbType.text),
      SqfEntityField('Var1', DbType.text),
      SqfEntityField('ValidTo', DbType.text),
    ]);

const tablePinCodesMaster = SqfEntityTable(
    tableName: 'OfficeMasterPinCode',
    primaryKeyName: 'FacilityID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('OfficeName', DbType.text),
      SqfEntityField('OfficeType', DbType.text),
      SqfEntityField(
        'Pincode',
        DbType.integer,
      ),
      SqfEntityField('Delivery', DbType.text),
      SqfEntityField('Latitude', DbType.real),
      SqfEntityField('Longitude', DbType.real),
      SqfEntityField('SOName', DbType.text),
      SqfEntityField('HOName', DbType.text),
      SqfEntityField('DOName', DbType.text),
      SqfEntityField('ROName', DbType.text),
      SqfEntityField('COName', DbType.text),
      SqfEntityField('ContactNumber', DbType.integer),
      SqfEntityField('EndDate', DbType.date),
      SqfEntityField('ModifiedDate', DbType.text),
      SqfEntityField('Priority', DbType.integer),
      SqfEntityField('State', DbType.text),
      SqfEntityField('Region', DbType.integer),
      SqfEntityField('ReceiverCityDistrict', DbType.text),
    ]);

const tableOfficeMaster = SqfEntityTable(
    tableName: 'OfficeMaster_Pincodes',
    primaryKeyName: 'FacilityID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('OfficeName', DbType.text),
      SqfEntityField('OfficeType', DbType.text),
      SqfEntityField(
        'Pincode',
        DbType.integer,
      ),
      SqfEntityField('Delivery', DbType.text),
      SqfEntityField('Latitude', DbType.real),
      SqfEntityField('Longitude', DbType.real),
      SqfEntityField('SOName', DbType.text),
      SqfEntityField('HOName', DbType.text),
      SqfEntityField('DOName', DbType.text),
      SqfEntityField('ROName', DbType.text),
      SqfEntityField('COName', DbType.text),
      SqfEntityField('ContactNumber', DbType.integer),
      SqfEntityField('EndDate', DbType.date),
      SqfEntityField('ModifiedDate', DbType.text),
      SqfEntityField('field16', DbType.text),
      SqfEntityField('field17', DbType.text),
      SqfEntityField('Region', DbType.integer),
      SqfEntityField('ReceiverCityDistrict', DbType.text),
    ]);

const tablePeriodicalWeight = SqfEntityTable(
    tableName: 'PeriodicalWeight',
    primaryKeyName: 'Weight',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('WeightDescriptionStart', DbType.real),
      SqfEntityField('WeightDescriptionEnd', DbType.real),
    ]);

const tablePeriodicals = SqfEntityTable(
    tableName: 'Periodicals',
    primaryKeyName: 'PeriodicalVariant',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('PeriodicalValueMin', DbType.real),
      SqfEntityField('PeriodicalValueMax', DbType.real),
    ]);

const tablePrice = SqfEntityTable(
    tableName: 'Price',
    primaryKeyName: 'Productcode',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('DestinationCountry', DbType.text),
      SqfEntityField('Pricingunit', DbType.integer),
      SqfEntityField('LocalNonLocal', DbType.text),
      SqfEntityField('Variant', DbType.text),
      SqfEntityField('ValidTo', DbType.real),
      SqfEntityField('ProductDescription', DbType.text),
      SqfEntityField('Distance', DbType.text),
      SqfEntityField('DistanceDescription', DbType.text),
      SqfEntityField('Weight', DbType.text),
      SqfEntityField('WeightDescriptionStart', DbType.integer),
      SqfEntityField('WeightDescriptionEnd', DbType.integer),
      SqfEntityField('Conditionrate', DbType.real),
      SqfEntityField('ServiceTax', DbType.real),
    ]);

const tableProductMaster = SqfEntityTable(
    tableName: 'Productmaster',
    primaryKeyName: 'Productcode',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('MaterialDescription', DbType.text),
      SqfEntityField('Country', DbType.text),
    ]);

const tableRegionState = SqfEntityTable(
    tableName: 'RegionState',
    primaryKeyName: 'RegionCode',
    primaryKeyType: PrimaryKeyType.integer_unique,
    fields: [
      SqfEntityField('StateName', DbType.text),
    ]);

const tableTariffInfo = SqfEntityTable(
    tableName: 'TariffInfo',
    primaryKeyName: 'Product',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('ProductDesc', DbType.text),
      SqfEntityField('Price', DbType.real),
    ]);

const tableTariffMod = SqfEntityTable(
    tableName: 'Tariff_Info_mod',
    primaryKeyName: 'Product',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('ProductDesc', DbType.text),
      SqfEntityField('Price', DbType.real),
    ]);

const tableVpp = SqfEntityTable(
    tableName: 'Vpp',
    primaryKeyName: 'ServiceID',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('MinAmount', DbType.real),
      SqfEntityField('MaxAmount', DbType.real),
      SqfEntityField('Commission', DbType.real),
      SqfEntityField('ActivationDate', DbType.real),
      SqfEntityField('ExpiryDate', DbType.real),
    ]);

const tableWeightValidations = SqfEntityTable(
    tableName: 'WeightValidations',
    primaryKeyName: 'Product',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('WeightMin', DbType.real),
      SqfEntityField('WeightMax', DbType.real),
    ]);

const tableVAServices = SqfEntityTable(
    tableName: 'Vaservices',
    primaryKeyName: 'Productcode',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField('ServiceType', DbType.text),
      SqfEntityField('VASdescription', DbType.text),
      SqfEntityField('VASPrice', DbType.real),
    ]);

@SqfEntityBuilder(tariffdb)
const tariffdb = SqfEntityModel(
  modelName: 'tariffdb',
  password: 'Kst<8G3sy9M/t4',
  databaseName: 'tariff.db',
  bundledDatabasePath: 'assets/PostOfficeDB.db',
  databasePath: 'storage/emulated/0/Darpan_Mine/Databases',
  databaseTables: [
    tableBaseTariffBP,
    tableBaseTariffSP,
    tablebNeighbouringState,
    tableCityState,
    tableInsurance,
    tableLocalPin,
    tableOfficeMaster,
    tablePeriodicalWeight,
    tablePeriodicals,
    tablePrice,
    tableProductMaster,
    tableRegionState,
    tableTariffInfo,
    tableTariffMod,
    tableVpp,
    tableWeightValidations,
    tableVAServices,
    tablePinCodesMaster
  ],
);
