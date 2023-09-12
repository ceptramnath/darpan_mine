import 'package:darpan_mine/Constants/Color.dart';
import 'package:darpan_mine/Utils/barcodeValidation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AdditionalServiceForm extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final String typeValue;
  final FocusNode focusNode;

  AdditionalServiceForm(
      {required this.labelText,
      required this.controller,
      required this.typeValue,
      required this.focusNode});

  @override
  _AdditionalServiceFormState createState() => _AdditionalServiceFormState();
}

class _AdditionalServiceFormState extends State<AdditionalServiceForm> {
  @override
  Widget build(BuildContext context) {
    var _text = '';

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 8.0.toDouble(), horizontal: 3.0.toDouble()),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLength: 5,
        focusNode: widget.focusNode,
        onChanged: (text) => setState(() => _text),
        controller: widget.controller,
        style: const TextStyle(color: ColorConstants.kSecondaryColor),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            counterText: '',
            fillColor: ColorConstants.kWhite,
            filled: true,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstants.kSecondaryColor),
            ),
            prefixIcon: const Icon(
              MdiIcons.currencyInr,
              color: ColorConstants.kSecondaryColor,
            ),
            suffixIcon: widget.controller.text.isNotEmpty
                ? (widget.typeValue == 'City' || widget.typeValue == 'State')
                    ? null
                    : IconButton(
                        icon: const Icon(
                          MdiIcons.closeCircleOutline,
                          color: ColorConstants.kSecondaryColor,
                        ),
                        onPressed: () {
                          widget.controller.clear();
                          FocusScope.of(context).unfocus();
                        },
                      )
                : null,
            labelStyle:
                const TextStyle(color: ColorConstants.kAmberAccentColor),
            labelText: widget.labelText,
            contentPadding: EdgeInsets.all(15.0.toDouble()),
            isDense: true,
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.kSecondaryColor)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.kSecondaryColor))),
        validator: (text) {
          String text = widget.controller.text.trim();

          //Insurance Validation
          if (widget.typeValue == 'Insurance') {
            if (widget.controller.text.isEmpty) {
              return 'Enter the Insured Amount';
            } else if (int.parse(widget.controller.text) > 600) {
              return 'Amount should be less than \u{20B9} 600';
            }
          }

          //Value Payable Post Validation
          if (widget.typeValue == 'ValuePayable') {
            if (widget.controller.text.isEmpty) return 'Enter the Amount';
          }
        },
      ),
    );
  }
}

class CAdditionalServiceForm extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final String typeValue;
  final FocusNode focusNode;
  final IconData iconData;
  final bool? isVPP;

  CAdditionalServiceForm(
      {required this.labelText,
      required this.controller,
      required this.typeValue,
      required this.focusNode,
      required this.iconData,
      this.isVPP});

  @override
  _CAdditionalServiceFormState createState() => _CAdditionalServiceFormState();
}

