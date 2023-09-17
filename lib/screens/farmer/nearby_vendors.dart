import 'package:flutter/material.dart';
import 'package:victu/objects/users/vendor_data.dart';
import 'package:victu/utils/database.dart';

class NearbyVendors extends StatefulWidget {
  const NearbyVendors({super.key, required this.location});

  final String location;

  @override
  State<NearbyVendors> createState() => _NearbyVendorsState();
}

class _NearbyVendorsState extends State<NearbyVendors> {
  List<VendorData> vendors = [];

  @override
  void initState() {
    getVendors();
    super.initState();
  }

  void getVendors() {
    getAllVendors(location: widget.location).then((vendors) => {
          setState(() {
            this.vendors = vendors;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffebebeb),
      appBar: AppBar(
        elevation: 4,
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff2b9685),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text(
          "Nearby Canteens",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 18,
            color: Color(0xffffffff),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: VendorList(
        vendors: vendors,
      ),
    );
  }
}

class VendorList extends StatefulWidget {
  const VendorList({super.key, required this.vendors});

  final List<VendorData> vendors;

  @override
  State<VendorList> createState() => _VendorListState();
}

class _VendorListState extends State<VendorList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.vendors.length,
        itemBuilder: (context, index) {
          var vendor = widget.vendors[index];
          return vendorWidget(vendor);
        });
  }
}

Widget vendorWidget(VendorData vendor) {
  return Card(
    margin: const EdgeInsets.all(10),
    color: const Color(0xffffffff),
    shadowColor: const Color(0xff000000),
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        Text(
                          vendor.businessName,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 20,
                            color: Color(0xff000000),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Icon(
                          Icons.person,
                          color: Color(0xff212435),
                          size: 14,
                        ),
                        Text(
                          " ${vendor.displayName}",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color.fromARGB(255, 85, 85, 85),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Icon(
                          Icons.phone,
                          color: Color(0xff212435),
                          size: 14,
                        ),
                        Text(
                          " ${vendor.contactNumber}",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 15,
                            color: Color.fromARGB(255, 85, 85, 85),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
