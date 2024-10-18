flair__Employee__c[] employees = [
  SELECT Id
  FROM flair__Employee__c
  WHERE flair__Employee_Number__c IN ('002', '003', '903', '780', '560', '164', '370', '371', '372', '890')
];

flair__Employee_Absence_Category__c[] categories = [
  SELECT Id
  FROM flair__Employee_Absence_Category__c
  WHERE flair__Employee__c IN :employees AND Name = 'Vacation days'
];

flair__Absence__c[] absences = new List<flair__Absence__c>();

for (flair__Employee_Absence_Category__c category : categories) {
  Integer randomNumber1 = Integer.valueof((Math.random() * 100));
  Integer randomNumber2 = Integer.valueof((Math.random() * 10));

  Date startDate = Date.today().addDays(randomNumber1);
  Date endDate = startDate.addDays(randomNumber2);

  absences.add(
    new flair__Absence__c(
      flair__Employee_Absence_Category__c = category.Id,
      flair__Start_Date__c = startDate,
      flair__End_Date__c = endDate,
      flair__Start_Time__c = TimeUtils.startOfDay(),
      flair__End_Time__c = TimeUtils.endOfDay()
    )
  );
}

for (flair__Employee_Absence_Category__c category : categories) {
  Integer randomNumber1 = Integer.valueof((Math.random() * 10));
  Integer randomNumber2 = Integer.valueof((Math.random() * 10));

  Date startDate = Date.today().addDays(-1 * randomNumber1);
  Date endDate = startDate.addDays(randomNumber2);

  absences.add(
    new flair__Absence__c(
      flair__Employee_Absence_Category__c = category.Id,
      flair__Start_Date__c = startDate,
      flair__End_Date__c = endDate,
      flair__Start_Time__c = TimeUtils.startOfDay(),
      flair__End_Time__c = TimeUtils.endOfDay()
    )
  );
}

insert absences;