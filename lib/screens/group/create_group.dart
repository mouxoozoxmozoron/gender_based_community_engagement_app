import "dart:convert";
import "dart:io";

import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:gbce/APIV1/api.dart";
import "package:gbce/APIV1/requests/creategroup_request.dart";
import "package:gbce/APIV1/requests/getorganisation.dart";
import "package:gbce/Componnent/Navigation.dart";
import "package:gbce/constants/widgets.dart";
import "package:gbce/navigations/routes_configurations.dart";
import "package:get/get_navigation/get_navigation.dart";
import "package:get/utils.dart";

class Newgroup extends StatefulWidget {
  const Newgroup({super.key});

  @override
  State<Newgroup> createState() => _NewgroupState();
}

class _NewgroupState extends State<Newgroup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController organisationIdController =
      TextEditingController();

  List<Map<String, dynamic>> organisations = []; // List to hold organisations
  String? selectedOrganisation; // Selected organisation ID (nullable)
  String? base64File; // Variable to store Base64 string
  String? uploadedFileName; // Variable to store uploaded file name
  bool isEventCreationLoading =
      false; // Manage loading state for event creation
  String? errors; // To store any error messages

  @override
  void initState() {
    super.initState();
  }

  Future<List<Map<String, dynamic>>> _fetchOrganisations() async {
    try {
      final fetchedOrganisations =
          await OrganisationService.fetchOrganisations();
      return fetchedOrganisations;
    } catch (e) {
      throw Exception('Failed to fetch organisations');
    }
  }

  Future<void> _pickLegalDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'], // Allowed file types
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      List<int> fileBytes = await file.readAsBytes();
      base64File = base64Encode(fileBytes); // Convert to Base64
      uploadedFileName = result.files.single.name; // Store file name
      setState(() {}); // Refresh UI
    } else {
      base64File = null; // User canceled file selection
      uploadedFileName = null; // Clear file name
    }
  }

  void creatingGroup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isEventCreationLoading = true;
      });

      // Debug: Log the organisation ID and check if it's valid
      print(
          'Organisation ID (on submission): ${organisationIdController.text}');

      // Ensure organisation ID is not null or empty
      if (organisationIdController.text.isEmpty) {
        print('Organisation ID is null or empty!');
        setState(() {
          isEventCreationLoading = false;
        });
        showErrorDialog(context, 'Please select a valid organisation.');
        return;
      }

      // Proceed with creating group
      ApiResponse response = await CreategroupRequest.creategroup(
        context,
        nameController.text, // Group name
        base64File ?? '', // Pass the Base64 string for legal documents
        organisationIdController.text, // Pass the selected organisation ID
      );

      if (response.error == null) {
        setState(() {
          isEventCreationLoading = false;
        });
        successToast('Group created successfully');
        Get.toNamed(RoutesClass.getcommunityRoute());
      } else {
        setState(() {
          isEventCreationLoading = false;
          errors = response.error;
        });
        showErrorDialog(context, response.error!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[400],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchOrganisations(), // Fetch organisations
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No organisations found'));
          } else {
            organisations =
                snapshot.data!; // Assign fetched data to organisations list

            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage('assets/equality.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        Colors.grey.withOpacity(0.8),
                        BlendMode.dstATop,
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Card(
                    color: Colors.grey.shade100.withOpacity(0.7),
                    elevation: 8,
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              "New Community",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.grey[800],
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: "Group name",
                                hintText: "Give a name for the community",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Group name must be given';
                                }
                                if (value.length < 2) {
                                  return 'Group name must be at least 2 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: "Select Organisation",
                              ),
                              value:
                                  selectedOrganisation, // Value for the selected organisation ID
                              items: organisations.map((organisation) {
                                // Ensure 'id' exists and is valid
                                return DropdownMenuItem<String>(
                                  value: organisation['id']
                                      ?.toString(), // Get the organisation ID
                                  child: Text(
                                    organisation['organisation_name'] ??
                                        'Unknown Organisation', // Organisation name
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedOrganisation =
                                      value; // Store selected organisation ID
                                  organisationIdController.text = value ??
                                      ''; // Update controller text with ID
                                  // Debug: Log selected organisation ID
                                  print('Selected Organisation ID: $value');
                                });
                              },
                              validator: (value) {
                                // Validation to ensure an organisation is selected
                                if (value == null || value.isEmpty) {
                                  return 'Please select an organisation';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _pickLegalDocument,
                              child: const Text("Upload Legal Document"),
                            ),
                            const SizedBox(height: 10),
                            if (uploadedFileName != null)
                              Text("File Uploaded: $uploadedFileName"),
                            const SizedBox(height: 20),
                            isEventCreationLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Colors.green.shade800,
                                      ),
                                    ),
                                    onPressed: creatingGroup,
                                    child: const Text(
                                      "Create",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
