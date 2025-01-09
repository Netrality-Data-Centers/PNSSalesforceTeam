/**
 * @Description       : 
 * @Author            : cristianivan.ruiz@salesforce.com
 * @Code Coverage     : 
 * @last modified on  : 12-18-2024
 * @last modified by  : cristianivan.ruiz@salesforce.com
**/
@IsTest
public with sharing class DX_PanelSelectorFloorPOE_tst {
    @testSetup
    static void setup() {

        // Create a new Building__c record
        Building__c building = new Building__c(Name = 'Test Building');
        insert building;

        // Create a new DC_Floor__c record
        DC_Floor__c Floor = new DC_Floor__c(Name = 'Test Floor', Building__c = building.Id , Floor_Number__c = 1, Short_Name__c = 'FL', Total_Square_Feet__c = 4);
        insert Floor;

        // Create a new DC_POE__c record
        DC_POE__c poe = new DC_POE__c(Name = 'POE ', Floor__c = Floor.Id);
        insert poe;

    }

    @IsTest
    static void testGetFloor() {
        Building__c building = [SELECT Id FROM Building__c LIMIT 1];
        
        Test.startTest();
        List<DX_DCIM_DataAccess.wrapperResult> lstwrapperResult = DX_PanelSelectorFloorPOE_ctr.getFloors(building.Id);
        Test.stopTest();
        
        System.assertEquals(1, lstwrapperResult.size());
    }

    @IsTest
    static void testGetPOES() {
        DC_Floor__c Floor = [SELECT Id FROM DC_Floor__c LIMIT 1];
        
        Test.startTest();
        List<DX_DCIM_DataAccess.wrapperResult> lstwrapperResult = DX_PanelSelectorFloorPOE_ctr.getPOES(Floor.Id);
        Test.stopTest();
        
        System.assertEquals(1, lstwrapperResult.size());
    }

}