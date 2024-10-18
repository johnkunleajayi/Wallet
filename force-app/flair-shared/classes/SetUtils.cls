public inherited sharing class SetUtils {
  public static Boolean isEmpty(Set<Id> values) {
    if (values == null || values.size() == 0) {
      return true;
    }
    if (values.size() == 1 && values.contains(null)) {
      return true;
    }
    return false;
  }
}