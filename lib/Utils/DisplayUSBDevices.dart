import 'package:flutter/material.dart';
import 'package:quick_usb/quick_usb.dart';

class DisplayUSBDevices extends StatefulWidget {
  final List<UsbDevice> devices;

  DisplayUSBDevices({
    required this.devices,
  });

  @override
  State<DisplayUSBDevices> createState() => DisplayUSBDevicesState();
}

class DisplayUSBDevicesState extends State<DisplayUSBDevices> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AlertDialog(
              title: Text("Select USB Printer"),
              content: widget.devices.length > 0
                  ? Container(
                // height: MediaQuery.of(context).size.height * .75,
                width: MediaQuery.of(context).size.width * .75,
                child: new ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: _buildList(widget.devices),
                ),
              )
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildList(List<UsbDevice> devices) {
    return devices
        .map((device) => new ListTile(
      onTap: () {
        Navigator.pop(context,device);
      },
      leading: new Icon(Icons.usb),
      title: new Text(
          device.manufacturer+ " " + device.product),
      subtitle:
      new Text(device.vendorId.toString() + " " + device.productId.toString()),
    ))
        .toList();
  }
}
