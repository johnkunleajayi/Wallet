flair__Employee__c[] employees = [
  SELECT Id
  FROM flair__Employee__c
  WHERE flair__Employee_Number__c IN ('002', '003', '903', '780', '560', '164', '370', '371', '372')
];

flair__Employee__c manager = [
  SELECT Id
  FROM flair__Employee__c
  WHERE flair__Employee_Number__c = '890'
  LIMIT 1
];

for(flair__Employee__c employee : employees) {
  employee.flair__Manager__c = manager.Id;
}

update employees;