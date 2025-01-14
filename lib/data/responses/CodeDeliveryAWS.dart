class CodeDeliveryAWS {
  final CodeDeliveryDetails codeDeliveryDetails;

  CodeDeliveryAWS({required this.codeDeliveryDetails});

  factory CodeDeliveryAWS.fromJson(Map<String, dynamic> json) {
    return CodeDeliveryAWS(
      codeDeliveryDetails:
          CodeDeliveryDetails.fromJson(json['CodeDeliveryDetails']),
    );
  }
}

class CodeDeliveryDetails {
  final String attributeName;
  final String deliveryMedium;
  final String destination;

  CodeDeliveryDetails({
    required this.attributeName,
    required this.deliveryMedium,
    required this.destination,
  });

  factory CodeDeliveryDetails.fromJson(Map<String, dynamic> json) {
    return CodeDeliveryDetails(
      attributeName: json['AttributeName'],
      deliveryMedium: json['DeliveryMedium'],
      destination: json['Destination'],
    );
  }
}

// Usage:
// Map<String, dynamic> json = {
//   'CodeDeliveryDetails': {
//     'AttributeName': 'email',
//     'DeliveryMedium': 'EMAIL',
//     'Destination': 'r***@g***',
//   },
// };

// CodeDeliveryAWS codeDeliveryAWS = CodeDeliveryAWS.fromJson(json);