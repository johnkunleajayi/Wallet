public with sharing class GangMatesAPIPayments extends GangMatesAPI {
  private static String REQUEST_ENDPOINT;

  public GangMatesAPIPayments() {
    REQUEST_ENDPOINT = API_ENDPOINT + '/process-payment';
  }

  public ProcessPaymentResponse processPayment(
    ProcessPaymentRequest requestBody
  ) {
    String response = callApi(
      REQUEST_ENDPOINT,
      'POST',
      JSON.serialize(requestBody)
    );
    response = response.replace('"0":', '"zero":');
    response = response.replace('"currency":', '"currency_x":');
    return parseProcessPaymentResponse(response);
  }

  private static ProcessPaymentResponse parseProcessPaymentResponse(
    String response
  ) {
    ProcessPaymentResponse payRes = (ProcessPaymentResponse) JSON.deserialize(
      response,
      ProcessPaymentResponse.class
    );
    System.debug('payment processed response : ' + payRes);
    return payRes;
  }

  public class ProcessPaymentRequest {
    public Integer user_id { get; set; }
    public string payment_type { get; set; }
    public string payment_date { get; set; }
    public string one_time_type { get; set; }
    public string transaction_id { get; set; }
  }

  public class ProcessPaymentResponse {
    public String zero { get; set; }
    public String message { get; set; }
    public ProcessPaymentResponseData data { get; set; }
  }

  private class ProcessPaymentResponseData {
    public String status { get; set; }
    public String message { get; set; }
    public ProcessPaymentResponseTransfertData data { get; set; }
    public String response_code { get; set; }
  }

  private class ProcessPaymentResponseTransfertData {
    public String[] transfersessionid { get; set; }
    public String domain { get; set; }
    public String amount { get; set; }
    public String currency_x { get; set; }
    public String reference { get; set; }
    public String source { get; set; }
    public String source_details { get; set; }
    public String reason { get; set; }
    public String status { get; set; }
    public String failures { get; set; }
    public String transfer_code { get; set; }
    public String titan_code { get; set; }
    public String transferred_at { get; set; }
    public Integer id { get; set; }
    public Integer integration { get; set; }
    public Integer request { get; set; }
    public String recipient { get; set; }
    public String createdAt { get; set; }
    public String updatedAt { get; set; }
  }
}