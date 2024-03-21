import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ReferenceController extends GetxController {
  Rx<DocumentReference?> truckDocReference = Rx(null);
  RxBool isfromTruck = false.obs;
  // get getTruckReference()=> truckDocReference;
}
