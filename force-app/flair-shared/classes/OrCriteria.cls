public class OrCriteria implements ISOQLCriteria {
  private List<ISOQLCriteria> conditions;

  public OrCriteria(ISOQLCriteria[] conditions) {
    this.conditions = conditions;
  }

  public String toSOQL() {
    return SOQLCriteriaUtils.joinWithOr(conditions);
  }
}