@isTest
public class CaseRelatedAssetSelectionControllerTest {
    @testSetup
    static void setupTestData() {
        //     RecordType
        //     Account metaAccount = [SELECT Id FROM Account WHERE Name = 'Meta' LIMIT 1];
        //     System.debug('metaAccount: ' + metaAccount);
        //     // Create test Opportunity
        //     Opportunity testOpp = [SELECT Id FROM Opportunity WHERE AccountId = :metaAccount.Id LIMIT 1];
        //     System.debug('testOpp: ' + testOpp);
        
        //     Quote testQuote = new Quote(Name = 'Test Quote', OpportunityId = testOpp.Id, Commencement_Date__c = Date.today().addDays(30), Term__c = String.valueOf(12));
        //     insert testQuote;
        //     System.debug('testQuote: ' + testQuote);
        
        //     // Create test Case
        //     Case testCase = new Case(Subject = 'Test Case', DX_Service_Order__c = testQuote.Id);
        //     insert testCase;
        //     System.debug('testCase: ' + testCase);
        
        //     // Create test Assets
        //     Asset testAsset = new Asset(Name = 'Test Asset', Service_Order__c = testCase.DX_Service_Order__c);
        //     insert testAsset;
        //     System.debug('testAsset: ' + testAsset);
        //     // Create test DC_Rack__c
        //     DC_Rack__c testRack = new DC_Rack__c(Name = 'Test Rack', Rack_Row__c = 'TestRackRow', Number_of_Rack_Units__c = 42);
        //     insert testRack;
        //     System.debug('testRack: ' + testRack);
        //     // Create test DC_Panel__c
        //     DC_Panel__c testPanel = new DC_Panel__c(Name = 'Test Panel', Rack__c = testRack.Id, Height_RU__c = 2, Starting_Position_RU__c = 1);
        //     insert testPanel;
        //     System.debug('testPanel: ' + testPanel);
        //     // Create test RDraw__Interaction_Definition__c
        RDraw__Interaction_Definition__c testInteractionDef = new RDraw__Interaction_Definition__c(RDraw__Name__c = 'Test Interaction Definition', RDraw__Type__c = '2D_Scene_Settings', RDraw__Associated_Object__c = 'DC_Rack_Row__c', RDraw__Settings__c = '{}');
        insert testInteractionDef;
        System.debug('testInteractionDef: ' + testInteractionDef);
    }
    
    @isTest
    static void testGetRelatedAssets() {
        // Test with a Case having DX_Service_Order__c
        Test.startTest();
        Map<String, Object> result = CaseRelatedAssetSelectionController.getRelatedAssets('XXXXXXXXXXXXXXXXXX');
        Test.stopTest();
        System.assertNotEquals(null, result);
        // System.assertEquals('Test Case', result.get('caseName'));
        // System.assertNotEquals(null, result.get('assets'));
    }
    
    @isTest
    static void testGetCanvasSceneForRackRow() {
        // Test with valid rackRowId and desiredUSize
        Test.startTest();
        RDraw.CanvasScene scene = CaseRelatedAssetSelectionController.getCanvasSceneForRackRow('TestRackRow', 1);
        Test.stopTest();
        System.assertNotEquals(null, scene);
    }
    
    @isTest
    static void testGetRackRowTemplateInteractionDefinition() {
        // Test the retrieval of the interaction definition
        Test.startTest();
        RDraw__Interaction_Definition__c interactionDef = CaseRelatedAssetSelectionController.getRackRowTemplateInteractionDefinition();
        Test.stopTest();
        System.assertNotEquals(null, interactionDef);
    }
}