/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class GangMatesAPIContributionsSettingsTest {
  @isTest
  static void testGetContributionSettings() {
    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
    mock.setStaticResource(
      'GangMatesAPI_getContributionSettingsByCompanyResponse'
    );
    mock.setStatusCode(200);
    mock.setHeader('Content-Type', 'application/json');
    Test.setMock(HttpCalloutMock.class, mock);
    GangMatesAPIContributionsSettings.ContributionSettingsResponse result = new GangMatesAPIContributionsSettings()
      .getContributionSettings();
    Assert.areEqual(5, result.id, 'The callout didn\'t the right result.');
  }
  static void testGetContributionSettingsByCompany() {
    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
    mock.setStaticResource(
      'GangMatesAPI_getContributionSettingsByCompanyResponse'
    );
    mock.setStatusCode(200);
    mock.setHeader('Content-Type', 'application/json');
    Test.setMock(HttpCalloutMock.class, mock);
    GangMatesAPIContributionsSettings.ContributionSettingsResponse result = new GangMatesAPIContributionsSettings()
      .getContributionSettingsByCompany('17');
    Assert.areEqual(
      'federal',
      result.employment_type,
      'The callout didn\'t the right result.'
    );
  }
  static void testUpdateCompanyContributionSettings() {
    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
    mock.setStaticResource(
      'GangMatesAPI_updateCompanyContributionSettingsResponse'
    );
    mock.setStatusCode(200);
    mock.setHeader('Content-Type', 'application/json');
    GangMatesAPIContributionsSettings.CompanyContributionSettingsRequest request = new GangMatesAPIContributionsSettings.CompanyContributionSettingsRequest();
    request.charitable_donations = 0;
    request.cooperative_contributions = 0;
    request.employment_type = 'federal';
    request.itf = 1;
    request.loan_repayment = 0;
    request.nhf = 1;
    request.nhis = 0;
    request.nsitf = 1;
    request.other_deductions = 0;
    request.pension = 1;
    request.union_dues = 0;
    Test.setMock(HttpCalloutMock.class, mock);
    GangMatesAPIContributionsSettings.updateCompanyContributionSettingsResponse result = new GangMatesAPIContributionsSettings()
      .updateCompanyContributionSettings('17', request);
    Assert.areEqual(
      'Contribution settings updated successfully',
      result.message,
      'The callout didn\'t the right result.'
    );
  }
}