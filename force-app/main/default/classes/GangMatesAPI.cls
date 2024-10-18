public with sharing virtual class GangMatesAPI {
  public static final String API_ENDPOINT = 'callout:GangMates_API';
  private static final String API_TOKEN = GangMates_API_Setting__mdt.getAll()
    .get('Staging')
    .Token__c;

  public static String callApi(
    String requestEndpoint,
    String requestMethod,
    String body
  ) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(requestEndpoint);
    request.setMethod(requestMethod);
    request.setHeader('Authorization', 'Bearer ' + API_TOKEN);
    request.setHeader('Accept', 'application/json');

    if (body != null) {
      request.setBody(body);
      request.setHeader('Content-Type', 'application/json');
    }

    HttpResponse response = http.send(request);
    final Boolean isSuccessfulResponse = String.valueOf(
        response.getStatusCode()
      )
      .startsWith('20');

    if (isSuccessfulResponse) {
      return response.getBody();
    } else {
      ErrorResponse erRes = (ErrorResponse) JSON.deserialize(
        response.getBody(),
        ErrorResponse.class
      );
      throw new CalloutException(
        'An Exception occured | Code : ' +
          response.getStatusCode() +
          ' | Status : ' +
          response.getStatus() +
          ' | Message : ' +
          erRes.error
      );
    }
  }

  public class ErrorResponse {
    public String error { get; set; }
    public ErrorMessage messages { get; set; }
  }

  public class ErrorMessage {
    public List<String> domain_name { get; set; }
    public List<String> payment_frequency { get; set; }
  }
}