class _CAdditionalServiceFormState extends State<CAdditionalServiceForm> {
  @override
  Widget build(BuildContext context) {
    var _text = '';

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 8.0.toDouble(), horizontal: 3.0.toDouble()),
      child: TextFormField(
        readOnly: widget.isVPP!,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLength: 5,
        focusNode: widget.focusNode,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (text) => setState(() => _text),
        controller: widget.controller,
        style: const TextStyle(color: ColorConstants.kSecondaryColor),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            counterText: '',
            fillColor: ColorConstants.kWhite,
            filled: true,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstants.kWhite),
            ),
            prefixIcon: Icon(
              widget.iconData,
              color: ColorConstants.kSecondaryColor,
            ),
            suffixIcon: widget.controller.text.isNotEmpty
                ? (widget.typeValue == 'City' || widget.typeValue == 'State')
                    ? null
                    : IconButton(
                        icon: const Icon(
                          MdiIcons.closeCircleOutline,
                          color: ColorConstants.kSecondaryColor,
                        ),
                        onPressed: () {
                          widget.controller.clear();
                          FocusScope.of(context).unfocus();
                        },
                      )
                : null,
            labelStyle:
                const TextStyle(color: ColorConstants.kAmberAccentColor),
            labelText: widget.labelText,
            contentPadding: EdgeInsets.all(15.0.toDouble()),
            isDense: true,
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.kWhite)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.kWhite))),
        validator: (text) {
          String text = widget.controller.text.trim();

          //Weight Validation
          if (widget.typeValue == 'Weight') {
            if (widget.controller.text.isEmpty) {
              return 'Enter the Weight';
            } else if (int.parse(widget.controller.text) > 2000) {
              return 'Weight should be less than 2000gms';
            }
          }

          //Insurance Validation
          if (widget.typeValue == 'Insurance') {
            if (widget.controller.text.isEmpty) {
              return 'Enter the Insured Amount';
            } else if (int.parse(widget.controller.text) > 600) {
              return 'Amount should be less than \u{20B9} 600';
            }
          }

          //Value Payable Post Validation
          if (widget.typeValue == 'ValuePayable') {
            if (widget.controller.text.isEmpty) return 'Enter the Amount';
          }

          //Mails.Booking.EMO Value
          if (widget.typeValue == 'EMOValue') {
            if (text.isEmpty) {
              return 'Enter the EMO Value';
            } else if (int.parse(text) == 0) {
              return 'EMO amount can\'t be 0';
            } else if (int.parse(text) > 5000) {
              return 'Amount should not be more than \u{20B9}5000';
            }
            return null;
          }
        },
      ),
    );
  }
}

class CAdditionalServiceForm1 extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final String typeValue;
  final IconData iconData;
  final Function onChanged;

  CAdditionalServiceForm1(
      {required this.labelText,
      required this.controller,
      required this.typeValue,
      required this.iconData,
      required this.onChanged});

  @override
  _CAdditionalServiceFormState1 createState() =>
      _CAdditionalServiceFormState1();
}

class _CAdditionalServiceFormState1 extends State<CAdditionalServiceForm1> {
  @override
  Widget build(BuildContext context) {
    var _text = '';

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 8.0.toDouble(), horizontal: 3.0.toDouble()),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLength: 5,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (text) => widget.onChanged,
        controller: widget.controller,
        style: const TextStyle(color: ColorConstants.kSecondaryColor),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            counterText: '',
            fillColor: ColorConstants.kWhite,
            filled: true,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstants.kWhite),
            ),
            prefixIcon: Icon(
              widget.iconData,
              color: ColorConstants.kSecondaryColor,
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                MdiIcons.closeCircleOutline,
                color: ColorConstants.kSecondaryColor,
              ),
              onPressed: () {
                widget.controller.clear();
                FocusScope.of(context).unfocus();
              },
            ),
            labelStyle:
                const TextStyle(color: ColorConstants.kAmberAccentColor),
            labelText: widget.labelText,
            contentPadding: EdgeInsets.all(15.0.toDouble()),
            isDense: true,
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.kWhite)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.kWhite))),
        validator: (text) {
          String text = widget.controller.text.trim();

          //Weight Validation
          if (widget.typeValue == 'Weight') {
            if (widget.controller.text.isEmpty) {
              return 'Enter the Weight';
            } else if (int.parse(widget.controller.text) > 2000) {
              return 'Weight should be less than 2000gms';
            }
          }

          //Insurance Validation
          if (widget.typeValue == 'Insurance') {
            if (widget.controller.text.isEmpty) {
              return 'Enter the Insured Amount';
            } else if (int.parse(widget.controller.text) > 600) {
              return 'Amount should be less than \u{20B9} 600';
            }
          }

          //Value Payable Post Validation
          if (widget.typeValue == 'ValuePayable') {
            if (widget.controller.text.isEmpty) return 'Enter the Amount';
          }

          //Mails.Booking.EMO Value
          if (widget.typeValue == 'EMOValue') {
            if (text.isEmpty) {
              return 'Enter the EMO Value';
            } else if (int.parse(text) == 0) {
              return 'EMO amount can\'t be 0';
            } else if (int.parse(text) > 5000) {
              return 'Amount should not be more than \u{20B9}5000';
            }
            return null;
          }
        },
      ),
    );
  }
}

