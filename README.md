Wallet UI for Gangsmate.

Create an Apex Class: UserSearchController

public with sharing class UserSearchController {
    @AuraEnabled(cacheable=true)
    public static List<User> findUsers(String searchTerm) {
        if (String.isBlank(searchTerm)) {
            return new List<User>();
        }

        // Query users whose name matches the search term
        return [
            SELECT Id, Name 
            FROM User 
            WHERE Name LIKE :('%' + searchTerm + '%') 
            LIMIT 10
        ];
    }
}
