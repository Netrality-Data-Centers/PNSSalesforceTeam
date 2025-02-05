@isTest
public with sharing class DX_PrimaryAccountContactHelperTest {
    
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
        
    }

    @isTest
    public static void getPrimaryAccountforContactTest() {
        List<AccountContactRelation>contacts=[SELECT ID, AccountId, ContactId FROM AccountContactRelation];
        for (AccountContactRelation contactR : contacts) {
            contactR.Roles = 'Primary Contact';
        } 
        update contacts;
        Test.startTest();
        DX_PrimaryAccountContactHelper.FlowInput inputX = new DX_PrimaryAccountContactHelper.FlowInput();
        inputX.contactId = contacts[0].ContactId;
        List<Id>  ids = DX_PrimaryAccountContactHelper.getPrimaryAccountforContact(new List<DX_PrimaryAccountContactHelper.FlowInput> {inputX});
        system.assert(ids.size()>0, 'Primary Account Id has not been retrieved.');
        Test.stopTest();

    }

}