class InputForm extends StatefulWidget {
  final bool readOnly;
  final String labelText;
  final IconData iconData;
  final TextEditingController controller;
  final TextInputType textType;
  final String typeValue;
  final FocusNode focusNode;

  const InputForm(
      {required this.readOnly,
      required this.iconData,
      required this.labelText,
      required this.controller,
      required this.textType,
      required this.typeValue,
      required this.focusNode});

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  @override
  Widget build(BuildContext context) {
    var _text = '';

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 8.0.toDouble(), horizontal: 3.0.toDouble()),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        focusNode: null,
        maxLength: widget.typeValue == 'ArticleNumber'
            ? 13
            : widget.typeValue == 'MobileNumber'
                ? 10
                : null,
        onChanged: (text) => setState(() => _text),
        maxLines: widget.typeValue == "Address" ? 3 : 1,
        enabled: !widget.readOnly,
        readOnly: widget.readOnly,
        controller: widget.controller,
        style: const TextStyle(color: ColorConstants.kSecondaryColor),
        textCapitalization: widget.typeValue == 'ArticleNumber'
            ? TextCapitalization.characters
            : widget.typeValue == "Address"
                ? TextCapitalization.sentences
                : widget.typeValue == "Name"
                    ? TextCapitalization.words
                    : TextCapitalization.none,
        keyboardType: widget.textType,
        decoration: InputDecoration(
            counterText: '',
            fillColor: ColorConstants.kWhite,
            filled: true,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstants.kSecondaryColor),
            ),
            prefixIcon: Icon(
              widget.iconData,
              color: ColorConstants.kSecondaryColor,
            ),
            suffixIcon: widget.controller.text.isNotEmpty
                ? widget.typeValue == "City"
                    ? null
                    : IconButton(
                        icon: const Icon(
                          MdiIcons.closeCircleOutline,
                          color: ColorConstants.kSecondaryColor,
                        ),
                        onPressed: () {
                          widget.controller.clear();
                          FocusScope.of(context).unfocus();
                        },
                      )
                : null,
            labelStyle:
                const TextStyle(color: ColorConstants.kAmberAccentColor),
            labelText: widget.labelText,
            contentPadding: EdgeInsets.all(15.0.toDouble()),
            isDense: true,
            // border: InputBorder.none

            border: const OutlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.kSecondaryColor)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.kSecondaryColor))),
        validator: (text) {
          String text = widget.controller.text.trim();

          //Article Number validation
          if (widget.typeValue == 'ArticleNumber') {
            if (text.length != 13) {
              // widget.focusNode.requestFocus();
              return 'Article length should be of 13 characters';
            } else if (!text.startsWith('R', 0)) {
              return 'Should start with R';
            } else if (!text.startsWith('I', 11)) {
              return 'Should end with IN';
            } else if (!text.endsWith('N')) {
              return 'Should end with IN';
            }
            return null;
          }

          //Weight validation
          if (widget.typeValue == 'Weight') {
            if (text.isEmpty) {
              return 'Enter the weight';
            } else if (int.parse(text) > 2000) {
              return 'Weight must not be Greater than 2000 Gms';
            }
            return null;
          }

          //Name Validation
          if (widget.typeValue == 'Name') {
            if (text.isEmpty) return 'Enter the Name';
            return null;
          }

          //Address Validation
          if (widget.typeValue == 'Address') {
            if (text.isEmpty) return 'Enter the Address';
            return null;
          }

          //Email Validation
          if (widget.typeValue == 'Email') {
            String pattern =
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                r"{0,253}[a-zA-Z0-9])?)*$";
            RegExp regex = RegExp(pattern);
            if (text.isEmpty) {
              return null;
            } else if (!regex.hasMatch(text)) {
              return 'Enter a valid Email address';
            }
          }
        },
      ),
    );
  }
}

