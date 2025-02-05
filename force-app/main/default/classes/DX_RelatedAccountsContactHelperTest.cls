@isTest
public with sharing class DX_RelatedAccountsContactHelperTest {
   

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
    public static void getRelatedAccountsforContactTest() {
        List<AccountContactRelation>contacts=[SELECT ID, AccountId, ContactId FROM AccountContactRelation];
        DX_RelatedAccountsContactHelper.FlowInput inputX = new DX_RelatedAccountsContactHelper.FlowInput();
        inputX.contactId = contacts[0].ContactId;
        List<List<Id>> listids = DX_RelatedAccountsContactHelper.getRelatedAccountsforContact(new List<DX_RelatedAccountsContactHelper.FlowInput> {inputX});
        system.assert(listids.size()>0, 'Primary Account Id has not been retrieved.');
    }
}