public with sharing class GangMatesAPIContributionsSummary extends GangMatesAPI {
  private static String REQUEST_ENDPOINT;

  public GangMatesAPIContributionsSummary() {
    REQUEST_ENDPOINT = API_ENDPOINT + '/contributions';
  }

  public void getCompanySummary(String companyId) {
    String requestEndpoint = REQUEST_ENDPOINT + '/company/' + companyId;
    parseGetCompanySummaryResponse(callApi(requestEndpoint, 'GET', null));
  }

  public void getUserSummary(String userId) {
    String requestEndpoint = REQUEST_ENDPOINT + '/user/' + userId;
    parseGetUserSummaryResponse(callApi(requestEndpoint, 'GET', null));
  }

  private void parseGetCompanySummaryResponse(String response) {
    List<CompanyResponse> companySummary = (List<CompanyResponse>) JSON.deserialize(
      response,
      List<CompanyResponse>.class
    );
    System.debug('companySummary: ' + companySummary);
  }

  private void parseGetUserSummaryResponse(String response) {
    List<CompanyResponse> userSummary = (List<CompanyResponse>) JSON.deserialize(
      response,
      List<CompanyResponse>.class
    );
    System.debug('userSummary: ' + userSummary);
  }

  public class CompanyResponse {
    public Integer id { get; set; }
    public Integer company_id { get; set; }
    public Integer employee_id { get; set; }
    public String pay_period_start { get; set; }
    public String pay_period_end { get; set; }
    public String itf_contribution { get; set; }
    public String nsitf_contribution { get; set; }
    public String ytd_itf_contribution { get; set; }
    public String ytd_nsitf_contribution { get; set; }
    public String created_at { get; set; }
    public String updated_at { get; set; }
    public String employee_pension_contribution { get; set; }
    public String employer_pension_contribution { get; set; }
    public String ytd_employee_pension_contribution { get; set; }
    public String ytd_employer_pension_contribution { get; set; }
    public String employee_nhis_contribution { get; set; }
    public String employer_nhis_contribution { get; set; }
    public String ytd_employee_nhis_contribution { get; set; }
    public String ytd_employer_nhis_contribution { get; set; }
    public String pit_contribution { get; set; }
    public String ytd_pit_contribution { get; set; }
    public String nhf_contribution { get; set; }
    public String ytd_nhf_contribution { get; set; }
  }
}