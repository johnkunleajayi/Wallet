public class Pair {
  private Object key;
  private Object value;

  public static Pair of(Object key, Object value) {
    return new Pair(key, value);
  }

  public Pair(Object key, Object value) {
    this.key = key;
    this.value = value;
  }

  public Object getKey() {
    return this.key;
  }

  public Object getValue() {
    return this.value;
  }

  public Boolean equals(Object obj) {
    if (this === obj) {
      return true;
    }

    if (obj instanceof Pair) {
      Pair pair = (Pair) obj;
      return key == pair.getKey() && value == pair.getValue();
    }

    return false;
  }

  public Integer hashCode() {
    Integer prime = 31;
    Integer result = 1;
    result = prime * result + ObjectUtils.hashCode(key);
    result = prime * result + ObjectUtils.hashCode(value);
    return result;
  }

  public override String toString() {
    return '{' + key + ',' + value + '}';
  }
}