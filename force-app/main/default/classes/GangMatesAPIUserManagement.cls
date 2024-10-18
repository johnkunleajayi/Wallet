public with sharing class GangMatesAPIUserManagement extends GangMatesAPI {
  private static String REQUEST_ENDPOINT;

  public GangMatesAPIUserManagement() {
    REQUEST_ENDPOINT = API_ENDPOINT + '/users';
  }

  public UserWrapper getUser(String userId) {
    String requestEndpoint = REQUEST_ENDPOINT + '/' + userId;
    return parseGetUserResponse(callApi(requestEndpoint, 'GET', null));
  }

  public AllUsersWrapper getUsers() {
    return parseGetUsersResponse(callApi(REQUEST_ENDPOINT, 'GET', null));
  }

  public UserCreatedFullResponse createUser(CreateUserRequest requestBody) {
    return parseCreateUserResponse(
      callApi(REQUEST_ENDPOINT, 'POST', JSON.serialize(requestBody))
    );
  }

  public UserUpdatedFullResponse updateUser(
    String userId,
    UpdateUserRequest requestBody
  ) {
    String requestEndpoint = REQUEST_ENDPOINT + '/' + userId;
    return parseUpdateUserResponse(
      callApi(requestEndpoint, 'PUT', JSON.serialize(requestBody))
    );
  }

  private static UserWrapper parseGetUserResponse(String response) {
    UserWrapper user = (UserWrapper) JSON.deserialize(
      response,
      UserWrapper.class
    );
    System.debug('user : ' + user);
    return user;
  }

  private static AllUsersWrapper parseGetUsersResponse(String response) {
    AllUsersWrapper allUsers = (AllUsersWrapper) JSON.deserialize(
      response,
      AllUsersWrapper.class
    );
    System.debug('all users : ' + allUsers);
    return allUsers;
  }

  private static UserCreatedFullResponse parseCreateUserResponse(
    String response
  ) {
    UserCreatedFullResponse user = (UserCreatedFullResponse) JSON.deserialize(
      response,
      UserCreatedFullResponse.class
    );
    System.debug('created user : ' + user);
    return user;
  }

  private static UserUpdatedFullResponse parseUpdateUserResponse(
    String response
  ) {
    UserUpdatedFullResponse user = (UserUpdatedFullResponse) JSON.deserialize(
      response,
      UserUpdatedFullResponse.class
    );
    System.debug('updated user : ' + user);
    return user;
  }

  public class AllUsersWrapper {
    public List<UserWrapper> Resources { get; set; }
    public Integer totalResults { get; set; }
  }

  public class UserWrapper {
    public Integer id { get; set; }
    public String manager_id { get; set; }
    public String employee_id { get; set; }
    public String first_name { get; set; }
    public String last_name { get; set; }
    public String email { get; set; }
    public String email_verified_at { get; set; }
    public String password { get; set; }
    public String created_at { get; set; }
    public String updated_at { get; set; }
    public String personal_email { get; set; }
    public String unique_id { get; set; }
    public String user_types { get; set; }
    public String address { get; set; }
    public String phone { get; set; }
    public String document_paths { get; set; }
    public String onboarding_token { get; set; }
    public String token_expires_at { get; set; }
    public Boolean onboarding_completed { get; set; }
    public Integer domain_id { get; set; }
    public String level { get; set; }
    public String title { get; set; }
    public Decimal base_salary { get; set; }
    public String department { get; set; }
    public Decimal allowances { get; set; }
    public String office_location { get; set; }
    public String payment_frequency { get; set; }
    public String start_date { get; set; }
    public String manager { get; set; }
    public Boolean is_active { get; set; }
    public Integer company_id { get; set; }
    public String deleted_at { get; set; }
  }

  public class CreateUserRequest {
    public String first_name { get; set; }
    public String last_name { get; set; }
    public String personal_email { get; set; } //must be unique in gangmates system
    public Integer domain_id { get; set; }
    public String user_types { get; set; }
    public String level { get; set; }
    public String title { get; set; }
    public Decimal base_salary { get; set; }
    public String department { get; set; }
    public Decimal allowances { get; set; }
    public String office_location { get; set; }
    public String roles { get; set; }
    public String payment_frequency { get; set; }
    public String start_date { get; set; }
    public Integer manager_id { get; set; }
  }

  public class UserCreatedFullResponse {
    public String message { get; set; }
    public UserCreatedResponse user { get; set; }
  }

  public class UpdateUserRequest {
    public String user_types { get; set; }
  }

  public class UserCreatedResponse {
    public Integer id { get; set; }
    public String manager_id { get; set; }
    public String employee_id { get; set; }
    public String first_name { get; set; }
    public String last_name { get; set; }
    public String email { get; set; }
    public String email_verified_at { get; set; }
    public String created_at { get; set; }
    public String updated_at { get; set; }
    public String personal_email { get; set; }
    public String unique_id { get; set; }
    public String user_types { get; set; }
    public String address { get; set; }
    public String phone { get; set; }
    public String document_paths { get; set; }
    public String token_expires_at { get; set; }
    public Boolean onboarding_completed { get; set; }
    public Integer domain_id { get; set; }
    public String level { get; set; }
    public String title { get; set; }
    public Decimal base_salary { get; set; }
    public String department { get; set; }
    public Decimal allowances { get; set; }
    public String office_location { get; set; }
    public String payment_frequency { get; set; }
    public String start_date { get; set; }
    public String manager { get; set; }
    public Boolean is_active { get; set; }
    public Integer company_id { get; set; }
    public String deleted_at { get; set; }
    public CompanyWrapper company { get; set; }
  }

  public class UserUpdatedFullResponse {
    public String message { get; set; }
    public UserUpdatedResponse user { get; set; }
  }

  public class UserUpdatedResponse {
    public Integer id { get; set; }
    public String manager_id { get; set; }
    public String employee_id { get; set; }
    public String first_name { get; set; }
    public String last_name { get; set; }
    public String email { get; set; }
    public String email_verified_at { get; set; }
    public String created_at { get; set; }
    public String updated_at { get; set; }
    public String personal_email { get; set; }
    public String unique_id { get; set; }
    public String user_types { get; set; }
    public String address { get; set; }
    public String phone { get; set; }
    public String document_paths { get; set; }
    public String token_expires_at { get; set; }
    public Integer onboarding_completed { get; set; }
    public Integer domain_id { get; set; }
    public String level { get; set; }
    public String title { get; set; }
    public Decimal base_salary { get; set; }
    public String department { get; set; }
    public Decimal allowances { get; set; }
    public String office_location { get; set; }
    public String payment_frequency { get; set; }
    public String start_date { get; set; }
    public String manager { get; set; }
    public Boolean is_active { get; set; }
    public Integer company_id { get; set; }
    public String deleted_at { get; set; }
    public DomainWrapper domain { get; set; }
  }

  public class DomainWrapper {
    public Integer id { get; set; }
    public String name { get; set; }
    public String display_name { get; set; }
    public Integer archived { get; set; }
    public String created_at { get; set; }
    public String updated_at { get; set; }
    public Integer company_id { get; set; }
  }

  public class CompanyWrapper {
    public Integer id { get; set; }
    public Integer created_by { get; set; }
    public String name { get; set; }
    public String created_at { get; set; }
    public String updated_at { get; set; }
    public String address { get; set; }
    public String code { get; set; }
    public String phone { get; set; }
    public Integer registration_id { get; set; }
    public String email_template { get; set; }
    public String domain { get; set; }
    public Integer is_active { get; set; }
    public String status { get; set; }
    public String eligible_user_types { get; set; }
    public String payment_frequency { get; set; }
  }
}