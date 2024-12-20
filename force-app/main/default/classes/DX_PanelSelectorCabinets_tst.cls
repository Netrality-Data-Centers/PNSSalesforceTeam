/**
 * @Description       : 
 * @Author            : cristianivan.ruiz@salesforce.com
 * @Code Coverage     : 
 * @last modified on  : 12-18-2024
 * @last modified by  : cristianivan.ruiz@salesforce.com
**/
@IsTest
public class DX_PanelSelectorCabinets_tst {
    @testSetup
    static void setup() {

        // Create a new Building__c record
        Building__c building = new Building__c(Name = 'Test Building');
        insert building;

        // Create a new DC_Floor__c record
        DC_Floor__c Floor = new DC_Floor__c(Name = 'Test Floor', Building__c = building.Id , Floor_Number__c = 1, Short_Name__c = 'FL', Total_Square_Feet__c = 4);
        insert Floor;

        // Insert a test Data Hall
        DC_Data_Hall__c dataHall = new DC_Data_Hall__c(Name = 'Test Data Hall', DC_Floor__c = Floor.Id, Short_Name__c = 'test');
        insert dataHall;
        
        // Insert a test Cage
        DC_Cage__c cage = new DC_Cage__c(Name = 'Test Cage', Data_Hall__c = dataHall.Id, Type__c = 'Pod', MRI_Suite_ID__c = '34', Short_Name__c = 'CE');
        insert cage;
        
        // Insert a test Cabinet
        DC_Cabinet__c cabinet = new DC_Cabinet__c(Name = 'Test Cabinet', Cage__c =  cage.Id, Status__c = 'Occupied', Cabinet_Equivalent__c = 2, Depth_in__c = 2, Height_RU__c = 1, MRI_Suite_ID__c = '245', Short_Name__c = 'CT', Width_in__c = 3);
        insert cabinet;
    }

    @IsTest
    static void testGetFloor() {
        Building__c building = [SELECT Id FROM Building__c LIMIT 1];
        
        Test.startTest();
        List<DX_DCIM_DataAccess.wrapperResult> lstwrapperResult = DX_PanelSelectorCabinets_ctr.getFloors(building.Id);
        Test.stopTest();
        
        System.assertEquals(1, lstwrapperResult.size());
    }

    @IsTest
    static void testGetDataHall() {
        DC_Floor__c Floor = [SELECT Id FROM DC_Floor__c LIMIT 1];
        
        Test.startTest();
        List<DX_DCIM_DataAccess.wrapperResult> lstwrapperResult = DX_PanelSelectorCabinets_ctr.getDataHalls(Floor.Id);
        Test.stopTest();
        
        System.assertEquals(1, lstwrapperResult.size());
    }
    
    @IsTest
    static void testGetCages() {
        DC_Data_Hall__c dataHall = [SELECT Id FROM DC_Data_Hall__c LIMIT 1];
        
        Test.startTest();
        List<DX_DCIM_DataAccess.wrapperResult> lstwrapperResult = DX_PanelSelectorCabinets_ctr.getCages(dataHall.Id);
        Test.stopTest();
        
        System.assertEquals(1, lstwrapperResult.size());
    }
    
    @IsTest
    static void testGetCabinets() {
        DC_Cage__c cage = [SELECT Id FROM DC_Cage__c LIMIT 1];
        
        Test.startTest();
        List<DX_DCIM_DataAccess.wrapperResult> lstwrapperResult = DX_PanelSelectorCabinets_ctr.getCabinets(cage.Id);
        Test.stopTest();
        
        System.assertEquals(1, lstwrapperResult.size());
    }
}