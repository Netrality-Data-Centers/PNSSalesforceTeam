@IsTest
public class DX_viewOpenServiceRequest_tst {
@testSetup
    static void setup() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'testcontact@example.com',
            AccountId = testAccount.Id
        );
        insert testContact;
        
        // Create a test user
        User testUser = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Login User'].Id,
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ContactId = testContact.Id
        );
        insert testUser;

        // Create a test Open Service Request (Case) record
        Case testOpenSR = new Case(
            Subject = 'Test Open Service Request',
            Status = 'Open',
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Access Request').getRecordTypeId(),
            Type = 'Maintenance',
            DX_Site__c = 'Chicago',
            ClosedDate = Date.today()
        );
        insert testOpenSR;
    }

    @IsTest
    static void testGetOpenServiceRequest() {
        User testUser = [SELECT Id FROM User WHERE Username = 'testuser@example.com'];
        System.runAs(testUser) {
            Test.startTest();
            List<Case> result = DX_viewOpenServiceRequest_ctr.getOpenServiceRequest();
            System.assertequals(!result.isEmpty(),false);
            Test.stopTest();
        }
    }
}