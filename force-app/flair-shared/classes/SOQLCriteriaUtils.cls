public class SOQLCriteriaUtils {
  public static String joinWithAnd(ISOQLCriteria[] conditions) {
    return join(conditions, 'AND');
  }

  public static String joinWithOr(ISOQLCriteria[] conditions) {
    return join(conditions, 'OR');
  }

  private static String join(ISOQLCriteria[] conditions, String operator) {
    if (CollectionUtils.isEmpty(conditions)) {
      return '';
    }

    String[] segments = new List<String>();

    for (ISOQLCriteria condition : conditions) {
      String conditionSOQL = condition.toSOQL();

      if (!String.isBlank(conditionSOQL)) {
        segments.add('(' + conditionSOQL + ')');
      }
    }

    String separator = ' ' + operator + ' ';
    return String.join(segments, separator);
  }
}
