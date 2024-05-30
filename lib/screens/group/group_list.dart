import 'package:flutter/material.dart';
import 'package:gbce/APIV1/api.dart';
import 'package:gbce/APIV1/requests/group_bymembership.dart';
import 'package:gbce/Componnent/Navigation.dart';
import 'package:gbce/constants/widgets.dart';
import 'package:gbce/models/group_by_membership.dart';
import 'package:gbce/navigations/routes_configurations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Grouplist extends StatefulWidget {
  const Grouplist({super.key});

  @override
  State<Grouplist> createState() => _GrouplistState();
}

class _GrouplistState extends State<Grouplist> {
  bool groupisavailable = false;
  List<GroupElement> groups = [];

  @override
  void initState() {
    super.initState();
    getGroupbymembership();
    successToast('I am fetching group data');
  }

  void getGroupbymembership() async {
    try {
      ApiResponse response =
          await Getgroupbymembership.getgroupbymembership(context);

      if (response.error == null && response.data is Groupbymembership) {
        successToast('Data available');
        setState(() {
          groups = (response.data as Groupbymembership).group;
          groupisavailable = true;
        });
      } else {
        print('Error: ${response.error}');
      }
    } catch (e) {
      print('Error occurred in getting group data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text(
          'Group',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          groupisavailable
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: groups.map((group) {
                        return GestureDetector(
                          onTap: () {
                            print('Group ${group.group!.name} clicked');
                            Get.toNamed(
                              RoutesClass.getgroupdetailsRoute(),
                              arguments: group,
                            );
                          },
                          child: Card(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 20,
                                  child: Text(
                                    group.group!.name[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    group.group!.name,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 26,
                                      color: Colors.blueAccent,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              : const Center(
                  child: Text(
                    'No group available for you!',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 20),
                  ),
                ),
        ],
      ),
    );
  }
}
