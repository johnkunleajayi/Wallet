@isTest
private class GangMatesAPIUserManagementTest {
  @isTest
  static void testGetUsers() {
    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
    mock.setStaticResource('GangMatesAPI_GetUsersResponse');
    mock.setStatusCode(200);
    mock.setHeader('Content-Type', 'application/json');
    Test.setMock(HttpCalloutMock.class, mock);
    GangMatesAPIUserManagement.AllUsersWrapper result = new GangMatesAPIUserManagement()
      .getUsers();
    Assert.areEqual(
      10,
      result.totalResults,
      'The callout didn\'t returned 10 users.'
    );
  }

  @isTest
  static void testGetUser() {
    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
    mock.setStaticResource('GangMatesAPI_GetUserResponse');
    mock.setStatusCode(200);
    mock.setHeader('Content-Type', 'application/json');
    Test.setMock(HttpCalloutMock.class, mock);
    GangMatesAPIUserManagement.UserWrapper result = new GangMatesAPIUserManagement()
      .getUser('123');
    Assert.areEqual(
      'Support',
      result.first_name,
      'The callout didn\'t returned the user firstname.'
    );
  }

  @isTest
  static void testCreateUser() {
    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
    mock.setStaticResource('GangMatesAPI_CreateUserResponse');
    mock.setStatusCode(200);
    mock.setHeader('Content-Type', 'application/json');
    GangMatesAPIUserManagement.CreateUserRequest request = new GangMatesAPIUserManagement.CreateUserRequest();
    request.first_name = 'Emma';
    request.last_name = 'Tyler5';
    request.personal_email = 'test@example.com';
    request.domain_id = 1;
    request.user_types = 'Regular';
    request.level = 'L4';
    request.title = 'Manager';
    request.base_salary = 90000;
    request.department = 'Engineering';
    request.allowances = 900;
    request.office_location = 'HQ';
    request.roles = 'user';
    request.payment_frequency = 'Monthly';
    request.start_date = '2024-08-29';
    request.manager_id = 40;
    Test.setMock(HttpCalloutMock.class, mock);
    GangMatesAPIUserManagement.UserCreatedFullResponse result = new GangMatesAPIUserManagement()
      .createUser(request);
    Assert.areEqual(
      'API User created successfully',
      result.message,
      'The callout didn\'t updated the user.'
    );
  }

  @isTest
  static void testUpdateUser() {
    StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
    mock.setStaticResource('GangMatesAPI_UpdateUserResponse');
    mock.setStatusCode(200);
    mock.setHeader('Content-Type', 'application/json');
    Test.setMock(HttpCalloutMock.class, mock);
    GangMatesAPIUserManagement.UpdateUserRequest request = new GangMatesAPIUserManagement.UpdateUserRequest();
    request.user_types = 'Regular';
    GangMatesAPIUserManagement.UserUpdatedFullResponse result = new GangMatesAPIUserManagement()
      .updateUser('123', request);
    Assert.areEqual(
      'User updated successfully via API',
      result.message,
      'The callout didn\'t updated the user.'
    );
  }
}