class CInputForm extends StatefulWidget {
  final bool readOnly;
  final String labelText;
  final IconData iconData;
  final TextEditingController controller;
  final TextInputType textType;
  final String typeValue;
  final FocusNode focusNode;

  CInputForm(
      {required this.readOnly,
      required this.iconData,
      required this.labelText,
      required this.controller,
      required this.textType,
      required this.typeValue,
      required this.focusNode});

  @override
  _CInputFormState createState() => _CInputFormState();
}

class _CInputFormState extends State<CInputForm> {
  @override
  Widget build(BuildContext context) {
    var _text = '';

    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 8.0.toDouble(), horizontal: 3.0.toDouble()),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9.#,-:\r\n\s@]+')),
        ],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        maxLength: widget.typeValue == 'ArticleNumber'
            ? 13
            : widget.typeValue == 'MobileNumber'
            ? 10
            : widget.typeValue == 'Others'
            ? 20
            : null,
        onChanged: (text) => setState(() => _text),
        maxLines: widget.typeValue == "Address" ? 3 : 1,
        enabled: !widget.readOnly,
        readOnly: widget.readOnly,
        controller: widget.controller,
        style: const TextStyle(color: ColorConstants.kSecondaryColor),
        textCapitalization: widget.typeValue == 'ArticleNumber'
            ? TextCapitalization.characters
            : widget.typeValue == "Address"
                ? TextCapitalization.sentences
                : widget.typeValue == "Name"
                    ? TextCapitalization.words
                    : TextCapitalization.none,
        keyboardType: widget.textType,
        decoration: InputDecoration(
            counterText: '',
            fillColor: ColorConstants.kWhite,
            filled: true,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstants.kWhite),
            ),
            prefixIcon: Icon(
              widget.iconData,
              color: ColorConstants.kSecondaryColor,
            ),
            suffixIcon: widget.controller.text.isNotEmpty
                ? widget.typeValue == "City" || widget.typeValue == "Commission"
                    ? null
                    : IconButton(
                        icon: const Icon(
                          MdiIcons.closeCircleOutline,
                          color: ColorConstants.kSecondaryColor,
                        ),
                        onPressed: () {
                          widget.controller.clear();
                          FocusScope.of(context).unfocus();
                        },
                      )
                : null,
            labelStyle:
                const TextStyle(color: ColorConstants.kAmberAccentColor),
            labelText: widget.labelText,
            isDense: true,
            border: InputBorder.none,

            // border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.kWhite))),
        validator: (text) {
          String text = widget.controller.text.trim();

          //Article Number validation
          if (widget.typeValue == 'ArticleNumber') {
            if (text.length != 13) {
              // widget.focusNode.requestFocus();
              return 'Article length should be of 13 characters';
            } else if (!text.startsWith('R', 0)) {
              return 'Should start with R';
            } else if (!text.startsWith('I', 11)) {
              return 'Should end with IN';
            } else if (!text.endsWith('N')) {
              return 'Should end with IN';
            }
            return null;
          }

          //Weight validation
          // if (widget.typeValue == 'Weight') {
          //   if (text.isEmpty)
          //     return 'Enter the weight';
          //   else if (int.parse(text) > maxWeight!)
          //     return 'Weight must not be Greater than $maxWeight Gms';
          //   return null;
          // }

          //Name Validation
          if (widget.typeValue == 'Name') {
            if (text.isEmpty) return 'Enter the Name';
            return null;
          }

          //Address Validation
          if (widget.typeValue == 'Address') {
            if (text.isEmpty) return 'Enter the Address';
            return null;
          }

          if (widget.typeValue == 'Quantity') {
            if (text.isEmpty) return 'Enter the Quantity';
            return null;
          }

          if (widget.typeValue == 'Weight') {
            if (text.isEmpty) return 'Enter the Quantity';
            return null;
          }

          if (widget.typeValue == 'Amount') {
            if (text.isEmpty) return 'Enter the Amount';
            return null;
          }
          if (widget.typeValue == 'Collected Amount') {
            if (text.isEmpty)
              return null;
            else if(int.tryParse(text) == null)
              return 'Enter an integer';
            else
              return null;
          }
          //Email Validation
          if (widget.typeValue == 'Email') {
            String pattern =
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                r"{0,253}[a-zA-Z0-9])?)*$";
            RegExp regex = RegExp(pattern);
            if (text.isEmpty)
              return null;
            else if (!regex.hasMatch(text))
              return 'Enter a valid Email address';
          }
          // else
          //   {
          //     String pattern =  r"^[a-zA-Z0-9.#,-:\r\n]+";
          //     RegExp regex = RegExp(pattern);
          //     if (!regex.hasMatch(text))
          //       return 'Enter a valid data';
          //   }
        },
      ),
    );
  }
}

class InitialTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final IconData iconData;
  final String labelText;

  // final String initialValue;

  const InitialTextFormField(
      {Key? key,
      required this.controller,
      required this.iconData,
      required this.labelText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 8.0.toDouble(), horizontal: 3.0.toDouble()),
      child: TextFormField(
        readOnly: true,
        // initialValue: initialValue,
        controller: controller,
        style: const TextStyle(color: ColorConstants.kSecondaryColor),
        decoration: InputDecoration(
            counterText: '',
            fillColor: ColorConstants.kWhite,
            filled: true,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstants.kWhite),
            ),
            prefixIcon: Icon(
              iconData,
              color: ColorConstants.kSecondaryColor,
            ),
            labelStyle:
                const TextStyle(color: ColorConstants.kAmberAccentColor),
            labelText: labelText,
            isDense: true,
            border: InputBorder.none,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.kWhite))),
      ),
    );
  }
}

class ScanTextFormField extends StatelessWidget {
  final String type;
  final String title;
  final FocusNode focus;
  final Function() scanFunction;
  final TextEditingController controller;

  const ScanTextFormField(
      {Key? key,
      required this.type,
      required this.title,
      required this.focus,
      required this.scanFunction,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: null,
      maxLength: 13,
      controller: controller,
      style: const TextStyle(color: ColorConstants.kSecondaryColor),
      textCapitalization: TextCapitalization.characters,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          counterText: '',
          fillColor: ColorConstants.kWhite,
          filled: true,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.kWhite),
          ),
          prefixIcon: Container(
              padding: EdgeInsets.symmetric(vertical: 5.toDouble()),
              margin: EdgeInsets.only(right: 8.0.toDouble()),
              decoration: const BoxDecoration(
                color: ColorConstants.kSecondaryColor,
              ),
              child: IconButton(
                onPressed: scanFunction,
                icon: const Icon(
                  MdiIcons.barcodeScan,
                  color: ColorConstants.kWhite,
                ),
              )),
          labelStyle: const TextStyle(color: ColorConstants.kAmberAccentColor),
          labelText: title,
          contentPadding: EdgeInsets.all(15.0.toDouble()),
          isDense: true,
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorConstants.kWhite),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0.toDouble()),
                bottomLeft: Radius.circular(30.0.toDouble()),
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorConstants.kWhite),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0.toDouble()),
                bottomLeft: Radius.circular(30.0.toDouble()),
              ))),
      validator: (text) {
        print("Article number enetered is $text");
        print("Title is $title");
        // Validating the Article Number
        if(title == "Article Number") {
          String res = artval.validate(text!);
          if (res == "Valid")
            return null;
          else
            return res;
        }
        else
        if(title == "Bag Number") {
          String res = bgval.validate(text!);
          if (res == "Valid")
            return null;
          else
            return res;
        }
        else return null;

      },
    );
  }
}

class LiabilityScanner extends StatelessWidget {
  final String title;
  final Function() scanFunction;
  final TextEditingController controller;

