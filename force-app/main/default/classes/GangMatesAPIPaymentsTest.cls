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
private class GangMatesAPIPaymentsTest {
  @isTest
  static void testProcessPayment() {
    // Create the mock response based on a static resource
    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
    mock.setStaticResource('GangMatesAPI_ProcessPaymentResponse');
    mock.setStatusCode(200);
    mock.setHeader('Content-Type', 'application/json');
    // Associate the callout with a mock response
    Test.setMock(HttpCalloutMock.class, mock);
    // Call method to test
    GangMatesAPIPayments.ProcessPaymentRequest request = new GangMatesAPIPayments.ProcessPaymentRequest();
    request.one_time_type = 'one_time';
    request.payment_date = '2024-08-22';
    request.payment_type = 'paystub';
    request.transaction_id = 'VC13-1M84XM';
    request.user_id = 125;
    GangMatesAPIPayments.ProcessPaymentResponse result = new GangMatesAPIPayments()
      .processPayment(request);
    // Verify total results are 10 users
    Assert.areEqual(
      'Payment processed successfully.',
      result.message,
      'The callout didn\'t updated the user.'
    );
  }
}