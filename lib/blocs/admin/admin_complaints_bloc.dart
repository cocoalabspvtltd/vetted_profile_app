import 'dart:async';
import 'package:faculty_app/interface/load_more_listener.dart';
import 'package:faculty_app/models/admin/complaints_list_reponse.dart';
import 'package:faculty_app/models/common_response.dart';
import 'package:faculty_app/network/api_error_message.dart';
import 'package:faculty_app/network/apis_response.dart';
import 'package:faculty_app/repositories/admin/admin_repository.dart';
import 'package:faculty_app/utils/api_helper.dart';

class AdminComplaintBloc {
  AdminRepository? _repository;

  AdminComplaintBloc({this.listener}) {
    if (_repository == null)
      _repository = AdminRepository();
    _complaintsListController =
    StreamController<ApiResponse<ComplaintsListResponse>>.broadcast();
  }

  bool hasNextPage = false;
  int pageNumber = 1;
  int perPage = 10;

  LoadMoreListener? listener;

  late StreamController<ApiResponse<ComplaintsListResponse>>
  _complaintsListController;

  StreamSink<ApiResponse<ComplaintsListResponse>>?
  get complaintDetailsListSink => _complaintsListController.sink;

  Stream<ApiResponse<ComplaintsListResponse>> get complaintDetailsListStream =>
      _complaintsListController.stream;

  List<Profiles> complaintList = [];

  getComplaintsList(bool isPagination, {int? perPage}) async {
    if (isPagination) {
      pageNumber = pageNumber + 1;
      listener!.refresh(true);
    } else {
      complaintDetailsListSink!.add(ApiResponse.loading('Fetching Data'));
      pageNumber = 1;
    }

    try {
      ComplaintsListResponse response = await _repository!.getcomplaintList(perPage ?? 10, pageNumber);

      if (response.pages != null && response.pages!.lastPage != null) {
        // Extract the page number from the last_page URL
        int lastPage = int.tryParse(Uri.parse(response.pages!.lastPage!).queryParameters['page'] ?? '') ?? 0;

        // Check if hasNextPage
        hasNextPage = lastPage >= pageNumber;

        if (isPagination) {
          if (complaintList.length == 0) {
            complaintList = response.profiles!;
          } else {
            complaintList.addAll(response.profiles!);
          }
        } else {
          complaintList = response.profiles ?? [];
        }

        complaintDetailsListSink!.add(ApiResponse.completed(response));
        if (isPagination) {
          listener!.refresh(false);
        }
      } else {
        // Handle the case when pages or lastPage is null
        complaintDetailsListSink!.add(ApiResponse.error("Invalid response format"));
        if (isPagination) {
          listener!.refresh(false);
        }
      }
    } catch (error, s) {
      Completer().completeError(error, s);
      if (isPagination) {
        listener!.refresh(false);
      } else {
        complaintDetailsListSink!.add(ApiResponse.error(ApiErrorMessage.getNetworkError(error)));
      }
    } finally {
      // Cleanup or additional logic if needed
    }
  }


  Future<CommonResponse?> deleteComplaint(String complaintId) async {
    try {
      CommonResponse response = await _repository!
          .deleteComplaint(complaintId);
      toastMessage(response.message);
      return response;
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }


}