  const LiabilityScanner(
      {Key? key,
      required this.title,
      required this.controller,
      required this.scanFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      style: const TextStyle(color: ColorConstants.kSecondaryColor),
      textCapitalization: TextCapitalization.characters,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          counterText: '',
          fillColor: ColorConstants.kWhite,
          filled: true,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.kWhite),
          ),
          prefixIcon: Container(
              padding: EdgeInsets.symmetric(vertical: 5.toDouble()),
              margin: EdgeInsets.only(right: 8.0.toDouble()),
              decoration: const BoxDecoration(
                color: ColorConstants.kSecondaryColor,
              ),
              child: IconButton(
                onPressed: scanFunction,
                icon: const Icon(
                  MdiIcons.barcodeScan,
                  color: ColorConstants.kWhite,
                ),
              )),
          labelStyle: const TextStyle(color: ColorConstants.kAmberAccentColor),
          labelText: title,
          contentPadding: EdgeInsets.all(15.0.toDouble()),
          isDense: true,
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorConstants.kWhite),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0.toDouble()),
                bottomLeft: Radius.circular(30.0.toDouble()),
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorConstants.kWhite),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0.toDouble()),
                bottomLeft: Radius.circular(30.0.toDouble()),
              ))),
      validator: (text) {
        if (text!.isEmpty) return 'Please enter the number';
        return null;
      },
    );
  }
}

class LiabilityAmount extends StatelessWidget {
  final String title;
  final bool readStatus;
  final TextEditingController controller;

  const LiabilityAmount(
      {Key? key,
      required this.title,
      required this.readStatus,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readStatus,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: null,
      controller: controller,
      style: const TextStyle(color: ColorConstants.kSecondaryColor),
      textCapitalization: TextCapitalization.characters,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          counterText: '',
          fillColor: ColorConstants.kWhite,
          filled: true,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.kWhite),
          ),
          prefixIcon: Container(
              padding: EdgeInsets.symmetric(vertical: 5.toDouble()),
              margin: EdgeInsets.only(right: 8.0.toDouble()),
              decoration: const BoxDecoration(
                color: ColorConstants.kSecondaryColor,
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  MdiIcons.currencyInr,
                  color: ColorConstants.kWhite,
                ),
              )),
          labelStyle: const TextStyle(color: ColorConstants.kAmberAccentColor),
          labelText: title,
          contentPadding: EdgeInsets.all(15.0.toDouble()),
          isDense: true,
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorConstants.kWhite),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0.toDouble()),
                bottomLeft: Radius.circular(30.0.toDouble()),
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorConstants.kWhite),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0.toDouble()),
                bottomLeft: Radius.circular(30.0.toDouble()),
              ))),
      validator: (text) {
        if (text!.isEmpty) return 'Enter Amount';
        return null;
      },
    );
  }
}

class WeightForm extends StatelessWidget {
  final String title;
  final TextEditingController controller;

  const WeightForm({Key? key, required this.title, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 8.0.toDouble(), horizontal: 3.0.toDouble()),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: ColorConstants.kSecondaryColor),
        decoration: InputDecoration(
          counterText: '',
          fillColor: ColorConstants.kWhite,
          filled: true,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.kWhite),
          ),
          prefixIcon: const Icon(
            MdiIcons.weightGram,
            color: ColorConstants.kSecondaryColor,
          ),
          labelStyle: const TextStyle(color: ColorConstants.kAmberAccentColor),
          labelText: title,
          isDense: true,
          border: InputBorder.none,
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstants.kWhite)),
        ),
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'Enter Weight';
          }
          return null;
        },
      ),
    );
  }
}

class WeightDialogForm extends StatelessWidget {
  final String title;
  final TextEditingController controller;

