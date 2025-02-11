@isTest
public class DX_TenantIdHelperTest {
    
    @isTest
    static void testGenerateTenantId() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        DX_TenantIdHelper.FlowInput flowInput = new DX_TenantIdHelper.FlowInput();
        flowInput.accountId = testAccount.Id;
        flowInput.accountName = testAccount.Name;

        List<DX_TenantIdHelper.FlowInput> inputList = new List<DX_TenantIdHelper.FlowInput>{ flowInput };
        Test.startTest();
        List<String> tenantIds = DX_TenantIdHelper.generateTenantId(inputList);
        Test.stopTest();

        System.assertNotEquals(tenantIds.size(), 0);
        System.assert(tenantIds[0].length() > 0);
        
        String accountIdString = String.valueOf(testAccount.Id);
        String expectedTenantId = testAccount.Name.substring(0, 3) + accountIdString.substring(accountIdString.length() - 2);
        System.assertEquals(tenantIds[0], expectedTenantId);
    }

    @isTest
    static void testGenerateTenantIdWithSpecialCharacters() {
        Account testAccount = new Account(Name = 'Test Account! #123');
        insert testAccount;

        DX_TenantIdHelper.FlowInput flowInput = new DX_TenantIdHelper.FlowInput();
        flowInput.accountId = testAccount.Id;
        flowInput.accountName = testAccount.Name;

        List<DX_TenantIdHelper.FlowInput> inputList = new List<DX_TenantIdHelper.FlowInput>{ flowInput };
        Test.startTest();
        List<String> tenantIds = DX_TenantIdHelper.generateTenantId(inputList);
        Test.stopTest();

        String accountIdString = String.valueOf(testAccount.Id);
        String expectedTenantId = testAccount.Name.replaceAll('[^a-zA-Z0-9\\s+]', '').substring(0, 3) + accountIdString.substring(accountIdString.length() - 2);
        System.assertEquals(tenantIds[0], expectedTenantId);
    }
    
   
}