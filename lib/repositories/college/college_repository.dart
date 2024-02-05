import 'dart:io';
import 'package:dio/dio.dart';
import 'package:faculty_app/models/admin/complaints_list_reponse.dart';
import 'package:faculty_app/models/common_response.dart';
import 'package:faculty_app/network/api_provider.dart';
import 'package:faculty_app/network/apis.dart';
import 'package:faculty_app/ui/college/college_home_screen.dart';
import 'package:faculty_app/utils/api_helper.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';

class CollegeRepository {
  ApiProvider? apiClient;

  CollegeRepository() {
    if (apiClient == null) apiClient = new ApiProvider();
  }

  Future<ComplaintsListResponse> getCollegeComplaintList(
      int perPage, int page) async {
    final response = await apiClient!.getJsonInstance().get(
        '${Apis.fetchCollegeComplaints}?page=$page&per_page=$perPage');
    return ComplaintsListResponse.fromJson(response.data);
  }

  Future<ComplaintsListResponse> getCollegeOtherComplaintList(
      int perPage, int page,bool global) async {
    final response = await apiClient!.getJsonInstance().get(
        '${Apis.fetchCollegeComplaints}?page=$page&per_page=$perPage&global=$global');
    return ComplaintsListResponse.fromJson(response.data);
  }

  Future<CommonResponse> addComplaint(
      String name,
      String email,
      String phone,
      String address,
      String department,
      String subject,
      String complaint,
      String intensity,
      String adharNo,
      String details,
      File? image,
      ) async {
    String fileName = image?.path?.split('/')?.last ?? "";
    MultipartFile? imageFile;
    print("bhb${image != null}");
    if (image != null) {
      imageFile = await MultipartFile.fromFile(image.path, filename: fileName);
    }

    FormData formData = FormData.fromMap({
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
      "department": department,
      "subject": subject,
      "complaint": complaint,
      "level": intensity,
      "aadhar": adharNo,
      "image": imageFile,
      if (details.isNotEmpty) "remarks": details,
    });

    Response response = await apiClient!
        .getJsonInstance()
        .post(Apis.addComplaint, data: formData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.data!);
      toastMessage("${response.data['message']}");
      Get.to(() => CollegeHomeScreen());
      return CommonResponse.fromJson(response.data);
    } else {
      toastMessage("${response.data['message']}");
      print(
          "###########__________________ADD COMMITTEE UNSUCCESSFULLY________________##############");
      throw "";
    }
  }
}