  const WeightDialogForm(
      {Key? key, required this.title, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: null,
      controller: controller,
      style: const TextStyle(color: ColorConstants.kSecondaryColor),
      textCapitalization: TextCapitalization.characters,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          counterText: '',
          fillColor: ColorConstants.kWhite,
          filled: true,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.kWhite),
          ),
          prefixIcon: Container(
            padding: EdgeInsets.symmetric(vertical: 5.toDouble()),
            margin: EdgeInsets.only(right: 8.0.toDouble()),
            decoration: const BoxDecoration(
              color: ColorConstants.kSecondaryColor,
            ),
            child: const Icon(
              MdiIcons.weightGram,
              color: ColorConstants.kWhite,
            ),
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    MdiIcons.closeCircleOutline,
                    color: ColorConstants.kSecondaryColor,
                  ),
                  onPressed: () {
                    controller.clear();
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
          labelStyle: const TextStyle(color: ColorConstants.kAmberAccentColor),
          labelText: title,
          contentPadding: EdgeInsets.all(15.0.toDouble()),
          isDense: true,
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorConstants.kWhite),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0.toDouble()),
                bottomLeft: Radius.circular(30.0.toDouble()),
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorConstants.kWhite),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0.toDouble()),
                bottomLeft: Radius.circular(30.0.toDouble()),
              ))),
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Enter Weight';
        }
        return null;
      },
    );
  }
}

class CustomForm extends StatelessWidget {
  final String title;
  final IconData icon;
  final TextEditingController controller;

  const CustomForm(
      {Key? key,
      required this.title,
      required this.icon,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: null,
      controller: controller,
      style: const TextStyle(color: ColorConstants.kSecondaryColor),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          counterText: '',
          fillColor: ColorConstants.kWhite,
          filled: true,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.kWhite),
          ),
          prefixIcon: Container(
            padding: EdgeInsets.symmetric(vertical: 5.toDouble()),
            margin: EdgeInsets.only(right: 8.0.toDouble()),
            decoration: const BoxDecoration(
              color: ColorConstants.kSecondaryColor,
            ),
            child: Icon(
              icon,
              color: ColorConstants.kWhite,
            ),
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    MdiIcons.closeCircleOutline,
                    color: ColorConstants.kSecondaryColor,
                  ),
                  onPressed: () {
                    controller.clear();
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
          labelStyle: const TextStyle(color: ColorConstants.kAmberAccentColor),
          labelText: title,
          contentPadding: EdgeInsets.all(15.0.toDouble()),
          isDense: true,
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorConstants.kWhite),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0.toDouble()),
                bottomLeft: Radius.circular(30.0.toDouble()),
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorConstants.kWhite),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0.toDouble()),
                bottomLeft: Radius.circular(30.0.toDouble()),
              ))),
      validator: (text) {
        if (text!.isEmpty) {
          return 'Enter the Amount';
        }
        return null;
      },
    );
  }
}

class AmountForm extends StatelessWidget {
  final String title;
  final TextEditingController controller;

  const AmountForm({Key? key, required this.title, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: null,
      controller: controller,
      style: const TextStyle(color: ColorConstants.kSecondaryColor),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          counterText: '',
          fillColor: ColorConstants.kWhite,
          filled: true,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.kWhite),
          ),
          prefixIcon: Container(
            padding: EdgeInsets.symmetric(vertical: 5.toDouble()),
            margin: EdgeInsets.only(right: 8.0.toDouble()),
            decoration: const BoxDecoration(
              color: ColorConstants.kSecondaryColor,
            ),
            child: const Icon(
              MdiIcons.currencyInr,
              color: ColorConstants.kWhite,
            ),
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    MdiIcons.closeCircleOutline,
                    color: ColorConstants.kSecondaryColor,
                  ),
                  onPressed: () {
                    controller.clear();
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
          labelStyle: const TextStyle(color: ColorConstants.kAmberAccentColor),
          labelText: title,
          contentPadding: EdgeInsets.all(15.0.toDouble()),
          isDense: true,
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorConstants.kWhite),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0.toDouble()),
                bottomLeft: Radius.circular(30.0.toDouble()),
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorConstants.kWhite),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0.toDouble()),
                bottomLeft: Radius.circular(30.0.toDouble()),
              ))),
      validator: (text) {
        if (text!.isEmpty) {
          return 'Enter the Amount';
        }
        return null;
      },
    );
  }
}

class QuantityForm extends StatelessWidget {
  final String title;
  final TextEditingController controller;

