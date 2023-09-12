import 'dart:convert';

DeliverAddress deliverFromJson(String str) =>
    DeliverAddress.fromJson(json.decode(str));

String deliverToJson(DeliverAddress data) => json.encode(data.toJson());

class DeliverAddress {
  final String name;
  final String address;
  final String pincode;
  final String city;
  final String state;
  final String mobileNumber;
  final String email;
  bool checkValue;

  DeliverAddress(
      {required this.name,
      required this.address,
      required this.pincode,
      required this.city,
      required this.state,
      required this.mobileNumber,
      required this.email,
      required this.checkValue});

  factory DeliverAddress.fromJson(Map<String, dynamic> json) => DeliverAddress(
      name: json['name'],
      address: json['address'],
      pincode: json['pincode'],
      city: json['city'],
      state: json['state'],
      mobileNumber: json['mobile_number'],
      email: json['email'],
      checkValue: json['isCheck']);

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "pincode": pincode,
        "city": city,
        "state": state,
        "mobile_number": mobileNumber,
        "email": email,
        "isCheck": checkValue
      };
}
