@IsTest
public class DX_viewClosedServiceRequest_tst {
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
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community Login User Custom'].Id,
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

        // Create a test Closed Service Request (Case) record
        Case testClosedSR = new Case(
            Subject = 'Test Closed Service Request',
            Status = 'Open',
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Access Request').getRecordTypeId(),
            Type = 'Maintenance',
            DX_Site__c = 'Chicago',
            ClosedDate = Date.today()
        );
        insert testClosedSR;
        
        testClosedSR.Status = 'Closed';
        update testClosedSR;
    }

    @IsTest
    static void testGetClosedServiceRequest() {
        User testUser = [SELECT Id FROM User WHERE Username = 'testuser@example.com'];
        System.runAs(testUser) {
            Test.startTest();
            List<Case> result = DX_viewClosedServiceRequest_ctr.getClosedServiceRequest();
            System.assertequals(!result.isEmpty(),false);
            Test.stopTest();
        }
    }
}