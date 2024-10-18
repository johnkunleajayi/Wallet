public with sharing class GangMatesAPICompanies extends GangMatesAPI {
  private static String REQUEST_ENDPOINT;

  public GangMatesAPICompanies() {
    REQUEST_ENDPOINT = API_ENDPOINT + '/companies';
  }

  public void getCompany(String companyId) {
    String requestEndpoint = REQUEST_ENDPOINT + '/' + companyId;
    parseGetCompanyResponse(callApi(requestEndpoint, 'GET', null));
  }

  public void getCompanies() {
    parseGetCompaniesResponse(callApi(REQUEST_ENDPOINT, 'GET', null));
  }

  public void createCompany(CreateCompanyRequest requestBody) {
    parseCreateCompanyResponse(
      callApi(REQUEST_ENDPOINT, 'POST', JSON.serialize(requestBody))
    );
  }

  public void updateCompany(
    String companyId,
    UpdateCompanyRequest requestBody
  ) {
    String requestEndpoint = REQUEST_ENDPOINT + '/' + companyId;
    parseUpdateCompanyResponse(
      callApi(requestEndpoint, 'PUT', JSON.serialize(requestBody))
    );
  }

  public void activateCompany(String companyId) {
    String requestEndpoint = REQUEST_ENDPOINT + '/' + companyId + '/activate';
    parseDeactivateCompanyResponse(callApi(requestEndpoint, 'PATCH', null));
  }

  public void deactivateCompany(String companyId) {
    String requestEndpoint = REQUEST_ENDPOINT + '/' + companyId + '/deactivate';
    parseActivateCompanyResponse(callApi(requestEndpoint, 'PATCH', null));
  }

  private static void parseGetCompanyResponse(String response) {
    CompanyData company = (CompanyData) JSON.deserialize(
      response,
      CompanyData.class
    );

    System.debug('company : ' + company);
  }

  private static void parseGetCompaniesResponse(String response) {
    response = response.replace('"from":', '"from_x":');
    GetCompaniesResponse companies = (GetCompaniesResponse) JSON.deserialize(
      response,
      GetCompaniesResponse.class
    );
    System.debug('companies : ' + companies);
  }

  private static void parseCreateCompanyResponse(String response) {
    CreateCompanyResponse company = (CreateCompanyResponse) JSON.deserialize(
      response,
      CreateCompanyResponse.class
    );
    System.debug('created company : ' + company);
  }

  private static void parseUpdateCompanyResponse(String response) {
    UpdateCompanyResponse company = (UpdateCompanyResponse) JSON.deserialize(
      response,
      UpdateCompanyResponse.class
    );
    System.debug('updated company : ' + company);
  }

  private static void parseActivateCompanyResponse(String response) {
    ActivationResponse res = (ActivationResponse) JSON.deserialize(
      response,
      ActivationResponse.class
    );
    System.debug('response: ' + res);
  }

  private static void parseDeactivateCompanyResponse(String response) {
    ActivationResponse res = (ActivationResponse) JSON.deserialize(
      response,
      ActivationResponse.class
    );
    System.debug('response: ' + res);
  }

  private class GetCompaniesResponse {
    public Integer total { get; set; }
    public Integer current_page { get; set; }
    public List<CompanyData> data { get; set; }
    public String first_page_url { get; set; }
    public String from_x { get; set; }
    public Integer last_page { get; set; }
    public String last_page_url { get; set; }
    public List<Link> links { get; set; }
    public String next_page_url { get; set; }
    public String path { get; set; }
    public Integer per_page { get; set; }
    public String prev_page_url { get; set; }
    public String to { get; set; }
  }

  public class Link {
    public Boolean active { get; set; }
    public String label { get; set; }
    public String url { get; set; }
  }

  public class CompanyData {
    public String registration_id { get; set; }
    public String phone { get; set; }
    public String code { get; set; } // must be filled to avoid 500
    public String email_template { get; set; }
    public String address { get; set; }
    public String domain { get; set; }
    public String updated_at { get; set; }
    public Integer is_active { get; set; }
    public String created_at { get; set; }
    public String status { get; set; }
    public String name { get; set; }
    public String eligible_user_types { get; set; }
    public Integer created_by { get; set; }
    public String payment_frequency { get; set; }
    public Integer id { get; set; }
  }

  public class CreateCompanyRequest {
    public String name { get; set; } // required
    public String address { get; set; }
    public String phone { get; set; }
    public String registration_id { get; set; }
    public String first_name { get; set; } // required
    public String last_name { get; set; } // required
    public String personal_email { get; set; } // required
    public String title { get; set; } // required
    public String domain_name { get; set; } // required
    public String email_template { get; set; } // required
    public String payment_frequency { get; set; } // required
  }

  private class CreateCompanyResponse {
    public String success { get; set; }
    public CompanyData company { get; set; }
  }

  public class UpdateCompanyRequest {
    public String name { get; set; }
    public String address { get; set; }
    public String phone { get; set; }
    public String registration_id { get; set; }
    public String email_template { get; set; }
    public String code { get; set; }
    public String domain { get; set; }
    public String payment_frequency { get; set; }
  }

  public class UpdateCompanyResponse {
    public String message { get; set; }
    public CompanyData company { get; set; }
  }

  public class ActivationResponse {
    public String message { get; set; }
  }
}