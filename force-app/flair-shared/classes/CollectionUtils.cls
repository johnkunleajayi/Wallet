public class CollectionUtils {
  public static Boolean isEmpty(Object[] objs) {
    return objs == null || objs.isEmpty();
  }

  public static Boolean isNotEmpty(Object[] objs) {
    return !isEmpty(objs);
  }
}