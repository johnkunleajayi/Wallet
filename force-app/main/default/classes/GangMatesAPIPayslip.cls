public with sharing class GangMatesAPIPayslip extends GangMatesAPI {
  private static String REQUEST_ENDPOINT;

  public GangMatesAPIPayslip() {
    REQUEST_ENDPOINT = API_ENDPOINT + '/paystubs';
  }

  public void getPayStubs() {
    parseGetPayStubsResponse(callApi(REQUEST_ENDPOINT, 'GET', null));
  }

  public void createPaystubs(PaystubsRequest request) {
    System.debug('request' + request);
    parseCreatePayStubsResponse(
      callApi(REQUEST_ENDPOINT, 'POST', JSON.serialize(request))
    );
  }

  private static void parseGetPayStubsResponse(String response) {
    response = response.replace('"from":', '"from_x":');
    PaystubsGetResponse payRes = (PaystubsGetResponse) JSON.deserialize(
      response,
      PaystubsGetResponse.class
    );
    System.debug('PayStubsGetResponse: ' + response);
  }

  private static void parseCreatePayStubsResponse(String response) {
    PaystubsCreateResponse payRes = (PaystubsCreateResponse) JSON.deserialize(
      response,
      PaystubsCreateResponse.class
    );
    System.debug('PaystubsCreateResponse: ' + response);
  }

  public class PaystubsRequest {
    public List<Paystub> paystubs { get; set; }
  }

  public class Paystub {
    public string id { get; set; }
    public string pay_period_start { get; set; }
    public string pay_period_end { get; set; }
    public decimal taxable_income { get; set; }
    public decimal reimbursements { get; set; }
    public decimal other_allowances { get; set; }
  }

  public class PaystubsCreateResponse {
    public list<PaystubResponse> created_paystubs { get; set; }
    public list<PaystubResponse> failed_paystubs { get; set; }
    public String message { get; set; }
  }
  public class PaystubResponse {
    public String status { get; set; }
    public String employee_name { get; set; }
    public Decimal gross_pay { get; set; }
    public String transaction_id { get; set; }
    public Decimal net_pay { get; set; }
    public Integer company_id { get; set; }
    public Decimal tax_withheld { get; set; }
    public Decimal other_allowances { get; set; }
    public Decimal pension_contribution { get; set; }
    public Decimal reimbursements { get; set; }
    public Decimal nhf_contribution { get; set; }
    public Decimal taxable_income { get; set; }
    public Decimal nhis_contribution { get; set; }
    public String pay_period_end { get; set; }
    public Decimal other_deductions { get; set; }
    public String pay_period_start { get; set; }
    public Decimal pay_rate { get; set; }
    public Decimal hours_worked { get; set; }
  }

  public class PaystubsGetResponse {
    public Integer last_page { get; set; }
    public String next_page_url { get; set; }
    public List<Links> links { get; set; }
    public String path { get; set; }
    public String last_page_url { get; set; }
    public Integer per_page { get; set; }
    public Integer from_x { get; set; }
    public String prev_page_url { get; set; }
    public String first_page_url { get; set; }
    public Integer to { get; set; }
    public List<Data> data { get; set; }
    public Integer total { get; set; }
    public Integer current_page { get; set; }
  }
  public class User {
    public String unique_id { get; set; }
    public String user_types { get; set; }
    public String personal_email { get; set; }
    public String address { get; set; }
    public String updated_at { get; set; }
    public String phone { get; set; }
    public String created_at { get; set; }
    public String document_paths { get; set; }
    public String email_verified_at { get; set; }
    public String token_expires_at { get; set; }
    public String email { get; set; }
    public Integer onboarding_completed { get; set; }
    public String last_name { get; set; }
    public Integer domain_id { get; set; }
    public String first_name { get; set; }
    public String level { get; set; }
    public String employee_id { get; set; }
    public String title { get; set; }
    public Integer manager_id { get; set; }
    public Decimal base_salary { get; set; }
    public Integer id { get; set; }
    public String department { get; set; }
    public Boolean is_active { get; set; }
    public Integer company_id { get; set; }
    public String manager { get; set; }
    public String deleted_at { get; set; }
    public String start_date { get; set; }
    public String office_location { get; set; }
    public String payment_frequency { get; set; }
    public Decimal allowances { get; set; }
  }
  public class Links {
    public String url { get; set; }
    public Boolean active { get; set; }
    public String label { get; set; }
  }
  public class Data {
    public Integer company_id { get; set; }
    public Decimal taxable_income { get; set; }
    public Decimal reimbursements { get; set; }
    public Decimal tax_withheld { get; set; }
    public Decimal deductions { get; set; }
    public Decimal other_allowances { get; set; }
    public Decimal gross_pay { get; set; }
    public Decimal net_pay { get; set; }
    public Decimal pay_rate { get; set; }
    public String created_at { get; set; }
    public Integer hours_worked { get; set; }
    public String updated_at { get; set; }
    public String pay_period_end { get; set; }
    public Decimal pension_contribution { get; set; }
    public String pay_period_start { get; set; }
    public Decimal nhf_contribution { get; set; }
    public String employee_name { get; set; }
    public Decimal nhis_contribution { get; set; }
    public String transaction_id { get; set; }
    public Decimal other_deductions { get; set; }
    public String email { get; set; }
    public String status { get; set; }
    public Integer user_id { get; set; }
    public user user { get; set; }
    public Integer id { get; set; }
  }
}