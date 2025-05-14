import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:ride_sharing_user_app/features/out_of_zone/domain/models/zone_list_model.dart';

class MapHelper{

  /// Algorithm of NearestPolygone
// Function to calculate the distance from the point to the closest polygon edge
  static double calculateDistanceToPolygon(LatLngPoint point, List<LatLngPoint> polygon) {
    double minDistance = double.infinity;
    for (int i = 0; i < polygon.length - 1; i++) {
      LatLngPoint vertex1 = polygon[i];
      LatLngPoint vertex2 = polygon[i + 1];

      double distance = distanceToSegment(point, vertex1, vertex2);
      if (distance < minDistance) {
        minDistance = distance;
      }
    }

    return minDistance;
  }

// Function to calculate the distance from a point to a line segment
  static double distanceToSegment(LatLngPoint point, LatLngPoint vertex1, LatLngPoint vertex2) {
    // Calculate geodesic distances between the point and the vertices
    double distanceToVertex1 = Geolocator.distanceBetween(
      point.latitude, point.longitude,
      vertex1.latitude, vertex1.longitude,
    );

    double distanceToVertex2 = Geolocator.distanceBetween(
      point.latitude, point.longitude,
      vertex2.latitude, vertex2.longitude,
    );

    // Return the smaller distance (this is a simplified method, but effective)
    return min(distanceToVertex1, distanceToVertex2);
  }

// Function to find the nearest polygon
  static List<LatLngPoint> findNearestPolygon(LatLngPoint point, List<List<LatLngPoint>> polygons) {
    double minDistance = double.infinity;
    List<LatLngPoint>? nearestPolygon;

    for (List<LatLngPoint> polygon in polygons) {
      double distance = calculateDistanceToPolygon(point, polygon);

      if (distance < minDistance) {
        minDistance = distance;
        nearestPolygon = polygon;
      }
    }
    return nearestPolygon!;
  }


  /// Algorithm of is Inside of zone

// Function to check if the point is inside the polygon
  static bool isPointInPolygon(LatLngPoint point, List<LatLngPoint> polygon) {
    int intersectCount = 0;
    for (int i = 0; i < polygon.length - 1; i++) {
      LatLngPoint vertex1 = polygon[i];
      LatLngPoint vertex2 = polygon[i + 1];

      // Check if point.y is between the y coordinates of the two vertices
      if (rayIntersectsSegment(point, vertex1, vertex2)) {
        intersectCount++;
      }
    }
    // If the number of intersections is odd, the point is inside the polygon.
    return (intersectCount % 2) == 1;
  }

// Function to check if a ray intersects a segment between two points
  static bool rayIntersectsSegment(LatLngPoint point, LatLngPoint vertex1, LatLngPoint vertex2) {
    if (vertex1.latitude > vertex2.latitude) {
      LatLngPoint temp = vertex1;
      vertex1 = vertex2;
      vertex2 = temp;
    }

    if (point.latitude == vertex1.latitude || point.latitude == vertex2.latitude) {
      point = LatLngPoint(point.latitude + 0.00000001, point.longitude);
    }

    if (point.latitude > vertex2.latitude || point.latitude < vertex1.latitude || point.longitude >= max(vertex1.longitude, vertex2.longitude)) {
      return false;
    }

    if (point.longitude < min(vertex1.longitude, vertex2.longitude)) {
      return true;
    }

    double slope = (vertex2.longitude - vertex1.longitude) /
        (vertex2.latitude - vertex1.latitude);
    double intersectLongitude =
        (point.latitude - vertex1.latitude) * slope + vertex1.longitude;

    return point.longitude <= intersectLongitude;
  }

}