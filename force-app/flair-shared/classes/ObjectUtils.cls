public class ObjectUtils {
  public static Integer hashCode(Object obj) {
    if (obj == null) {
      return 0;
    }

    if (obj instanceof Id) {
      return System.hashCode(String.valueOf(obj));
    }

    return System.hashCode(obj);
  }
}