public inherited sharing class ListUtils {
  public static List<Object> removeNulls(List<Object> values) {
    List<Object> notNull = new List<Object>();
    for (Object value : values) {
      if (value != null) {
        notNull.add(value);
      }
    }
    return notNull;
  }

  public static Boolean isEmpty(List<Object> values) {
    return values == null || values.isEmpty();
  }
}