  const QuantityForm({Key? key, required this.title, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: null,
      controller: controller,
      style: const TextStyle(color: ColorConstants.kSecondaryColor),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          counterText: '',
          fillColor: ColorConstants.kWhite,
          filled: true,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.kWhite),
          ),
          prefixIcon: Container(
            padding: EdgeInsets.symmetric(vertical: 5.toDouble()),
            margin: EdgeInsets.only(right: 8.0.toDouble()),
            decoration: const BoxDecoration(
              color: ColorConstants.kSecondaryColor,
            ),
            child: const Icon(
              MdiIcons.shopping,
              color: ColorConstants.kWhite,
            ),
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    MdiIcons.closeCircleOutline,
                    color: ColorConstants.kSecondaryColor,
                  ),
                  onPressed: () {
                    controller.clear();
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
          labelStyle: const TextStyle(color: ColorConstants.kAmberAccentColor),
          labelText: title,
          contentPadding: EdgeInsets.all(15.0.toDouble()),
          isDense: true,
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorConstants.kWhite),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0.toDouble()),
                bottomLeft: Radius.circular(30.0.toDouble()),
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorConstants.kWhite),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0.toDouble()),
                bottomLeft: Radius.circular(30.0.toDouble()),
              ))),
      validator: (text) {
        if (text!.isEmpty) {
          return 'Enter the Quantity';
        }
        return null;
      },
    );
  }
}

class YearForm extends StatelessWidget {
  final String title;
  final Function() selectYear;
  final TextEditingController controller;
  final FocusNode focusNode;

  YearForm(
      {required this.title,
      required this.selectYear,
      required this.controller,
      required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectYear,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 8.0.toDouble(), horizontal: 3.0.toDouble()),
        child: TextFormField(
          readOnly: true,
          controller: controller,
          style: const TextStyle(color: ColorConstants.kSecondaryColor),
          decoration: InputDecoration(
              counterText: '',
              fillColor: ColorConstants.kWhite,
              filled: true,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.kWhite),
              ),
              prefixIcon: IconButton(
                onPressed: selectYear,
                icon: const Icon(Icons.calendar_today),
                color: ColorConstants.kSecondaryColor,
              ),
              labelStyle:
                  const TextStyle(color: ColorConstants.kAmberAccentColor),
              labelText: title,
              isDense: true,
              border: InputBorder.none,
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: ColorConstants.kWhite))),
          validator: (text) {
            if (text == null || text.isEmpty) return 'Select Date';
            return null;
          },
        ),
      ),
    );
  }
}

class ReadOnlyTextFormField extends StatelessWidget {
  final String title;
  final IconData icon;
  final TextEditingController controller;

  const ReadOnlyTextFormField(
      {Key? key,
      required this.title,
      required this.icon,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: 8.0.toDouble(), horizontal: 3.0.toDouble()),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        style: const TextStyle(color: ColorConstants.kSecondaryColor),
        decoration: InputDecoration(
            counterText: '',
            fillColor: ColorConstants.kWhite,
            filled: true,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstants.kWhite),
            ),
            prefixIcon: const Icon(
              Icons.calendar_today,
              color: ColorConstants.kSecondaryColor,
            ),
            labelStyle:
                const TextStyle(color: ColorConstants.kAmberAccentColor),
            labelText: title,
            isDense: true,
            border: InputBorder.none,
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.kWhite))),
        validator: (text) {
          if (text == null || text.isEmpty) return 'Select Date';
          return null;
        },
      ),
    );
  }
}

class AuthForm extends StatelessWidget {
  String title;
  IconData icon;
  TextEditingController controller;

  AuthForm(
      {Key? key,
      required this.title,
      required this.icon,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: Container(
                            padding:
                                EdgeInsets.symmetric(vertical: 5.toDouble()),
                            margin: EdgeInsets.only(right: 8.0.toDouble()),
                            child: Icon(icon, color: Colors.amberAccent)),
                        border: InputBorder.none,
                        labelText: title,
                        labelStyle: TextStyle(
                            letterSpacing: 1,
                            color: Colors.amberAccent))))));
  }
}
