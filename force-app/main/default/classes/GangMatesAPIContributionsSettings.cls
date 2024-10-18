public with sharing class GangMatesAPIContributionsSettings extends GangMatesAPI {
  private static String REQUEST_ENDPOINT;

  public GangMatesAPIContributionsSettings() {
    REQUEST_ENDPOINT = API_ENDPOINT + '/contribution-settings';
  }

  public ContributionSettingsResponse getContributionSettings() {
    return parseGetContributionSettingsResponse(
      callApi(REQUEST_ENDPOINT, 'GET', null)
    );
  }

  public ContributionSettingsResponse getContributionSettingsByCompany(
    String companyId
  ) {
    String requestEndpoint = REQUEST_ENDPOINT + '/' + companyId;
    return parseGetContributionSettingsResponse(
      callApi(REQUEST_ENDPOINT, 'GET', null)
    );
  }

  public updateCompanyContributionSettingsResponse updateCompanyContributionSettings(
    String companyId,
    CompanyContributionSettingsRequest request
  ) {
    String requestEndpoint = REQUEST_ENDPOINT + '/' + companyId;
    return parseUpdateCompanyContributionSettingsResponse(
      callApi(REQUEST_ENDPOINT, 'PATCH', JSON.serialize(request))
    );
  }

  private ContributionSettingsResponse parseGetContributionSettingsResponse(
    String response
  ) {
    ContributionSettingsResponse setRes = (ContributionSettingsResponse) JSON.deserialize(
      response,
      ContributionSettingsResponse.class
    );
    System.debug('setRes : ' + setRes);
    return setRes;
  }

  private updateCompanyContributionSettingsResponse parseUpdateCompanyContributionSettingsResponse(
    String response
  ) {
    updateCompanyContributionSettingsResponse setRes = (updateCompanyContributionSettingsResponse) JSON.deserialize(
      response,
      updateCompanyContributionSettingsResponse.class
    );
    System.debug('setRes : ' + setRes);
    return setRes;
  }

  public class CompanyContributionSettingsRequest {
    public Integer pension { get; set; }
    public Integer nhf { get; set; }
    public Integer nhis { get; set; }
    public Integer union_dues { get; set; }
    public Integer cooperative_contributions { get; set; }
    public Integer other_deductions { get; set; }
    public Integer loan_repayment { get; set; }
    public Integer charitable_donations { get; set; }
    public String employment_type { get; set; }
    public Integer itf { get; set; }
    public Integer nsitf { get; set; }
  }

  public class ContributionSettingsResponse {
    public Integer id { get; set; }
    public Integer company_id { get; set; }
    public String employment_type { get; set; }
    public Integer pension { get; set; }
    public Integer nhf { get; set; }
    public Integer nhis { get; set; }
    public Integer union_dues { get; set; }
    public Integer cooperative_contributions { get; set; }
    public Integer other_deductions { get; set; }
    public Integer loan_repayment { get; set; }
    public Integer charitable_donations { get; set; }
    public String created_at { get; set; }
    public String updated_at { get; set; }
    public Integer itf { get; set; }
    public Integer nsitf { get; set; }
  }

  public class updateCompanyContributionSettingsResponse {
    public String message { get; set; }
  }
}