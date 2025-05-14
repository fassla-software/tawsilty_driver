import 'package:ride_sharing_user_app/features/out_of_zone/domain/repositories/out_of_zone_repository_interface.dart';
import 'package:ride_sharing_user_app/features/out_of_zone/domain/service/out_of_zone_service_interface.dart';

class OutOfZoneService implements OutOfZoneServiceInterface {
 final OutOfZoneRepositoryInterface outOfZoneRepositoryInterface;

 OutOfZoneService({required this.outOfZoneRepositoryInterface});

  @override
  Future getZoneList() {
    return outOfZoneRepositoryInterface.getZoneList();
  }


}