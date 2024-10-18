/* 
Was changed and removed Labels from constants
*/
public class Constants {
  public static final String NAMESPACE = 'flair';
  public static final String OUTCOME_HIRED = 'Hired';
  public static final String OUTCOME_REJECTED = 'Rejected';

  public static final String CANDIDATE_FUNNEL_STAGE_HIRED = 'HIRED';
  public static final String CANDIDATE_FUNNEL_STAGE_REJECTED = 'REJECTED';

  public static final String JOB_PUBLISH_STATE_NOT_PUBLISHED = 'Not published';
  public static final String JOB_PUBLISH_STATE_PUBLISHED = 'Published';

  public static final String JOB_STATUS_OPEN = 'Open';
  public static final String JOB_STATUS_REJECTION = 'Candidates Rejection';
  public static final String JOB_STATUS_CLOSED = 'Closed';

  public static final String JOB_DEFAULT_LANGUAGE_NAME = 'English';
  public static final String JOB_DEFAULT_LANGUAGE = 'en';

  public static final String FEEDBACK_QUESTION_FREE_TEXT = 'Free Text';
  public static final String FEEDBACK_QUESTION_SINGLE_CHOICE = 'Single Choice';
  public static final String FEEDBACK_QUESTION_MULTIPLE_CHOICE = 'Multiple Choice';

  public static final String FEEDBACK_REQUEST_STATE_SUBMITTED = 'Submitted';

  public static final String FEEDBACK_CYCLE_STATE_IN_PROGRESS = 'In Progress';

  public static final String MONTHLY_WORKLOAD = 'Monthly';
  public static final String WEEKLY_WORKLOAD = 'Weekly';

  public static final String ABSENCE_APPROVED = 'APPROVED';
  public static final String ABSENCE_PENDING = 'PENDING';
  public static final String ABSENCE_REJECTED = 'REJECTED';
  public static final String DAILY_ABSENCE = 'DAILY';
  public static final String HOURLY_ABSENCE = 'HOURLY';

  public static final String HOURLY_SALARY = 'Hourly';

  public static final String EMPLOYEE_OBJECTIVE_RATE_OPEN = 'OPEN';
  public static final String EMPLOYEE_OBJECTIVE_RATE_FULFILLED = 'FULFILLED';

  public static final String SHARE_ROW_CAUSE_MANUAL = 'Manual';
  public static final String SHARE_ROW_CAUSE_OWNER = 'Owner';

  public static final String SHARE_ACCESS_LEVEL_ALL = 'All';
  public static final String SHARE_ACCESS_LEVEL_READ = 'Read';
  public static final String SHARE_ACCESS_LEVEL_EDIT = 'Edit';

  public static final String LAST_DAY_OF_MONTH = 'LAST_DAY';
  public static final String DEFAULT_HUB = 'DEFAULT_HUB';

  public static final Time HALF_DAY_TIME = Time.newInstance(12, 0, 0, 0);

  public static final String SELF_SERVICE_ORIGIN = 'self-service';
  public static final String EMPLOYEE_HUB_ORIGIN = 'employee-hub';
  public static final String EMPLOYEE_HUB_MOBILE_ORIGIN = 'employee-hub-mobile';

  public static final String PAYROLL_RUN_DRAFT = 'Draft';
  public static final String PAYROLL_RUN_PENDING_APPROVAL = 'Pending Approval';
  public static final String PAYROLL_RUN_COMPLETED = 'Completed';

  public static final string EMPLOYEE_HUB_URL = 'https://hub.flair.hr/';
  public static final string EMPLOYEE_HUB_DEV_URL = 'https://hub.dev.flair.hr/';

  public static final string BILLING_API_URL = 'https://jobsinternal.flair.hr/';

  public static final List<String> HUB_LANGUAGES = new List<String>{
    'en-US',
    'en',
    'de',
    'de-CH',
    'it',
    'es',
    'ru',
    'fr'
  };

  public static final String INTEGRATION_URL = 'https://integrations.flair.hr';
  public static final String API_URL = 'https://api.flair.hr';

  public static final String INTEGRATION_URL_STAGING = 'https://integrations-staging.flair.hr';
  public static final String API_URL_STAGING = 'https://api-staging.flair.hr';

  public static final String ISO8601_DATE_FORMAT = 'yyyy-MM-dd\'T\'HH:mm:ss\'Z\'';

  public static final String[] ADVERTISING_INTEGRATIONS = new List<String>{
    'VONQ',
    'JOIN'
  };

  public static final String DOCGEN_INTEGRATION = 'DOCGEN';
  public static final String AI_INTEGRATION = 'AI';
  public static final String CUSTOM_FORM_LAYOUT_NAME = 'CustomFormLayout';

  public static final string EMPLOYEE_HUB_API_URL = 'https://hub.flair.hr/';
  public static final string EMPLOYEE_HUB_DEV_API_URL = 'https://hub.dev.flair.hr/';
}