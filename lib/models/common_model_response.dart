class CommonModelResponse {
  final String? message;


  CommonModelResponse({
    this.message,
 
  });

  factory CommonModelResponse.fromJson(Map<String, dynamic> json) => CommonModelResponse(
    message: json["message"],

  );

  Map<String, dynamic> toJson() => {
    "message": message,
 
  };
}



