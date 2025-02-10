@isTest
public class CaseRelatedAssetSelectionControllerTest {
    @isTest(SeeAllData=true)
    static void testGetRelatedAssets() {
        // Test with a Case having DX_Service_Order__c
        Case testCase = [SELECT Id FROM Case LIMIT 1];
        Test.startTest();
        Map<String, Object> result = CaseRelatedAssetSelectionController.getRelatedAssets(testCase.Id);
        Test.stopTest();
        System.assertNotEquals(null, result);
        // System.assertEquals('Test Case', result.get('caseName'));
        // System.assertNotEquals(null, result.get('assets'));
    }
    
    @isTest(SeeAllData=true)
    static void testGetRacksForRackRow() {
        //DC_Rack_Row__c rackRow = [SELECT Id FROM DC_Rack_Row__c LIMIT 1];
        Test.startTest();
        List<DC_Rack__c> result = CaseRelatedAssetSelectionController.getRacksForRackRow('change me');
        Test.stopTest();
        //System.assertNotEquals(null, result);
    }
    
    @isTest(SeeAllData=true)
    static void testGetPanelsForRackRow() {
        //DC_Rack_Row__c rackRow = [SELECT Id FROM DC_Rack_Row__c LIMIT 1];
        Test.startTest();
        List<DC_Panel__c> result = CaseRelatedAssetSelectionController.getPanelsForRackRow('change me');
        Test.stopTest();
        //System.assertNotEquals(null, result);
        
    }
    
    
}